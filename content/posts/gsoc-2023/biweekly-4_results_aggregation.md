---
title: '(again bi)weekly GSOC-4: finally about results aggretation'
date: 2023-08-14
# permalink: /posts/2023/06/gsoc-biweekly-4/
tags:
  - gsoc
  - coding
  - mdanalysis
  - multiprocessing
  - dask
  - clean code
---

In the last [blogpost](https://marinegor.github.io/posts/2023/06/gsoc-biweekly-3/), I explained how I decided to lift the parallelization class up, and how `AnalysisBase.run()` method changed after introducing this.

Here, I will (finally) talk about aggregating results from different worker objects, and how to make the implementation more explicit while not making people who create subclasses write a lot of boilerplate code.


## What are we trying to do?
We're not looking on how to aggregate results from independent `AnalysisBase._compute()` methods. Also, we want `conclude()` methods of subclasses to run as they used to, so after we run our aggregation, `results` and all other attributes should look exactly as if we'd run `run(backend='local')`.

Looking at the `_compute()` method signature, we can see that it returns `self` (`AnalysisBase`). Also, the main object we want to return is whatever the type of `results` is. Usually it is `MDAnalysis.analysis.Results` object (basically, a fancy `dict`), although for some old classes it might be `np.ndarray` or just a `list`.

So, we're looking for something like this:

```python
def aggregate(remote_objects: list[AnalysisBase]) -> Results:
	...
```

Note that we have an ordered sequence of remote results, and can rely on this fact when aggregating the result without the need to match frame indices with respective results.

## First ideas
First thought that came at least to me looked like this: let's take first object of `remote_objects` as a template, and based on how it looks like (=its type), try to do aggregation for it. Something like this:

```python
def merge(remote_objects: list[AnalysisBase]) -> Results:
	template: Results | list | np.ndarray = remote_objects[0].results
	if isinstance(template, list):
		remote_results = [obj.results for obj in remote_objects]
		flat_results = flatten_arrays(objects_to_flatten)
	elif isinstance(template, np.ndarray):
		remote_results = np.array([obj.results for obj in remote_objects])
		flat_results = np.hstack(remote_results)
	elif isinstance(template, Results):
		...
	else:
		raise ValueError('unknown results type')

def flatten_arrays(arrs: list[list]) -> list:
	return [obj for sublist in arrs for obj in sublist]
```

A little bit more complicated if `isinstance(remote_results, Results)`. Since `Results` is basically a dictionary, we have to go over its keys and do proper aggregation for each of them:

```python
... 
elif isinstance(template, Results):
	for key, obj_of_type in template.items():
		results_of_key = [obj.results[key] for obj in remote_objects]
		if isinstance(obj_of_type, list):
			flat_results = flatten_arrays(results_of_key)
		elif isinstance(obj_of_type, np.ndarray):
			flat_results = np.hstack(np.array(results_of_key))
		elif isinstance(obj_of_type, float):
			...
		else:
			raise ValueError("couldn't find aggregation function")
```

## Why first ideas are bad
The code above is probably already ugly for an experienced eye -- for instance, we're repeating ourselves quite a few times and have many nested `if-elif-else` parts that look super ugly. However, there's a more important flaw here from the library point -- if a subclass wants to have a custom aggregation function for its attribute, there is now way to conveniently reuse the base class method. Also, sometimes we can have different aggregation functions even if the objects have the same type -- some `ndarray`-s have to be averaged, some simply summed, etc. The only other thing we have to distinguish results from each other is the attribute name, so we must base our aggregation on them.

To sum up, we actually don't want to do any type matching (and ugly `if-elif-else` branches), but instead want to:

 - rely on the attribute name, not type
 - provide a reusable library of basic aggregation functions
 - allow users to easily create their own aggregation functions without copying our boilerplate

## Good ideas: another new class
So we want to aggregate results based on attribute name, and also store somewhere a list of pre-determined functions that do this. We probably would be fine with a complicated function that stores everything, but since we want to also store different aggregation functions somewhere, let's create a simple class which `staticmethod`s would be different aggregation functions, and one useful method would be our `merge` from above:

```python
class ResultsGroup:
	def merge(self, remote_objects: list[AnalysisBase]) -> Results:
		...
	
	@staticmethod
	def flatten_arrays(arrs: list[list]) -> list:
		return [obj for sublist in arrs for obj in sublist]
	
	@staticmethod
	def ndarray_sum(arrs: list[np.ndarray]) -> np.ndarray:
		return np.array(arrs).sum(axis=0)

	@staticmethod
	def ndarray_stack(arrs: list[np.ndarray]) -> np.ndarray:
		return np.hstack(arrs)
	
	@staticmethod
	def ndarray_mean(arrs: list[np.ndarray]) -> np.ndarray:
		return np.array(arrs).mean(axis=0)
	
	...
```

But how do we initialize the class? Well, we want to be able to call our `merge` method right after we initialize it, so all the information on how to match attribute name with respective aggregation function should be given upon initialization. Hence, `__init__` should look like this:

```python
class ResultsGroup:
	def __init__(self, lookup: dict[str, Callable]):
		self._lookup = lookup
```

### Sidenote: `Results` are cool!
Before we get into the final look of `merge`, let's remember that `Results` is actually a very cool class. Namely, it allows us to track which attributes we added to the object without changing the attribute access interface. In other words, we can make our results a `Results` object from the very beginning (namely, in `_prepare` method call), and then whatever got assigned, will be accessible in `results.keys()`! We'll simply add line `self.results = Results()` in `AnalysisBase._prepare`.


### Keep writing `merge()`
Given the coolness of the `Results`, now we can rely on the fact that we know for sure which attributes got assigned, and easily iterate through them. Also, since all `remote_objects` have the same `results` outline, we can pick the first one as an example, and then be sure that the rest have the same outline:

```python
class ResultsGroup:
	def __init__(self, lookup: dict[str, Callable]):
		self._lookup = lookup
	
	def merge(self, remote_objects: list[AnalysisBase]) -> Results:
		rv = Results()

		for key in remote_objects[0].keys():
            agg_function = self._lookup.get(key, None)
            if agg_function is None:
                raise ValueError(f"No aggregation function for {key=}")
            results_of_t = [obj[key] for obj in objects]
            rv[key] = agg_function(results_of_t)
        return rv
	
	# and @staticmethod s with aggregation functions
```

## How will `AnalysisBase.run()` look like?
Before, we had our aggregation function in `_parallel_conclude` method:


```python
class AnalysisBase:
	def run(self, start, stop, step, frames, n_workers, scheduler):
		self._setup_frames(start, stop, step, frames)
		self._prepare()
		computation_groups = self._setup_computation_groups(start, stop, step, frames, n_workers)

		executor = ParallelExecutor(n_workers, scheduler)
		executor.apply(self._compute, computation_groups)

		# THIS ONE
		# --------
		self._parallel_conclude()
		# --------

		self._conclude()
```

now, we can do everything more explicitly:

```python
class AnalysisBase:
	def run(self, start, stop, step, frames, n_workers, scheduler):
		self._setup_frames(start, stop, step, frames)
		self._prepare()
		computation_groups = self._setup_computation_groups(start, stop, step, frames, n_workers)

		executor = ParallelExecutor(n_workers, scheduler)
		remote_objects = executor.apply(self._compute, computation_groups)

		aggregator = ... # will think about it later
		self.results = aggregator.merge(remote_objects)
		self._conclude()
```

Obviously, in order to get an appropriate `ResultsGroup` aggregator, we should call some method of `self`. Well, let's call it exactly like this:

```python
class AnalysisBase:
	def run(self, start, stop, step, frames, n_workers, scheduler):
		...

		aggregator = self._get_aggregator()

		...
	
	def _get_aggregator(self) -> ResultsGroup:
		return ResultsGroup(lookup=None)
```

Now, we're running into a backwards compatibility issue -- now we must have a meaningful `ResultsGroup` aggregator even if we're using only `backend='local'`, without any parallelization. In this case, however, our `remote_objects` is a list with 1 element, and we can simply return it in `merge` method:

```python
class ResultsGroup:
	def __init__(self, lookup: dict[str, Callable]):
		self._lookup = lookup
	
	def merge(self, remote_objects: list[AnalysisBase]) -> Results:
		if len(remote_objects) == 1:
			rv = remote_objects[0]
		else:
			rv = Results()
			for key in remote_objects[0].keys():
  	          agg_function = self._lookup.get(key, None)
  	          if agg_function is None:
  	              raise ValueError(f"No aggregation function for {key=}")
  	          results_of_t = [obj[key] for obj in objects]
  	          rv[key] = agg_function(results_of_t)
  	    return rv
```

note that we won't even screw the function signature up and return the `Results` type still, since we've added `self.results = Results()` in `_prepare()`.

The last touch is that not everything is stored in `results` -- in `_prepare` method, attributes `frames` and `times` are also assigned, so we'll have to merge them manually:

```python
class AnalysisBase:
	def run(self, start, stop, step, frames, n_workers, scheduler):
		self._setup_frames(start, stop, step, frames)
		self._prepare()
		computation_groups = self._setup_computation_groups(start, stop, step, frames, n_workers)

		executor = ParallelExecutor(n_workers, scheduler)
		remote_objects = executor.apply(self._compute, computation_groups)

		# manually merge `frames` and `times`
        self.frames = np.array([obj.frames for obj in remote_objects]).sum(axis=0)
        self.times = np.array([obj.times for obj in remote_objects]).sum(axis=0)

		# apply ResultsGroup.merge()
		aggregator = self._get_aggregator()
		self.results = aggregator.merge(remote_objects)
		self._conclude()
```
And that's it, a final look of `AnalysisBase.run()`!

## How do I modify subclasses then?
For instance, let's modify a `MDAnalysis.analysis.rms.RMSD` class so that it would work with our parallel backend. It has a huge `_prepare` method, but the only attribute that actually gets prepared is `self.results.rmsd` -- it's initialized with zeros of a proper shape:

```python
self.results.rmsd = np.zeros((self.n_frames,
							 3 + len(self._groupselections_atoms)))
```

hence, in all but one remote objects value of `self.results.rmsd` will be zero, and we can simply add all results together to get a final result!

Let's do that, and also add `available_backends`:

```python
class RMSD(AnalysisBase):
	...

	@classmethod
	@property
	def available_backends(cls):
		return ('local', 'multiprocessing', 'dask', 'dask.distributed')
	
	def _get_aggregator(self):
		return ResultsGroup(lookup={'rmsd': ResultsGroup.ndarray_sum})
```

and that's it! And the function we've specified here in `lookup` has a super simple signature -- `Callable[list[T], T]`, and all the built-in functions have literally a single line of code in them.

## Conclusion
In this post, we've finally finished writing our `AnalysisBase.run()` protocol via adding a `ResultsGroup` class. It accepts a `dict[str, Callable[list[T], T]]` lookup argument, which maps attribute name to a proper aggregation function. Its `merge` method does exactly one job -- flattens the results of all `objects` that got passed into it.

Altogether, our `AnalysisBase.run()` has changed by addition of the following methods: `_compute()`, `_setup_computation_groups()`, `_get_aggregator()` and `available_backends()`. We've added `ParallelExecutor` and `ResultsGroup` classes that abstract away parallel execution and results aggregation, respectively. And finally, we added `multiprocessing` and `dask` backends that are supposed to speed up the analysis!

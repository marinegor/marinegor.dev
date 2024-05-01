---
title: 'Biweekly GSOC-2: splitting the work and writing `_setup_bslices`'
date: 2023-06-30
description: 'Second biweekly GSOC blogpost'
# permalink: /posts/2023/06/gsoc-biweekly-2/
tags:
  - gsoc
  - coding
  - mdanalysis
---

In the previous [blogpost](https://marinegor.github.io/posts/2023/06/gsoc-biweekly-1), I briefly explained how I'm planning to decompose the `AnalysisBase.run()` method, so that its subclasses won't notice the changes in the protocol, but at the same time will be able to perform computations in a parallel manner.

Here I'll go through the implementation details of some methods -- namely, I'll explain how I went to a certain implementation of `_setup_bslices`, `_compute` and `run`.


## Where are we right now?

At this moment, the `AnalysisBase.run()` method looks roughly like this:

```python
def run(self, start, stop, step, frames):
	"""
	Perform the calculation
	"""
	self._setup_bslices(...)
	computations = []
	for bslice in self._bslices:
		start, stop, step, frames = bslice
		computations.append(delayed((self._compute)(start, stop, step, frames)))
	results = computations.compute()
	self._remote_results = results
	self._parallel_conclude()
	
	self._conclude()
	return self
```

Let's think of how `_setup_bslices` should look like -- which arguments it has and what it returns, or which attributes of `self` modifies?

Well, clearly, it should know about the computation limits defined earlier in the `run` itself. Also, it should know about the scheduling parameters, in order to be able to distribute the load more or less evenly. Also, we know that we'll iterate over `self._bslices` in the `run()`, so we want to assign this attribute at the end. So, something like that:


```python
def _setup_bslices(self, start, stop, step, frames, scheduler):
	n_parts = some_function_of(scheduler)
	bslices = split_evenly(start, stop, step, frames)
	self._bslices = bslices
```

Now, the first part with `n_parts = ...` is actually simple. For now, for clarity, we'll just specify `scheduler` as a string that represents the scheduling backend -- either additionally installed `dask`, built-in `multiprocessing`, or `None` representing execution in the current process, and `n_parts` will be `n_workers` -- a parameter of a scheduler.

## What are we actually splitting?

In order to split the work correctly, we need to know how exactly it looks like. In MDAnalysis, there are 2 mutually exclusive ways to define which frames you want to analyze:

- `start, stop, step` -- a triplet of integer numbers with semantics similar to those in `range`
- `frames` -- an iterable that works as a `slice` over trajectory. Can be of two kinds: 
  - `frames: Iterable[int]` -- an iterable with numbers of frames for analysis. For example, `frames = list(range(0, len(trajectory)))` will be equivalent to `start=0, stop=len(trajectory), step=1`
  - `frames: Iterable[bool]` -- an iterable with boolean values that define which frames to take into account. For example, `frames = [bool(i%2) for i in range(len(trajectory))]` is equivalent to `start=1, stop=len(trajectory), step=2`

Now our task is to accept one of those parameters, and correctly split it into roughly equal parts, each of which will go to a separate worker. First of all, let's simplify our task and note that accepting `start, stop, step` is equivalent to `frames = list(range(start, stop, step))`. Moreover, using `frames: Iterable[bool]` is actually equivalent to using `frames: Iterable[int] = np.arange(len(trajectory))[frames]`. Now it's the only case we have to work with! Neat.

In order to split an iterable into `n` equal parts, one could start writing some iterator-based functions in python, spend some time debugging it, etc -- just like I did initially. Or be slightly smarter and google an appropriate function -- turns out, `np.array_split` does exactly what we need.

Now, the splitting function needs to first match the type of our parameters, and then apply `np.array_split` single split. Something like this:

```python
def split_work_into_parts(n_parts: int = 1, start=None, stop=None, step=None, frames=None):
	if any([opt is not None for opt in (start, stop, step)]): # using `start-stop-step` notation
		frames = np.arange(start, stop, step)
	else: # using `frames` notation
		if is_iterable_of_booleans(frames):
			frames = np.arange(len(frames))[frames]

	frames = np.array_split(frames, n_parts)
	return frames
```

where `is_iterable_of_booleans(frames: Iterable)` looks something like:

```python
def is_iterable_of_booleans(arr: Iterable):
	return all((isinstance(obj, bool) for obj in arr))
```

Unfortunately for us, we can't simply use the result of `split_work_into_parts` -- we not only need to split the frames evenly, but we also have to keep track of frame indices we're using, since in `_compute` we're explicitly assigning `self._frame_index = i`. Hence, we have to use something like `enumerate` before creating balanced slices, and make our function slightly more complicated:


```python
def split_work_into_parts(n_parts: int = 1, start=None, stop=None, step=None, frames=None):
	if any([opt is not None for opt in (start, stop, step)]): # using `start-stop-step` notation
		frames = np.arange(start, stop, step)
	else: # using `frames` notation
		if is_iterable_of_booleans(frames):
			frames = np.arange(len(frames))[frames]

	frames = np.array(list(enumerate(frames)))
	frames = np.array_split(frames, n_parts)
	return frames
```

Neat! Now we can get back to writing `_setup_bslices`.

## Writing `_setup_bslices` and using `self._bslices`

Given all functions above, the target method will now look like this:

```python
def _setup_bslices(self, start, stop, step, frames, n_workers):
	equal_iterables = split_work_into_parts(n_parts=n_workers, start, stop, step, frames)
	self._bslices = equal_iterables
```

Now, we want to use these `bslices` in `run` method. We could get both indices and frames from `self._bslices` and then use them when creating list of computations, but since `self._bslices` will anyway get passed to the worker objects, let's just use a bslice index for assigning work, hence simplifying the `run` code. Like this:

```python
def run(self, start, stop, step, frames, n_workers, scheduler):
	self._setup_frames(start, stop, step, frames)
	self._prepare()
	self._setup_bslices(start, stop, step, frames, n_workers)

	if scheduler is None:
		# we have no worker processes and only one `bslice`
		self._compute(bslice_idx=0)
	else:
		from dask.delayed import delayed
		computations = [delayed(self._compute)(bslice_idx) for bslice_idx in range(len(self._bslices))]
		results = computations.compute()
		self._remote_results = results
		self._parallel_conclude()
	
	self._conclude()
```

And usage of `_compute` will also slightly change, since we're using bslice_idx instead of original `run`-inherited syntax:

```python
def _compute(self, bslice_idx):
	bslice = self._bslices[bslice_idx]
	frame_indices, frames = bslices[:, 0], bslices[:, 1]
	    for idx, ts in enumerate(trajectory):
        i = frame_indices[idx]
        self._frame_index = i
        self._ts = ts
        self.frames[i] = ts.frame
        self.times[i] = ts.time
        self._single_frame()
```

And that's it! This is really the core protocol of the `AnalysisBase.run()` method.

## Conclusion
We now know crucial part of the parallelization works -- splitting work into equal parts and communicating between those parts. We haven't yet touched on aggregation of these results -- we only know that all workers, together with their results, will be stored in `self._remote_results: list[AnalysisBase]`, but we are yet to find out how to retrieve the main `AnalysisBase` results from these objects.
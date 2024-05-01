---
title: '(not anymore bi)weekly GSOC-3: writing `ParallelExecutor` class'
date: 2023-07-30
# permalink: /posts/2023/06/gsoc-biweekly-3/
tags:
  - gsoc
  - coding
  - mdanalysis
  - multiprocessing
  - dask
  - clean code
---

In the previous [blogpost](https://marinegor.github.io/posts/2023/06/gsoc-biweekly-2/), I briefly explained how decomposition works -- we split all `_single_frame()` runs into independent groups that get executed in parallel. For this, we have `_compute` method that executes the frames group, and `run` method that orchestrates the `_compute` execution.

Here, I will explain how the actual implementation went south, and then evolved into something more complex and simple at the same time.


## What was the problem?

So, the actual implementation of the `run` protocol turned out to be more complicated than I thought. When it was finally ready, the code looked horrible -- especially the `AnalysisBase.run()` method, that had multiple if-else branches that would choose the exact code path depending on scheduler, and also in all  this mess was the logic for the actual `run()`. Even though it worked (I had most of the subclasses working and passing all the tests), it would be a maintainer nightmare, and also adding new features would be close to impossible.

The mentor team noted that, and I had to come up with something that is easier to read, maintain, and add features to.


## How the code looked before the **change** you're talking about?

The code looked roughly like this:

```python
def run(self, start, stop, step, frames, n_workers, scheduler):
	self._setup_frames(start, stop, step, frames)
	self._prepare()
	self._setup_bslices(start, stop, step, frames, n_workers)

	if scheduler is None:
		# we have no worker processes and only one `bslice`
		self._compute(bslice_idx=0)
	elif scheduler == 'multiprocessing':
		import multiprocessing
		...
	else:
		from dask.delayed import delayed
		computations = [delayed(self._compute)(bslice_idx) for bslice_idx in range(len(self._bslices))]
		results = computations.compute()
		self._remote_results = results
		self._parallel_conclude()
	
	self._conclude()
```

And `_compute` method looked like this:

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

As you can see, there is an ugly `if-elif-else` part of `run` method, and it's not exactly clear what is happening in each of the branches (and how to test and debug it). However, all these branches are doing exactly the same thing: they apply a function to a list of computations in a parallel fashion. 

## What do we do?

What if we moved this functionality outside of the `AnalysisBase` class? Upon initialization, user would be able to configure its parallelization options, and then its `apply` method would execute computations with pre-configured parameters. Something like this:

```python
class ParallelExecutor:
	def __init__(self, n_workers, scheduler):
		self.n_workers = n_workers
		self.scheduler = scheduler
	
	def apply(self, func, computations) -> list:
		if self.scheduler == 'local':
			return [func(task) for task in computations]
		elif self.scheduler == 'multiprocessing':
			import multiprocessing
			with multiprocessing.Pool(self.n_workers) as pool:
				return list(pool.map(func, computations))
		elif self.scheduler == 'dask':
			import dask
			from dask.delayed import delayed
			func_d = delayed(func)
			return delayed([func_d(task) for task in computations]).compute(n_workers=self.n_workers)
		else:
			raise ValueError('wrong scheduler')
```		

The `run` method would look somewhat like this:

```python
def run(self, start, stop, step, frames, n_workers, scheduler):
	self._setup_frames(start, stop, step, frames)
	self._prepare()
	bslices = self._setup_bslices(start, stop, step, frames, n_workers)

	executor = ParallelExecutor(n_workers, scheduler)
	executor.apply(self._compute, bslices)
	
	self._parallel_conclude()
	self._conclude()
```

Ok, this looks much simpler! Now we can clearly see what's going on during `run`, without unnecessary configuration logic.

Minor thing is that we haven't completely got rid of the ugly `if-elif-else` part. Major problem is that it's not (that) easily tested -- you have to get inside a function, and then inside a particular condition. As long as we're having conditions such as `if str1 == str2`, it's not a problem, but we might have something more complicated in the future, and for this reason need to have separate functions for each computation type:

```python
class ParallelExecutor:
	def __init__(self, n_workers, scheduler, client):
		self.n_workers = n_workers
		self.scheduler = scheduler
	
	def _compute_with_local(self, func, computations):
		return [func(task) for task in computations]

	def _compute_with_dask(self, func, computations):
		import dask
		from dask.delayed import delayed
		func_d = delayed(func)
		return delayed([func_d(task) for task in computations]).compute(n_workers=self.n_workers)

	def _compute_with_multiprocessing(self, func, computations):
		import multiprocessing
		with multiprocessing.Pool(self.n_workers) as pool:
			return list(pool.map(func, computations))
```

How do we now match it? Well, if we don't want our code to smell but still want to map pre-configured options to the desired code path, let's use a general mapping object -- dictionary:

```python
class ParallelExecutor:
	...

	def apply(self, func, computations):
		computation_options = {
			self._compute_with_local: self.scheduler == 'local',
			self._compute_with_dask: self.scheduler == 'dask',
			self._compute_with_multiprocessing: self.scheduler == 'multiprocessing',
		}
		for applicator, condition in computation_options.items():
			if condition:
				return applicator(func, computations)
		raise ValueError('wrong configuration')
```

Cool! No code smell, easy testing, easy usage, potential to be used in other parts of the project.


## Important linguistic changes
Two paragraphs on the naming -- if you're reading this posts few months into the future, you might notice that they use different terminology from the one used in the codebase. Here's the reason for it.

### `bslices --> computation_groups`
This project was inspired by [pmda](https://github.com/MDAnalysis/pmda) and initially borrowed many things from there -- namely, the `bslices` term, which means "balanced slices". More specifically, it means "groups of frames that are then passed to independent worker objects". With this explanation, it's not exactly clear why are they slices and in which way they are balanced, so I decided to rename them into `computation_groups`, and respective method into `AnalysisBase._setup_computation_groups()`.

### `scheduler --> backend`
It's nothing wrong with this term, but it turns out that `dask` uses the same term during standalone computations execution, or configuration of `dask.distributed.Client` object. In `dask`, `scheduler` can be either `synchronous`, `processes` or `threads`, which is vastly different from the usecases in MDAnalysis. In order to avoid confusion, `scheduler` is now called `backend`.


## Conclusion
So, we figured out how to perform parallel computations in a way that a) does not disrupt the flow of the `AnalysisBase.run()` method; b) allows us to reuse a huge chunk of code for completely different purposes. 
However, we're still not finished on how to complete our re-writing of the `run` method -- namely, we haven't yet figured out on how to aggregate the results from independent workers.

To be honest, this (and `pytest`) have been the reason of this post becoming less-than-bi-weekly, and I hope I'll have a proper answer next time. Stay tuned!
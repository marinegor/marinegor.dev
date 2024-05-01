---
title: 'Biweekly GSOC-1: decomposing `AnalysisBase.run()`'
date: 2023-06-16
# permalink: /posts/2023/06/gsoc-biweekly-1/
tags:
  - gsoc
  - coding
  - mdanalysis
---

In the first GSOC-devoted [blogpost](https://marinegor.github.io/posts/2023/05/gsoc-proposal/) I explained the idea behind my proposal and the approximate timeline for its execution.

Here I'll go through the initial implementation stages -- how I decided to decompose the `run()` method for the `AnalysisBase` so that I could paralellize the execution, which changes it'll require, and how not to break all the existing code in the process. Let's go!

# `AnalysisBase` protocol

`AnalysisBase` is a superclass for most of the MDAnalysis objects that perform the actual analysis of trajectories. If we omit some house-keeping arguments, Its current implementation works roughly like this:

```python
class AnalysisBase(object):
	def __init__(self, trajectory):
		"""
		Initialize the run object
		"""
		self._trajectory = trajectory
		self.results = ...
	
	def run(self, start, stop, step, frames):
		"""
		Perform the calculation
		"""
		self._setup_frames(self._trajectory, start=start, stop=stop,
						   step=step, frames=frames)
		self._prepare()

		for i, ts in enumerate(self._sliced_trajectory):
			self._frame_index = i
			self._ts = ts
			self.frames[i] = ts.frame
			self.times[i] = ts.time
			self._single_frame()

		self._conclude()
		return self
	
	def _setup_frames(self, trajectory, start, stop, step, frames):
		"""
		Prepare frames that will be used for the analysis
		"""
		self._sliced_trajectory = ...
		self.start = start
		self.stop = stop
		self.step = step
		self.n_frames = ...
		self.frames = ...
		self.times = ...
	
	def _single_frame(self, ...): # implemented in subclasses
		"""
		Perform calculations on a single frame
		"""
		do_some_computations()
	
	def _prepare(self, ...): # implemented in subclasses
		"""
		Prepare the storage attributes for intermediate results
		"""
		self._intermediate_data = ...
	
	def _conclude(self, ...): # implemented in subclasses
		"""
		Use the intermediate results to create the final ones
		"""
		self.results = some_function_of(self._intermediate_data)
```

Most of the computations happen in the `run` method -- namely, here:

```python
for i, ts in enumerate(self._sliced_trajectory):
	self._frame_index = i
	self._ts = ts
	self.frames[i] = ts.frame
	self.times[i] = ts.time
	self._single_frame()
```

So we must somehow parallelize the `_single_frame()` method, and make it run in separate processes simultaneously.

# Where to apply `dask` parallelization?
The parallelization in `dask`, which was our framework of choice (and also was used earlier in `pmda`), works roughly like this:
```python
from dask.delayed import delayed

@delayed
def simple_computation(x, y):
	do_something()

parameter_space = [(x,y) for x in range(10**6) for y in range(10**6)]
computations = delayed([simple_computation(x, y) for x, y in parameter_space])
results = computations.compute()
```
At the last line, `dask` spawns the computations among all workers -- it serializes the `simple_computation` function and its arguments, sends them to the workers (which are either independent processes or even independent machines), does the computation and returns the results again via serialization.

Unfortunately, our case is a bit more complex than that: `_single_frame` uses many attributes of the `AnalysisBase` class itself -- namely, those that are being set up before the `_single_frame` in the loop, and also those that each subclass might want to set up in their `_prepare` block. Hence, we should serialize the whole class instance, together with all its attributes. But then we can't do `_single_frame` a `delayed` function, because then each `delayed` function will carry the whole serialized class instance with it, and just blow up the memory of any local or remote computer.
Also, `_single_frame()` does some things internally, modifying the class instance, and returns `None` after that. So if we were to make each `_single_frame()` a `delayed` function, we'll gather the `None` values in our `results` after that, which is kind of silly.

So, we should split the computations in parts, and submit each part to its separate worker. Within each part, we'll have our own set of frames for computation, and then will collect all the results from these parts somewhere inside the "main" instance's run. For the purpose of continuity with `pmda`, we'll call these parts **balanced slices**, or **bslices**.

Setting up the frames for the computation in each worker would be a tedious task. Luckily, we have the function exactly for these purposes: `AnalysisBase._setup_frames()` does exactly this! It sets up all the necessary attributes in the class instance in a way that if we run `self.run()` after that, we'll be able to successfully iterate only through frames that were prepared.

# Introducing `_compute()` method
For now, each serialized instance is getting its own set of frames, `bslice`, and works with that. Let's separate all this work into a separate `_compute()` method. How would it look like? 

First, it should explicitly know the frames it was configured to work with -- we'll pass them as arguments. Second, it should configure the class instance for computations -- by running `_setup_frames`. Third, it should run the computation loop -- the one that used to be in the `run` method, and in order for it to run properly, we should run `_prepare()` first
```python
def _compute(self, start, stop, step, frames):
	self._setup_frames(..., start, stop, step, frames)
	self._prepare()
	for i, ts in enumerate(self._sliced_trajectory):
		self._frame_index = i
		self._ts = ts
		self.frames[i] = ts.frame
		self.times[i] = ts.time
		self._single_frame()
	
	return self	
```
Now, since we're explicitly returning `self` here, we will have our `self.results` attribute, and won't loose it while sending it to the other workers.

# Decomposition or `run()`

So, `run` is becoming more complex -- it lacks the computation loop now, but has many other methods to control the computational flow itself. 
The only thing left to do now is to collect all the results together from all the workers. In a way, it's a `_conclude` method for the parallel part, so we'll call it `_parallel_conclude()`, with the whole method now looking like this:

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

How should the `_parallel_conclude()` look like? Well, we have a list of instances of the executed `AnalysisBase` subclass in our `_remote_results` attribute. If each of them has their own `results`, it would look somewhat like this:

```python
def _parallel_conclude(self):
	self.results = some_aggregation_function(self._remote_results)
```

Unfortunately, here we can't avoid subclass-specific implementation -- every computation is different by how it collects its intermediate results (in fact, `AnalysisBase.results` actually has its own `Results` type, which is essentially a dictionary, and can hold arbitrary data). But it's ok, at least the `run` process itself is now parallelized.

# Conclusion
We now have an outline for the parallel execution of the `AnalysisBase.run()` method, which contains proper splitting of the frames into balanced slices, and running the computation loop on each of the balanced slices. We didn't pay much attention to the scheduling part of it, and how it'll affect the control flow, but we'll come back to it later in the future posts of these series!
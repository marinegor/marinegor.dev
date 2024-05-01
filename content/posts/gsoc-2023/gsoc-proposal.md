---
title: 'GSOC 2023: what will I do?'
date: 2023-05-29
description: 'A project proposal, written for GSOC-2023 at MDAnalysis'
# permalink: /posts/2023/05/gsoc-proposal/
tags:
  - gsoc
  - coding
  - mdanalysis
---

This year I applied for the Google Summer of Code program, and luckily was selected as a contributor for [MDAnalysis](https://github.com/MDAnalysis/mdanalysis) with my proposal for a parallel analysis project, extending the idea suggested by the developers.

In this post, I'll briefly describe the proposal itself -- motivation, technical outline, and how I expect things will change for the MDAnalysis users after the successful execution of the proposal idea.

Overview and motivation
======

As you might already know, [MDAnalysis](https://github.com/MDAnalysis/mdanalysis) is a python library for analysis molecular dynamics (MD) trajectories, which is kinda clear from the start if you look at the library's name. In turn, molecular dynamics is an ~~art~~ computational technique for simulation of molecular ensembles at various levels of detail. In structural biology, these ensembles can vary from low-level things like simulation including quantum mechanics approximations (QM/MM) to high level simulations of large systems such as a whole cell organelle or a cell itself (coarse-grained simulations).

Technically, a result of a MD simulation is a *trajectory*  -- a file containing coordinates of all simulated atoms ($10^4-10^8$ atoms) over the course of a whole simulation ($10^4-10^7$ time-steps). Producing such a file is hard and computationally intensive, and requires lots of GPU resources. Often, it's even harder to get insights from these simulations, and requires lots of hypothesis formulation and evaluation, coupled with a data-intensive analysis of these trajectories, where libraries such as MDAnalysis come in handy. 

However, currently MDAnalysis uses a single process to run an analysis of a trajectory. Despite all the efforts for the code optimization, it is hard to keep up with the size of the MD trajectories. Hence, utilizing a parallel approach for the analysis would be the next thing to do.

My proposal focuses exactly on this: I am planning to implement a parallel backend for the MDAnalysis library. The backend is planned to be implemented using [`dask`](https://dask.org) library, allowing users to seamlessly run their analysis either on powerful local machines or various clusters, such as SLURM. There was a proof-of-concept fork of the MDAnalysis library, [pmda](https://github.com/MDAnalysis/pmda), which implemented this idea for a subset of analysis methods implemented in the MDAnalysis. Basically, proposal idea is to refactor pmda methods into the MDAnalysis.


Technical details of the project
======

A key component of the MDAnalysis library is the `AnalysisBase` class, from which all objects that allow user to run an analysis of a trajectory are inherited. Namely, it implements a `run` method, that looks somewhat like that:

```python
def run(self, start=None, stop=None, step=None, frames=None, ...):	
	self._setup_frames(self._trajectory, start=start, stop=stop, step=step, frames=frames)
	
	self._prepare()
	for i, ts in enumerate(self._sliced_trajectory, ...):
		...
		self._single_frame()
	self._conclude()
```

and consists of three steps: 

- setting up frames for reading -- may include options to analyze only a part of the trajectory in `time` coordinate (change time-step, start/stop, etc)
- preparing for the analysis: may include preparation of some arrays storing intermediate data, etc
- running analysis of a single frame 
- and concluding the results -- e.g. average some quantity calculated for each frame separately.

For a setup with multiple worker processes, this protocol will require an additional step of first separating a trajectory into **blocks**. Each block will be processed with a single separate process, and also results from different blocks will potentially be concluded separately:

```python
def run(self, start=None, stop=None, step=None, frames=None, scheduler: Optional[str]=None):
	if scheduler is None:
	# fallback to the old behavior
		self._setup_frames(self._trajectory, start=start, stop=stop, step=step, frames=frames)
		
		self._prepare()
		for i, ts in enumerate(self._sliced_trajectory, ...):
			...
			self._single_frame()
		self._conclude()
		
	else:
		self._configure_scheduler(scheduler=scheduler)
		self._setup_blocks(start=start, stop=stop, step=step, frames=frames) 
		# split trajectory into blocks according to scheduler settings

		tasks = []
		for block in self._blocks:
			# create separate tasks 
			# that would fall back to the old behavior 
			# and schedule them as dask tasks
			subrun = self.__class__(start=block.start, stop=block.stop, step=block.step, frames=block.frames, scheduler=None)
			dask_task = dask.delayed(subrun.run)
			tasks.append(dask_task)
		
		# perform dask computation
		tasks = dask.delayed(tasks)
		res = tasks.compute(**self._scheduler_params)
		self._parallel_conclude()
```

Which requires introducing following methods for the `AnalysisBase` class:

```python
class AnalysisBase(object):
	def _configure_scheduler(self, scheduler=scheduler, **params):
	    ...

	@property
	def _blocks(self):
		...
	
	def _setup_blocks(start=start, stop=stop, step=step, frames=frames):
		# will also update `self._blocks` accordingly
		...

	def _parallel_conclude(...):
		...
```

Which is similar to the protocol implemented in `pmda`. Such a modular design has following advantages:

 - it reuses the previously existing code for `prepare` and `conclude` methods for the subclasses, and hence will successfully run on sub-trajectories
 - it requires developers to introduce only a proper non-default `parallel_conclude` method for sophisticated results combination
 - it allows to raise an exception for subclasses that for some reason don't allow such parallelization (e.g. rely on results from previous frames when computing current one), via re-implementing `_configure_scheduler` and raising an exception in not-`None` cases.


Project steps
======

During the proposal preparation, most of the effort was put into the project planning to ensure some profit for the library even of the overall goal is unreachable within the given time-frame.


## 0. Proof-of-concept for the scheduler-based protocol

This part includes re-writing protocol in `AnalysisBase.run()` as introduced above, but using simplest backend possible -- `dask` running on a local machine with a single job. This way, I can ensure that there are no node communication issues etc, and focus on proper storing of the values in private fields and re-factoring the protocol.

- [ ] introduce `_configure_backend()` and `_setup_blocks()` in a simplest way possible -- single block and one task
- [ ] add simple `_parallel_conclude()` method
- [ ] make sure that results are the same as were before on a `develop` branch for few test files
- [ ] add tests for `n_jobs=1` and test files tested manually

Here I mostly expect problems with the `_setup_blocks()` part, that might introduce nasty `+- 1` errors in the tests. Or might not.

## 1. Introducing multiple jobs support
Next step would be to add complexity and expand `_configure_backend()` to multiple jobs, and ensure it's still working. At this step, I'd expect serialization problems, as well as problems with reading only the necessary part of the trajectory from disk. And, similarly to the previous case, I expect some problems with the `_setup_blocks()`.

- [ ] add scheduler configuration for multiple cores
- [ ] re-write tests for multiple cores
- [ ] ensure the tests run with multiple cores

Also, this step would be a perfect mid-project checkpoint for several reasons:
 - it actually adds value to the library -- if the second part of the project fails, at least the single-node parallelism would be available for users
 - it is complex enough to test the protocol's viability
 - it allows to see the real progress even on moderate workstations

## 2. Introducing cluster support
This step would include adding `_configure_backend()` for an actual cluster including multiple nodes. Likely, this will also include introducing `backend: Optional[obj] = None` instead of `backend: Optional[str] = None`, where `obj` is a `dask` instance that can be configured prior to the actual run. 

During proposal formulation, I expected most challenged here with writing tests, but thanks to the contributors team, I realized it is actually simpler than I thought, and even made up a simple toy repository [`dask-gh-action`](https://github.com/marinegor/dask-gh-actions/) to write dask-based multi-processing tests. 

- [ ] add object-based `backend=...` keyword and respective configuration
- [ ] add tests for the different `backend` options and make sure they run locally

## 3. Optional: adding tests for all `AnalysisBase` subclasses
It is likely that during step 2 proper `pytest` fixtures for `dask`-based execution will be written. Hence, it's worth trying to add these fixtures to existing tests for subclasses of `AnalysisBase` and see if they run, and mark `NotImplemented` those that have valid reasons not to run in parallel.

- [ ] add tests for all `AnalysisBase` subclasses executed with `dask`
- [ ] mark parallel execution for those that can't be run trivially as `NotImplemented` during `_configure_scheduler`

## 4. Optional: testing MDAnalysis parallel execution on a super-large MD trajectory
It would be cool to see the results on a large trajectory such as those from ANTON supercomputer listed [here](https://www.deshawresearch.com/downloads/download_trajectory_sarscov2.cgi/), for example `DESRES-ANTON-11441075` (235 Gb compressed tar). This way we'll actually show that it's possible to analyze things that weren't accessible before with MDAnalysis.

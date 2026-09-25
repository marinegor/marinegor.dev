---
title: "Split-and-combine parallelization for MDAnalysis AnalysisBase subclasses"
date: 2024-08-16
description: "Parallel `AnalysisBase.run()` in MDAnalysis with multiprocessing and dask: the outcome of my GSoC 2023 project"
author: "Egor Marin"
tags:
  - mdanalysis
  - gsoc
  - coding
  - open-source
---

🔗 [MDAnalysis PR #4162](https://github.com/MDAnalysis/mdanalysis/pull/4162)

You can find all about this project by [`gsoc` tag](https://marinegor.dev/tags/gsoc/), but basically, you can now do `ArbitraryAnalysisSubclass.run(backend='multiprocessing')`, and it'll
run automatically in multiple processes.

You can read more about parallelization on [docs](https://docs.mdanalysis.org/dev/documentation_pages/analysis/parallelization.html), especially some limitations of the current approach.

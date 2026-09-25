---
title: "Split-and-combine parallelization for MDAnalysis AnalysisBase subclasses"
date: 2024-08-16
description: "MDAnalysis pull request #4162, 2024"
paper: "https://github.com/MDAnalysis/mdanalysis/pull/4162"
venue: "MDAnalysis pull request #4162"
---

📄 [MDAnalysis pull request #4162 (2024)](https://github.com/MDAnalysis/mdanalysis/pull/4162)

You can find all about this project by [`gsoc` tag](https://marinegor.dev/tags/gsoc/), but basically, you can now do `ArbitraryAnalysisSubclass.run(backend='multiprocessing')`, and it'll
run automatically in multiple processes.

You can read more about parallelization on [docs](https://docs.mdanalysis.org/dev/documentation_pages/analysis/parallelization.html), especially some limitations of the current approach.

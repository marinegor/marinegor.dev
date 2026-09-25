---
title: "Secondary structure analysis with DSSP for MDAnalysis"
date: 2024-06-18
description: "Built-in, dependency-free secondary structure analysis (DSSP) for MDAnalysis, started at the 2023 UGM hackathon"
author: "Egor Marin"
tags:
  - mdanalysis
  - coding
  - open-source
---

🔗 [MDAnalysis PR #4304](https://github.com/MDAnalysis/mdanalysis/pull/4304)

A fun project emerged during MDAnalysis 2023 UGM hackathon. Basically, it adds a built-in secondary structure analysis, with no dependencies. The algorithm is based on [Kabsch et al](https://onlinelibrary.wiley.com/doi/10.1002/bip.360221211), and implementation is borrowed from [pyDSSP](https://github.com/ShintaroMinami/PyDSSP/tree/master/pydssp). I slightly modified the implementation, making it depend only on `numpy` (previously it depended on `einops` package).

For details, see [documentation](https://docs.mdanalysis.org/dev/documentation_pages/analysis/dssp.html).

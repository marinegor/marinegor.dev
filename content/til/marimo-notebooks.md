---
title: "Embedding interactive marimo notebooks"
date: "2026-09-05"
description: "How to drop a live, WASM-powered Python notebook into a post"
tags:
  - til
  - python
  - marimo
---

[marimo](https://marimo.io/) is a reactive Python notebook that can be exported to a self-contained WebAssembly build ([docs](https://docs.marimo.io/guides/wasm/)) -- meaning it runs entirely in the visitor's browser via [Pyodide](https://pyodide.org/), no server or backend required. That makes it a nice fit for a static site like this one.

The workflow is two steps. First, write a notebook as a plain `.py` file (`notebooks/example.py` in this repo), then export it:

```bash
task marimo:export -- notebooks/example.py
```

This runs `marimo export html-wasm --sandbox --mode run --no-show-code` under the hood and writes the result to `static/notebooks/example.html`, alongside a shared `assets/` folder with the marimo/Pyodide runtime (that folder is the same for every notebook, so it's a one-time cost, not a per-notebook one).

Then embed it in any post's markdown with a shortcode:

```
{{</* marimo "example" */>}}
```

Which renders as an iframe, right here:

{{< marimo "example" >}}

Drag the slider -- the plot re-renders live, computed by actual Python running in your browser tab.

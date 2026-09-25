---
title: "marimo: Python notebooks that are just Python"
date: 2026-09-24
description: "What marimo is, why I like it, and a live notebook running right in this page"
tags:
  - python
  - marimo
---

[marimo](https://marimo.io) is a Python notebook, like Jupyter, but built around a few decisions that fix most of what annoys me about notebooks.

## Why it's cool

- **Reactive**: marimo knows which cells use which variables. Change a cell or move a slider, and every cell that depends on it re-runs; delete a cell, and its variables are gone. No hidden state, no "restart and run all" to check that it actually works top to bottom.
- **Just a `.py` file**: a notebook is a plain Python script. It diffs nicely in git, can be linted and formatted like any other code (this repo runs `ruff` and `ty` on it), imported as a module, or run with `python notebook.py`.
- **Dependencies inside the notebook**: packages are declared inline ([PEP 723](https://peps.python.org/pep-0723/)), so `marimo edit --sandbox notebook.py` builds an isolated environment with [uv](https://docs.astral.sh/uv/) and you just run it.
- **Apps for free**: UI elements (sliders, dropdowns, forms, ...) are regular Python values, so any notebook can be shown as an interactive app with `marimo run`.
- **Runs in the browser**: via [WebAssembly and Pyodide](https://docs.marimo.io/guides/wasm/), with no server at all. That's what makes the embed below possible on a static site like this one.

## A live example

Below is the [cellular automaton art](https://github.com/marimo-team/gallery-examples/blob/main/notebooks/math/cellular-automaton-art.py) notebook from the marimo gallery. It's the same one used in the [marimo embedding docs](https://docs.marimo.io/guides/publishing/embedding/). It runs entirely in your browser, so the first load takes a few seconds while Python itself is downloaded. Then click **Make art!**:

{{< marimo "cellular-automaton-art" >}}

The notebook lives in this site's repo as a plain `.py` file, and is also served as-is. The `marimo` shortcode reads it at build time and passes its code to [marimo.app](https://marimo.app) in the iframe URL. To play with it locally:

```bash
uvx marimo edit --sandbox https://marinegor.dev/notebooks/cellular-automaton-art.py
```

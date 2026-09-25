# notebooks

[marimo](https://marimo.io) notebooks, served as-is under `/notebooks/` (see
`module.mounts` in `hugo.toml`). Each one is a self-contained script with
[PEP 723](https://peps.python.org/pep-0723/) dependencies.

```text
task marimo -- notebooks/<name>.py   # edit interactively, with its own deps
task lint                            # ruff, ty, marimo check (among others)
```

- `cellular-automaton-art.py`: from
  [marimo-team/gallery-examples](https://github.com/marimo-team/gallery-examples/blob/58077b7064954325ad4904ab80641a662e5a0220/notebooks/math/cellular-automaton-art.py)
  (MIT), reformatted with ruff.

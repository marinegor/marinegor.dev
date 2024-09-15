---
title: "Taskfile + uv for running python tests"
date: "2023-09-15"
description: "A quick note on how to write a Taskfile to make running tests easies"
tags:
  - til
  - uv
  - pytest
---

# Glossary

## What is a Taskfile

Like Makefile, but tasks are written in bash: [link](https://taskfile.dev/). Basically, it allows you to define custom, arbitrarily complex tasks, and then run then with `task <taskname>`.

## What is `uv`

A super fast python package manager ~~that everyone's been talking about~~. Just go [check it out](https://github.com/astral-sh/uv).

For me the primary usage for `uv` is replacing `pip install ...` with `uv pip install ...` -- just makes things run faster (and with more clear error messages). However, here I'll talk about a new feature called `uv run` -- it allows you to run an arbitrary command without leaving current environment.

# Taskfile example: MDAnalysis

Basically, the Taskfile:

```yaml
version: '3'

tasks:
  clean:
    cmds:
      - rm -rf .venv
  ipython:
    cmds:
      - ipython
  build:
    cmds:
      - echo 'running build...'
      - uv venv -p 3.12
  rebuild:
    cmds:
      - task: clean
      - task: build
  install:
    cmds:
      - task: build
      - uv pip install -e './package[extra_formats,analysis,doc,parallel]' 
      - uv pip install -e './testsuite' pytest-xdist pytest-testmon pytest-random-order
      - uv pip install ipython ipykernel
  test:
    cmds:
      - task: build
      - task: install
      - uv run python -m pytest --random-order -n $(nproc --ignore=4) {{.CLI_ARGS}}
  check:
    cmds:
      - uv run python -m pytest --random-order --testmon -n $(nproc --ignore=4) {{.CLI_ARGS}}
  all:
    cmds:
      - task: clean
      - task: build
      - task: install
      - task: test
```

It allows you to build the full environment quickly (~2 minutes with cold cache), install the things I always install for tests but keep forgetting when re-installing the package (`pytest-xdist` and `pytest-random-order`), and run either all tests (`task test`) or only those that could've changed correctness since the last time I ran pytest (`task check`). The last one is useful when developing code.

Also, I can run `ipython` console, making sure that I'm running inside current environment, with `task ipython`. Pretty neat!


Don't forget to add this Taskfile to your `.git/info/exclude` file in order not to commit it by accident.
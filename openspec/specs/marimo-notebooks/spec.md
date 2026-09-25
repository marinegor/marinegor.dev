# marimo-notebooks Specification

## Purpose

Lets posts embed live, browser-run marimo notebooks whose source is kept and served from the repository.

## Requirements

### Requirement: Notebooks in the repository
Notebooks SHALL be self-contained scripts with inline dependencies in `notebooks/`, served as-is under `/notebooks/`.

#### Scenario: Served source
- **WHEN** the site is built
- **THEN** every notebook is available unchanged at `/notebooks/<name>.py`

### Requirement: Live embed
A post SHALL be able to embed a notebook by name; the embed SHALL run the notebook in the visitor's browser and link to its source and a way to run it locally.

#### Scenario: Stale embed
- **WHEN** a notebook changed but its embed data was not regenerated
- **THEN** the build and `task lint` fail until `task marimo:embed` is run

### Requirement: Local editing
`task marimo -- <notebook>` SHALL open the notebook in the marimo editor with its own declared dependencies.

#### Scenario: Editing a notebook
- **WHEN** the maintainer runs `task marimo -- notebooks/foo.py`
- **THEN** marimo opens it in an isolated environment with its dependencies installed

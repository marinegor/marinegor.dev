# content-quality Specification

## Purpose

Keeps markdown content, code blocks and python sources consistently formatted and free of spelling mistakes.

## Requirements

### Requirement: Markdown lint and spelling
Markdown content SHALL pass the markdown linter and the spell checker, with project-specific exceptions recorded in their config files.

#### Scenario: Lint content
- **WHEN** `task lint` runs
- **THEN** rumdl and typos report no issues, and `task fix` repairs what is fixable without changing prose

### Requirement: Formatted code blocks
Python code blocks in markdown SHALL be ruff-formatted where ruff can parse them, and code blocks SHALL contain no hard tabs (4 spaces instead).

#### Scenario: Unformatted or tabbed block
- **WHEN** a python code block is not ruff-formatted or any code block contains a tab
- **THEN** `task lint` fails, and one `task fix` pass fixes it

### Requirement: Python sources checked
Python files (notebooks, scripts) SHALL pass ruff lint and format checks and ty type checks, with each notebook type-checked in its own declared environment.

#### Scenario: Type error in a notebook
- **WHEN** a notebook contains a type error or unresolved import
- **THEN** `task lint` fails

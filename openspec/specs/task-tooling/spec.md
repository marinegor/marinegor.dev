# task-tooling Specification

## Purpose

Defines how routine and CI work is run in the repository: through Taskfile entries with pinned tools, so it behaves the same locally and on CI.

## Requirements

### Requirement: Taskfile first
Anything run routinely or on CI (build, lint, format, test, code generation, exports) SHALL be a `Taskfile.yml` entry with a `desc`, and CI configurations SHALL invoke it only as `task <name>`.

#### Scenario: New routine command
- **WHEN** a new routine command is introduced
- **THEN** it is added as a task first, works via `task <name>`, and CI calls only that task

#### Scenario: CI workflow
- **WHEN** the GitHub Actions workflow runs
- **THEN** it only provides base toolchains (task, uv) and runs `task` entries, without inline multi-step logic

### Requirement: Tool preconditions
Every task SHALL declare preconditions that check the tools it calls are in PATH, with a message saying how to install them.

#### Scenario: Missing tool
- **WHEN** a task is run and one of its tools is not installed
- **THEN** the task stops before running and prints how to install the tool

### Requirement: Pinned tools
Tools SHALL be pinned: binaries (hugo, lychee) are installed into `./.bin` at fixed versions and put first on PATH, and python tools run through `uvx <tool>@<version>`.

#### Scenario: Same versions everywhere
- **WHEN** `task setup` and `task lint` run on a fresh machine or CI
- **THEN** they use the same tool versions as locally

### Requirement: Lint and test gates
`task lint` SHALL check content and code quality and `task test` SHALL build the site and verify its behaviour; both SHALL pass for every commit.

#### Scenario: Regression check
- **WHEN** a behaviour that can regress is added
- **THEN** a check is added to `task lint` or `task test`, and it is shown to fail without the behaviour

# commit-messages Specification

## Purpose

Keeps the history readable and machine-checkable: commitizen-style headers with Conventional Comments labels in the body.

## Requirements

### Requirement: Commitizen header
Every commit header SHALL follow Conventional Commits: `type(optional scope): summary`, with type one of feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert, a lowercase imperative summary without a trailing period, and at most 72 characters. Breaking changes SHALL use `!` and/or a `BREAKING CHANGE:` footer.

#### Scenario: Commit check
- **WHEN** `task lint:commits` checks the commits not yet on main
- **THEN** every header validates with commitizen

### Requirement: Conventional Comments body
Commit bodies SHALL use Conventional Comments labels (`note:`, `issue:`, `todo:`, `suggestion:`, `question:`, `thought:`, `chore:`, `praise:`, `nitpick:`), optionally with decorations such as `(blocking)` or `(non-blocking)`.

#### Scenario: Explaining a change
- **WHEN** a commit needs more context than its header
- **THEN** each point in the body starts with a Conventional Comments label

### Requirement: One purpose per commit
Each commit SHALL contain one logical change and pass `task lint` and `task test` on its own.

#### Scenario: Several changes at once
- **WHEN** work covers several unrelated changes
- **THEN** they are committed separately

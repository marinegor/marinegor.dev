# agent-sandbox Specification

## Purpose

Limits what automated agents may do on the maintainer's machine while working on this repository.

## Requirements

### Requirement: Stay inside the repository
Agents SHALL read and write only inside the repository directory; scratch files SHALL go into the gitignored `.task/` directory.

#### Scenario: Temporary files
- **WHEN** an agent needs a scratch file or directory
- **THEN** it creates it under `.task/`, not in `/tmp` or the home directory

### Requirement: No applications or background processes
Agents SHALL NOT launch browsers, GUI applications, containers or virtual machines, and SHALL NOT start long-running processes such as dev servers; visual checks SHALL be left to the user.

#### Scenario: Verifying a visual change
- **WHEN** a change affects how pages look
- **THEN** the agent verifies it through `task build` / `task test` and generated files, and asks the user to check it in a browser

### Requirement: Limited network and pushes
Network use SHALL be limited to what the Taskfile does and reading documentation, and `git push` SHALL only happen when explicitly asked.

#### Scenario: Finished work
- **WHEN** an agent finishes committing work
- **THEN** it does not push unless the user asked for it

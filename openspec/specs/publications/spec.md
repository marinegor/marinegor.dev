# publications Specification

## Purpose

Presents scientific publications as individual entries with personal comments, both as a year-grouped list and in the site feed.

## Requirements

### Requirement: One page per publication
Each publication SHALL be its own page, dated with its exact publication date, showing a link to the paper with its venue and year, followed by the comment.

#### Scenario: New paper
- **WHEN** a publication is added
- **THEN** it appears in the home Feed and RSS with the `paper` label, sorted by its publication date

### Requirement: Year-grouped list
`/publications/` SHALL list all publications grouped by year, newest first, each with its paper link and comment; the old `/pages/publications/` address SHALL redirect there.

#### Scenario: Old link
- **WHEN** a visitor opens `/pages/publications/`
- **THEN** they are redirected to `/publications/`

### Requirement: Software contributions are posts
Software contributions (e.g. MDAnalysis pull requests) SHALL be posts, not publications.

#### Scenario: Pull request write-up
- **WHEN** a write-up about a merged pull request is added
- **THEN** it goes into posts with the `post` label

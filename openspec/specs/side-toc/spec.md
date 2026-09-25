# side-toc Specification

## Purpose

Offers an optional table of contents on long pages without taking space by default.

## Requirements

### Requirement: Collapsed toggle on long pages
Pages with at least 3 table-of-contents entries SHALL have a "contents" toggle on the right that starts collapsed; list pages SHALL NOT have it, and front matter `sidetoc: false` SHALL disable it for a page.

#### Scenario: Long post
- **WHEN** a long post is opened for the first time
- **THEN** the toggle is shown collapsed

### Requirement: Remembered choice
The reader's open/closed choice SHALL be remembered across pages; without JavaScript the toggle SHALL still open and close.

#### Scenario: Opened once
- **WHEN** the reader opens the table of contents and navigates to another long post
- **THEN** it is open there too

### Requirement: Not in feeds or print
The table of contents SHALL NOT appear in RSS items or printed pages.

#### Scenario: Printing
- **WHEN** a page is printed
- **THEN** the toggle is hidden

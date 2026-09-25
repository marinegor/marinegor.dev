# home-feed Specification

## Purpose

The home page shows one "Feed" of everything published on the site, newest first, so visitors see posts, TILs and papers in one place.

## Requirements

### Requirement: Combined feed
The home page SHALL list, under the heading "Feed", all pages from the configured feed sections (posts, til, publications), newest first.

#### Scenario: New TIL
- **WHEN** a TIL is published
- **THEN** it appears in the home page Feed alongside posts and publications

### Requirement: Section labels
Each home Feed entry SHALL show a small label for its section (`post`, `til`, `paper`) linking to that section's list; section list pages SHALL NOT show these labels.

#### Scenario: Home entry
- **WHEN** the home page is rendered
- **THEN** every entry has a section label, and `/posts/` and `/til/` entries have none

### Requirement: Same entries as RSS
The home Feed and the main RSS feed SHALL contain exactly the same entries.

#### Scenario: Consistency check
- **WHEN** `task test:feed` compares the home page with `/index.xml`
- **THEN** both list the same entries

### Requirement: Header navigation
The header menu SHALL link to the posts, til, publications and CV pages, followed by the search box and theme switch.

#### Scenario: Header
- **WHEN** any page is rendered
- **THEN** the menu contains /posts, /til, /publications and /cv and no /tags or /pages links

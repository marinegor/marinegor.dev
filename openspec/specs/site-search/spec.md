# site-search Specification

## Purpose

Lets visitors find any page on the site from the header, without a server or third-party search service.

## Requirements

### Requirement: Search everything
The header search box SHALL search all regular pages by title, tags, description and text, requiring all query words to match and ranking title matches first, showing at most 8 results with a snippet and section label.

#### Scenario: Multi-word query
- **WHEN** a visitor types "sodium pump"
- **THEN** only pages containing both words are listed

#### Scenario: Index coverage
- **WHEN** `task test:search` runs
- **THEN** every feed entry is in the search index and every index entry has a page

### Requirement: Keyboard use
`/` SHALL focus the search box, arrow keys SHALL move through results, Enter SHALL open the selected result and Escape SHALL close the results.

#### Scenario: Keyboard only
- **WHEN** a visitor presses `/`, types a query and presses Enter
- **THEN** the top result opens

### Requirement: Works without JavaScript
Without JavaScript the search box SHALL submit to a web search restricted to this site.

#### Scenario: JavaScript disabled
- **WHEN** a visitor searches with JavaScript disabled
- **THEN** they get DuckDuckGo results for marinegor.dev

# rss-feed Specification

## Purpose

Lets readers follow the site in a feed reader with the full text of every post, TIL and paper.

## Requirements

### Requirement: Main feed contents
`/index.xml` SHALL contain only pages from the feed sections (posts, til, publications), with the site title and description as channel metadata and tags as categories.

#### Scenario: Page update
- **WHEN** a page outside the feed sections (e.g. the CV) is updated
- **THEN** it does not appear in the main feed

### Requirement: Full text readable in feed readers
Each item SHALL carry the full page content, with only absolute URLs, without site UI elements (heading anchors, copy buttons), and without iframes.

#### Scenario: Post with an embed
- **WHEN** a post embeds a marimo notebook
- **THEN** its feed item shows a link to the post instead of the iframe

#### Scenario: Feed check
- **WHEN** `task test:feed` checks `/index.xml`
- **THEN** it finds no items outside the feed sections, no iframes and no relative URLs

### Requirement: Discoverable feeds
Every page SHALL advertise the feed with an alternate link, the social icons SHALL include an RSS link, and every section and tag SHALL have its own feed.

#### Scenario: Subscribing
- **WHEN** a feed reader is given the site URL
- **THEN** it finds `/index.xml`

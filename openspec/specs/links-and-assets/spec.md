# links-and-assets Specification

## Purpose

Keeps links, images and promised URLs working, and gives links a consistent accent style.

## Requirements

### Requirement: No broken internal links
All internal links and fragments in the built site SHALL resolve, including absolute links to the site's own domain.

#### Scenario: Link check
- **WHEN** `task test:links` checks the build offline
- **THEN** it reports no errors

### Requirement: Images are rendered
Every image referenced in content SHALL be rendered on its page.

#### Scenario: Image outside a page bundle
- **WHEN** content references an image by a plain path
- **THEN** `task test:images` finds it rendered as an image

### Requirement: Stable URLs
`/cv.pdf`, `/cv/`, `/pages/cv/`, `/index.xml`, `/publications/` and `/pages/publications/` SHALL exist in every build; `/cv.pdf` SHALL be rendered from the typst source with `task cv`.

#### Scenario: Files check
- **WHEN** `task test:files` runs
- **THEN** all promised URLs exist

### Requirement: Accent colour
Links SHALL have an orange accent underline and turn orange on hover, with a readable contrast in both light and dark mode.

#### Scenario: Hovering a link
- **WHEN** a visitor hovers a link in either mode
- **THEN** it turns the accent orange

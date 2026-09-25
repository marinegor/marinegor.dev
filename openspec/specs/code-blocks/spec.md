# code-blocks Specification

## Purpose

Makes code on the site readable: syntax-coloured, compact, and consistent in light and dark mode.

## Requirements

### Requirement: GitHub colours only
Code blocks SHALL be coloured with the GitHub style in light mode and GitHub Dark in dark mode, using colours only (no bold, italic or underline), and SHALL NOT mark unparseable characters as errors.

#### Scenario: Dark mode
- **WHEN** a page is shown in dark mode (OS preference or theme switch)
- **THEN** code uses the GitHub Dark colours

### Requirement: Compact blocks
Code blocks SHALL use a smaller font than body text and render tabs as 4 spaces; inline code SHALL keep the body size.

#### Scenario: Code block on a post
- **WHEN** a post with a code block is rendered
- **THEN** the block uses the smaller code font with a copy button

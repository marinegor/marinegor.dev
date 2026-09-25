# theme-switch Specification

## Purpose

Lets visitors override the OS colour scheme with a manual light or dark choice that persists across pages.

## Requirements

### Requirement: Auto by default
Without a saved choice, the site SHALL follow the visitor's OS colour-scheme preference.

#### Scenario: First visit
- **WHEN** a visitor opens the site for the first time
- **THEN** no theme is forced and the OS preference applies

### Requirement: Manual switch
The header SHALL have a switch with an icon and label for the current mode that cycles auto, light and dark, and remembers the choice in the browser; choosing auto SHALL clear it.

#### Scenario: Choose dark
- **WHEN** the visitor switches to dark and opens another page
- **THEN** that page is dark and the switch shows the dark icon

### Requirement: No flash on load
A saved choice SHALL be applied before the page is first painted.

#### Scenario: Load order check
- **WHEN** `task test:theme` inspects built pages
- **THEN** the saved theme is applied before any stylesheet and before page content

### Requirement: Degrades without JavaScript
Without JavaScript the switch SHALL be hidden and the OS preference SHALL apply.

#### Scenario: JavaScript disabled
- **WHEN** JavaScript is disabled
- **THEN** no non-working switch is shown

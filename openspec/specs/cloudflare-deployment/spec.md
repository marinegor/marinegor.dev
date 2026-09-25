# cloudflare-deployment Specification

## Purpose

Keeps the production site deployable: Cloudflare Pages builds `main` on its own, so every commit on `main` must build there without any extra step.

## Requirements

### Requirement: Plain hugo build
The site SHALL build completely with a plain `hugo` invocation, with no pre- or post-build steps, generated files that must be produced at deploy time, or deploy tasks in the repository.

#### Scenario: Cloudflare-equivalent build
- **WHEN** `task test:cloudflare` builds the site with plain `hugo` at CF_HUGO_VERSION
- **THEN** the build succeeds and produces `index.html` and `cv.pdf`

#### Scenario: Generated files are committed
- **WHEN** a build input is generated (syntax colours, marimo embed data)
- **THEN** the generated file is committed and `task lint` fails if it is stale

### Requirement: Hugo version mirrors the dashboard
The Hugo version used by the repository (HUGO_VERSION) SHALL equal the one configured in the Cloudflare Pages dashboard (mirrored as CF_HUGO_VERSION), and changes to either, or to the theme submodule, SHALL be made together with the user updating the dashboard.

#### Scenario: Version bump
- **WHEN** HUGO_VERSION or the theme submodule is changed
- **THEN** CF_HUGO_VERSION is changed to the same version and the user is asked to set HUGO_VERSION in the Pages dashboard (preview and production) before merging

### Requirement: CI does not deploy
CI SHALL only lint and test; deployment SHALL happen solely through Cloudflare Pages building `main`.

#### Scenario: Push to main
- **WHEN** a commit is pushed to `main`
- **THEN** CI runs `task ci` and nothing in the repository deploys the site

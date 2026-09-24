# Agent / contributor conventions for marinegor.dev

Hugo site (theme: `themes/archie`, git submodule), deployed via Cloudflare Pages.

## 1. Commit messages

Commits follow [commitizen / Conventional Commits](https://www.conventionalcommits.org/)
for the header, and [Conventional Comments](https://conventionalcomments.org/)
labels for the body.

```
<type>(<optional scope>): <short imperative summary, lowercase, no period>

<label> [decorations]: <subject>

<optional discussion / details>
```

- `type` ∈ `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
  `build`, `ci`, `chore`, `revert`. Breaking changes: `feat!:` and/or a
  `BREAKING CHANGE:` footer.
- Header ≤ 72 chars. Scope is optional, e.g. `feat(theme):`, `fix(cv):`.
- Body lines use Conventional Comments labels: `note:`, `suggestion:`,
  `issue:`, `todo:`, `question:`, `thought:`, `chore:`, `praise:`, `nitpick:`,
  with optional decorations such as `(non-blocking)`, `(blocking)`, `(if-minor)`.

Example:

```
feat(marimo): add shortcode for embedding wasm notebooks

note: notebooks are exported to static/notebooks/<slug>.html via `task marimo:export`
todo (non-blocking): lazy-load the pyodide runtime only on pages that use it
```

Validate with `cz check --message "<msg>"` if commitizen is installed.

## 2. Taskfile first, CI via `task` only

Anything that runs on CI or is meant to be run routinely in the repo (build,
serve, deploy, tests, linting, formatting, exports, ...) must:

1. first be added as an entry in `Taskfile.yml` (with a `desc:`), and work
   locally via `task <name>`;
2. be invoked from CI (GitHub Actions, Cloudflare Pages build command, etc.)
   **only** as `task <name>` — no inline multi-step shell logic in CI configs.

If a CI step needs a tool, install it inside a Task (e.g. a `task install`
dependency), and have CI install only `task` itself (e.g.
`arduino/setup-task`).

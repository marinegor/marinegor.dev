# Agent / contributor conventions for marinegor.dev

Hugo site (theme: git submodule under `themes/`), deployed by Cloudflare Pages.

## Sandbox rules (hard constraints)

- Work **only inside this repository directory**. Do not read/write/clone
  into `/tmp`, `$HOME` or anywhere else; scratch files go into `.task/`
  (gitignored) inside the repo.
- Do **not** launch applications on the machine: no browsers (Chrome,
  headless or not), no GUI apps, no Docker/containers, no VMs.
- Do **not** start long-running/background processes (dev servers,
  `python -m http.server`, `task serve`, ...). Verify via `task build` /
  `task test` output and generated files instead; leave visual checks to the user.
- Network use is limited to what the Taskfile does (downloading pinned tools,
  `uvx`) and reading docs; `git push` only when explicitly asked.

## 0. Deployment: don't break Cloudflare

- Cloudflare Pages builds `main` by itself with a plain `hugo`. There is no
  deploy step in CI, and there's no `deploy` task on purpose.
- Cloudflare's Hugo version is set in its dashboard, not in the repo. It's
  mirrored in `Taskfile.yml` as `CF_HUGO_VERSION`. Any theme/config/content
  change must pass `task test:cloudflare` (part of `task test`).
- Hugo versions are not forward/backward compatible for themes. Never bump
  `HUGO_VERSION`/`CF_HUGO_VERSION` or theme submodules without the user also
  updating `HUGO_VERSION` in the Cloudflare dashboard.

## 1. Commit messages

Commits follow [commitizen / Conventional Commits](https://www.conventionalcommits.org/)
for the header, and [Conventional Comments](https://conventionalcomments.org/)
labels for the body.

```text
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

```text
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

If a CI step needs a tool, install it inside a Task (e.g. `task setup`).
CI may only provide base toolchains (`arduino/setup-task`, `astral-sh/setup-uv`).

Every task must declare `preconditions` checking that the tools it calls
exist in `PATH` (`command -v <tool>`), with a `msg` saying how to install them.
Pinned tools go into `./.bin`, which tasks put first on `PATH` (this relies
on the `ENV_PRECEDENCE` experiment enabled in `.taskrc.yml`).

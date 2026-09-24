# marinegor.dev

Personal website, built with [Hugo](https://gohugo.io/).

## Development

Everything is wrapped in a [Taskfile](https://taskfile.dev/) (needs task ≥ 3.39).
Run `task --list` to see all tasks.

```text
task setup    # init theme submodule, install pinned hugo + lychee into ./.bin
task serve    # dev server on http://localhost:1313 (drafts visible)
task lint     # rumdl, typos, ruff, ty, marimo check, generated-file freshness
task fix      # auto-fix what `lint` complains about (incl. ruff format)
task test     # build + validate feeds, internal links, cv.pdf, Cloudflare build
task ci       # setup + lint + test, what GitHub Actions runs
task cv       # render static/cv.pdf from basic-resume/main.typ (typst)
task chroma   # regenerate code-highlighting colours (assets/css/chroma.css)
```

## marimo notebooks

Notebooks live in `notebooks/` (PEP 723 scripts) and are served as-is under
`/notebooks/`. To embed one in a post:

```text
task marimo -- notebooks/foo.py   # edit interactively, with its own dependencies
task marimo:embed                 # after editing: refresh data/marimo/*.json
```

and in markdown: `{{</* marimo "foo" */>}}`. The build fails if
`data/marimo/foo.json` is stale.

Hugo and lychee are installed into `./.bin` at pinned versions, and tasks put
`./.bin` first on `PATH` (see `.taskrc.yml`). `uvx` ([uv](https://docs.astral.sh/uv/))
is needed for the linters.

## Deployment

Cloudflare Pages (project `marinegor-nl`) builds and deploys `main` on
every push by running `hugo`. Nothing in this repo deploys.

Cloudflare uses Hugo **0.118.2**. That's the build image default, unless
`HUGO_VERSION` is set in the Pages dashboard. `task test:cloudflare` builds the site with that exact
version. To upgrade Hugo, set `HUGO_VERSION` in the dashboard and bump
`HUGO_VERSION` + `CF_HUGO_VERSION` in `Taskfile.yml` together.

## CV

`static/cv.pdf` (served at `/cv.pdf`) is rendered from `basic-resume/main.typ`
with `task cv`. Alternatively, from the web version:

```text
weasyprint -p https://marinegor.dev/pages/cv cv.pdf && open cv.pdf
```


# Render a CV

If you really want to, just do:

```
weasyprint -p https://marinegor.dev/pages/cv cv.pdf && open cv.pdf
```

# Local development

Common commands are wrapped in a [Taskfile](https://taskfile.dev/) — run `task --list` to see them all. The main ones:

```
task serve   # local dev server at localhost:1313, with drafts visible
task build   # production build (mirrors the Cloudflare Pages build)
task check   # build + validate the RSS feed
```

`task install` (a dependency of the above) installs Hugo via `go install` on first run if it isn't already on your `PATH`.

# Embedding marimo notebooks

[marimo](https://docs.marimo.io/guides/wasm/) notebooks can be embedded as interactive WASM-powered iframes in any post. Export a notebook locally and commit the generated HTML:

```
task marimo:export -- path/to/notebook.py [slug]
```

This writes `static/notebooks/<slug>.html`. Then embed it in a post's markdown:

```
{{< marimo "slug" >}}
```


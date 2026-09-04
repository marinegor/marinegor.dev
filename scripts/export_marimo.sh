#!/usr/bin/env bash
# Usage: scripts/export_marimo.sh path/to/notebook.py [slug]
# Exports a marimo notebook to a self-contained WASM HTML file under
# static/notebooks/<slug>.html, ready to embed with {{< marimo "<slug>" >}}.
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 path/to/notebook.py [slug]" >&2
  exit 1
fi

NOTEBOOK="$1"
SLUG="${2:-$(basename "$NOTEBOOK" .py)}"
OUT_DIR="static/notebooks"

mkdir -p "$OUT_DIR"
uvx marimo export html-wasm --sandbox --mode run --no-show-code "$NOTEBOOK" -o "$OUT_DIR/$SLUG.html"

echo "Exported -> $OUT_DIR/$SLUG.html   (embed with {{< marimo \"$SLUG\" >}})"

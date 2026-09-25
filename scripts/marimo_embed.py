# /// script
# requires-python = ">=3.10"
# dependencies = ["lzstring==1.0.4"]
# ///
"""Precompute marimo playground embed data for notebooks.

Hugo can't lz-compress, so for each notebook this writes
data/marimo/<name>.json with the lz-string compressed source (what
https://marimo.app/#code/<...> expects) and the sha256 of the source. The
`marimo` shortcode refuses to build if the sha256 doesn't match the notebook.

Usage: uv run --script scripts/marimo_embed.py <out_dir> <notebook.py>...
"""

import hashlib
import json
import sys
from pathlib import Path

import lzstring


def main(out_dir: str, notebooks: list[str]) -> None:
    lz = lzstring.LZString()
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    for nb in map(Path, notebooks):
        source = nb.read_text(encoding="utf-8")
        compressed = lz.compressToEncodedURIComponent(source)
        if lz.decompressFromEncodedURIComponent(compressed) != source:
            sys.exit(f"{nb}: lz-string round trip failed")
        data = {
            "source": nb.as_posix(),
            "sha256": hashlib.sha256(source.encode("utf-8")).hexdigest(),
            "lz": compressed,
        }
        target = out / f"{nb.stem}.json"
        target.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
        print(f"{nb} -> {target} ({len(compressed)} chars)")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2:])

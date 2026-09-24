"""Check that every image referenced in content/**/*.md ends up as an <img>.

Catches render hooks silently dropping images (typo's render-image did).
Usage: python3 scripts/check_images.py <content_dir> <public_dir>
"""

import re
import sys
from pathlib import Path

MD_IMAGE = re.compile(r"!\[[^\]]*\]\(\s*<?([^)\s>]+)")
HTML_COMMENT = re.compile(r"<!--.*?-->", re.DOTALL)
IMG_SRC = re.compile(r"<img\b[^>]*\bsrc=\"?([^\"\s>]+)")


def main(content: Path, public: Path) -> int:
    served: set[str] = set()
    for html in public.rglob("*.html"):
        served.update(IMG_SRC.findall(html.read_text(encoding="utf-8")))

    missing = []
    for md in sorted(content.rglob("*.md")):
        text = HTML_COMMENT.sub("", md.read_text(encoding="utf-8"))
        for src in MD_IMAGE.findall(text):
            if src.startswith(("http://", "https://")):
                continue
            name = src.rsplit("/", 1)[-1]
            if not any(s.rsplit("/", 1)[-1] == name for s in served):
                missing.append(f"{md}: {src}")

    for m in missing:
        print(f"image not rendered: {m}")
    print(f"{len(missing)} missing images")
    return 1 if missing else 0


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    sys.exit(main(Path(sys.argv[1]), Path(sys.argv[2])))

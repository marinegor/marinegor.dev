"""Sanity-check the site's main RSS feed.

- only items from the allowed sections (no /pages/ etc.)
- items carry full content, with only absolute URLs
- no iframes (embeds must use their *.rss.xml shortcode variants)

Usage: python3 scripts/check_feed.py <feed.xml> <site_url> <section>...
"""

import re
import sys
import xml.etree.ElementTree as ET

URL_ATTR = re.compile(r"(?:src|href)=\"([^\"]+)\"")


def main(feed: str, site_url: str, sections: list[str]) -> int:
    channel = ET.parse(feed).getroot().find("channel")
    assert channel is not None, "no <channel>"
    items = channel.findall("item")
    errors = []
    if not items:
        errors.append("feed has no items")
    prefixes = tuple(f"{site_url}/{s}/" for s in sections)
    for item in items:
        link = item.findtext("link") or ""
        body = item.findtext("description") or ""
        if not link.startswith(prefixes):
            errors.append(f"{link}: not in sections {sections}")
        if "<iframe" in body:
            errors.append(f"{link}: contains an <iframe>")
        for url in URL_ATTR.findall(body):
            if not re.match(r"(https?:|mailto:)", url):
                errors.append(f"{link}: non-absolute url {url!r}")
    for e in errors:
        print(e)
    print(f"{feed}: {len(items)} items, {len(errors)} problems")
    return 1 if errors else 0


if __name__ == "__main__":
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], sys.argv[2], sys.argv[3:]))

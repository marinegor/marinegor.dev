"""Check the home page "Feed" lists exactly the entries of the main RSS feed.

Both are driven by params.feedSections (layouts/_default/{home.html,rss.xml});
this catches the two drifting apart. Also checks every home entry has a
section label.

Usage: python3 scripts/check_home_feed.py <index.html> <index.xml> <site_url>
"""

import re
import sys
import xml.etree.ElementTree as ET

ENTRY = re.compile(r"<div class=\"?post-line\"?>(.*?)</div>\s*</div>", re.DOTALL)
TITLE_HREF = re.compile(r"class=\"?line-title\"?>\s*<a href=\"?([^\"\s>]+)")
LABEL = re.compile(r"class=\"?section-label")


def main(home: str, feed: str, site_url: str) -> int:
    html = open(home, encoding="utf-8").read()
    entries = ENTRY.findall(html)
    home_links = []
    errors = []
    for e in entries:
        m = TITLE_HREF.search(e)
        if not m:
            errors.append(f"entry without title link: {e[:80]!r}")
            continue
        link = m.group(1)
        home_links.append(link if link.startswith("http") else site_url + link)
        if not LABEL.search(e):
            errors.append(f"{link}: no section label")

    feed_links = [i.findtext("link") for i in ET.parse(feed).getroot().iter("item")]
    for link in sorted(set(feed_links) - set(home_links)):
        errors.append(f"in RSS feed but not on the home page: {link}")
    for link in sorted(set(home_links) - set(feed_links)):
        errors.append(f"on the home page but not in the RSS feed: {link}")

    for e in errors:
        print(e)
    print(
        f"home feed: {len(home_links)} entries, RSS: {len(feed_links)}, {len(errors)} problems"
    )
    return 1 if errors else 0


if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], sys.argv[2], sys.argv[3]))

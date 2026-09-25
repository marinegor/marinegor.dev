"""Check the theme switch markup in built pages.

- "auto" is the default: <body> has no forced light/dark class
- the saved theme is applied before the first stylesheet (no flash): the
  <head> script comes before any <link rel=stylesheet>, and the <body> script
  comes before <main>
- the switch button is present, and hidden until JS enables it

Usage: python3 scripts/check_theme.py <page.html>...
"""

import re
import sys


def check(path: str) -> list[str]:
    html = open(path, encoding="utf-8").read()
    errors = []
    body = re.search(r"<body[^>]*>", html)
    if not body or re.search(r"\b(light|dark)\b", body.group(0)):
        errors.append(f"<body> is not 'auto': {body.group(0) if body else None}")
    head_js = html.find('localStorage.getItem("theme")')
    css = re.search(r"<link[^>]+rel=\"?stylesheet", html)
    if head_js < 0 or not css or head_js > css.start():
        errors.append("saved theme not applied before the first stylesheet")
    body_js = html.find('document.body.classList.add("light")')
    main = html.find("<main")
    if not body or not (body.end() <= body_js < main):
        errors.append("<body> theme script missing or after <main>")
    if not re.search(r"<button[^>]*class=\"?theme-switch\"?[^>]*\bhidden", html):
        errors.append("theme switch button missing (or not hidden until JS)")
    return [f"{path}: {e}" for e in errors]


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    errors = [e for page in sys.argv[1:] for e in check(page)]
    for e in errors:
        print(e)
    print(f"{len(sys.argv) - 1} pages checked, {len(errors)} problems")
    sys.exit(1 if errors else 0)

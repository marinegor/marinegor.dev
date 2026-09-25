// Site search: searches /search.json (layouts/home.searchindex.json) in the
// browser. The header form (layouts/partials/header.html) works without JS
// too: it submits to DuckDuckGo restricted to this site.
//
// The pure functions (tokenize, search, snippet) are exported for tests
// (scripts/test_search.js); the DOM part only runs in a browser.

const WEIGHTS = { t: 10, tags: 5, desc: 3, c: 1 };
const MAX_RESULTS = 8;

function norm(s) {
  return (s || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

function tokenize(query) {
  return norm(query).split(/\s+/).filter(Boolean);
}

// Every token must match somewhere; title > tags > description > content.
function search(index, query, limit = MAX_RESULTS) {
  const tokens = tokenize(query);
  if (!tokens.length) return [];
  const results = [];
  for (const page of index) {
    const fields = {
      t: norm(page.t),
      tags: norm((page.tags || []).join(" ")),
      desc: norm(page.desc),
      c: norm(page.c),
    };
    let score = 0;
    let all = true;
    for (const tok of tokens) {
      let hit = 0;
      for (const [f, w] of Object.entries(WEIGHTS)) {
        if (fields[f].includes(tok)) hit += w;
      }
      if (!hit) {
        all = false;
        break;
      }
      score += hit;
    }
    if (all) results.push({ page, score });
  }
  results.sort(
    (a, b) => b.score - a.score || (b.page.d || "").localeCompare(a.page.d || ""),
  );
  return results.slice(0, limit).map((r) => r.page);
}

// A short piece of text around the first match, for the result list.
function snippet(page, query, width = 90) {
  const text = page.c || page.desc || "";
  const hay = norm(text);
  const tokens = tokenize(query);
  let at = -1;
  for (const tok of tokens) {
    const i = hay.indexOf(tok);
    if (i >= 0 && (at < 0 || i < at)) at = i;
  }
  if (at < 0) return page.desc || text.slice(0, width);
  const start = Math.max(0, at - Math.floor(width / 3));
  const end = Math.min(text.length, start + width);
  return (start > 0 ? "…" : "") + text.slice(start, end).trim() + (end < text.length ? "…" : "");
}

if (typeof module !== "undefined") {
  module.exports = { tokenize, search, snippet };
}

if (typeof document !== "undefined") {
  const form = document.querySelector("form.site-search");
  const input = form && form.querySelector("input[type=search]");
  const list = form && form.querySelector(".search-results");
  if (form && input && list) {
    let index = null;
    let loading = null;
    let selected = -1;

    const load = () => {
      if (!loading) {
        loading = fetch(form.dataset.index)
          .then((r) => (r.ok ? r.json() : []))
          .then((data) => (index = data))
          .catch(() => (index = []));
      }
      return loading;
    };

    const close = () => {
      list.hidden = true;
      list.replaceChildren();
      selected = -1;
      input.setAttribute("aria-expanded", "false");
    };

    const highlight = (i) => {
      const items = list.querySelectorAll("a");
      items.forEach((a, j) => a.classList.toggle("selected", j === i));
      selected = i;
    };

    const render = () => {
      const q = input.value;
      if (!index || !q.trim()) return close();
      const hits = search(index, q);
      list.replaceChildren();
      if (!hits.length) {
        const li = document.createElement("li");
        li.className = "search-empty";
        li.textContent = "nothing found";
        list.append(li);
      }
      for (const page of hits) {
        const li = document.createElement("li");
        const a = document.createElement("a");
        a.href = page.u;
        const title = document.createElement("span");
        title.className = "search-title";
        title.textContent = page.t;
        const label = document.createElement("span");
        label.className = "section-label";
        label.textContent = page.s;
        const snip = document.createElement("span");
        snip.className = "search-snippet";
        snip.textContent = snippet(page, q);
        a.append(title, label, snip);
        li.append(a);
        list.append(li);
      }
      list.hidden = false;
      input.setAttribute("aria-expanded", "true");
      highlight(hits.length ? 0 : -1);
    };

    input.addEventListener("focus", load);
    input.addEventListener("input", () => load().then(render));
    input.addEventListener("keydown", (e) => {
      const items = list.querySelectorAll("a");
      if (e.key === "ArrowDown" && items.length) {
        e.preventDefault();
        highlight((selected + 1) % items.length);
      } else if (e.key === "ArrowUp" && items.length) {
        e.preventDefault();
        highlight((selected - 1 + items.length) % items.length);
      } else if (e.key === "Escape") {
        input.value = "";
        close();
        input.blur();
      }
    });
    // Enter: open the selected result instead of submitting to DuckDuckGo
    form.addEventListener("submit", (e) => {
      const items = list.querySelectorAll("a");
      if (items.length) {
        e.preventDefault();
        window.location.href = items[Math.max(selected, 0)].href;
      }
    });
    document.addEventListener("click", (e) => {
      if (!form.contains(e.target)) close();
    });
    // "/" focuses the search box, unless already typing somewhere
    document.addEventListener("keydown", (e) => {
      const t = e.target;
      const typing = t && (t.isContentEditable || /^(INPUT|TEXTAREA|SELECT)$/.test(t.tagName));
      if (e.key === "/" && !typing && !e.metaKey && !e.ctrlKey && !e.altKey) {
        e.preventDefault();
        input.focus();
      }
    });
  }
}

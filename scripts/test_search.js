// Tests for assets/js/search.js against a built search index.
// Usage: node scripts/test_search.js <public_dir>
const fs = require("fs");
const path = require("path");
const assert = require("assert");
const { search, snippet, tokenize } = require("../assets/js/search.js");

const pub = process.argv[2];
if (!pub) {
  console.error("usage: node scripts/test_search.js <public_dir>");
  process.exit(2);
}
const index = JSON.parse(fs.readFileSync(path.join(pub, "search.json"), "utf8"));
const feed = fs.readFileSync(path.join(pub, "index.xml"), "utf8");
let failed = 0;
const test = (name, fn) => {
  try {
    fn();
    console.log("ok   " + name);
  } catch (e) {
    failed++;
    console.log("FAIL " + name + "\n     " + e.message);
  }
};

test("index covers every feed entry, and every entry exists", () => {
  const urls = new Set(index.map((p) => p.u));
  for (const [, link] of feed.matchAll(/<link>https?:\/\/[^/]+(\/[^<]*)<\/link>/g)) {
    if (link === "/") continue; // channel link
    assert(urls.has(link), `feed entry ${link} missing from search index`);
  }
  for (const p of index) {
    assert(fs.existsSync(path.join(pub, p.u, "index.html")), `${p.u} has no page`);
    assert(p.t && p.s && p.d, `${p.u}: missing title/section/date`);
  }
});
test("tokenize lowercases, strips accents, splits on whitespace", () => {
  assert.deepStrictEqual(tokenize("  Café  MDAnalysis "), ["cafe", "mdanalysis"]);
});
test("title match ranks first", () => {
  assert.strictEqual(search(index, "marimo")[0].u, "/posts/marimo/");
});
test("all words must match", () => {
  const hits = search(index, "sodium pump");
  assert(hits.length >= 2, "expected both sodium pump papers");
  for (const p of hits) {
    const all = `${p.t} ${p.desc} ${p.c}`.toLowerCase();
    assert(all.includes("sodium") && all.includes("pump"), `${p.u} doesn't match both words`);
  }
});
test("case-insensitive, finds DSSP", () => {
  assert(/dssp/i.test(search(index, "dssp")[0].t));
});
test("no match -> empty", () => {
  assert.deepStrictEqual(search(index, "qwertyzxcv"), []);
  assert.deepStrictEqual(search(index, "   "), []);
});
test("results are capped", () => {
  assert(search(index, "a").length <= 8);
});
test("snippet shows the match", () => {
  const p = search(index, "pyodide")[0];
  assert(p, "expected a hit for pyodide");
  assert(/pyodide/i.test(snippet(p, "pyodide")));
});

console.log(failed ? `${failed} failed` : "all search tests passed");
process.exit(failed ? 1 : 0);

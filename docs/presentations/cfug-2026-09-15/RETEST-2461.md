# Demo re-test on `wheels-be` 4.1.0-snapshot.2461 (2026-09-10, evening)

Fresh `wheels new`, every scripted command in order, Lucee 7.0.0.395, SQLite, Java 21.
Linked-computer shell is a Linux VM without Homebrew, so the snapshot artifacts were installed
from `wheels-snapshots` — the same bits `brew install wheels-be` puts on the Mac.

## Result by beat

| Beat | Status | Notes |
|---|---|---|
| 1 `new` / `start` / welcome | ✅ | Welcome line correct. Debug-bar Complexity panel now interpolates ("21 files · 3 functions"). |
| 2 scaffold `{50}` / dry-run / migrate / seed / reload / routes / CRUD | ✅ | `validatesLengthOf(… allowBlank=true)` now generated; seeded `publishedAt` are real dates; "wrong length" on empty title gone; flashes OK. Routes for the new resource appear **before** `wheels reload` now (16 rows). |
| 3 edit model + empty-form errors | ✅ | Inline errors render. |
| 4 Comment `--belongsTo` / seed / console | ✅ | `findByKey(1).comments()`, `findByKey(3).post().title`, builder chain all correct. |
| 5 auth / register / logout / login / policy / 403 | ✅ | bcrypt `$2a$10$…`, flash on `/login` now shown once, 403 `Wheels.NotAuthorized` + Copy button, logged-in 200. |
| 6 `wheels test` | ⚠️ | First run on a fresh test DB: 23 passed, 4 errors (Comment show/edit/update/delete). Second run: 27 passed. Red/green with the `body` spec: 28 → 27+1 failed → 28. **Root cause found — see below.** |
| 7 tour | ✅ | `info`, `migrate diff`, `stats` (LOC now correct), `api-resource` → migrate → reload → `POST /api/products` 201, `GET` 200. `doctor` down from 9 to 5 warnings (still flags the scaffold's own `new(params.x)` / `update(params.x)`). |
| 8 MCP | ✅ | `generate` now has a real schema (`type`, `name`, `attributes`, `dry-run`). Agent loop verified: `generate scaffold Tag name:string{30} slug:string` → `migrate latest` → `reload` → `seed --generate` → `/tags` 200. `routes`, `info`, `test` work. |

## Two things I broke myself (and what the deck must avoid)
- Any hand-typed validation in Beat 3 must keep the scaffold's own sample data valid. `validatesUniquenessOf("title")` makes Beat 4's `seed --generate` roll back ("Test Title N" repeats); `validatesLengthOf(body, minimum=10)` fails the generated specs (`"MyText"`). Safe choice used in the deck: `validatesExclusionOf(property="title", list="Untitled")`.
- `authorize(post)` left in `Posts.show` fails two Posts specs (403) — remove it before Beat 6.

## Root causes found this round

### A. First `wheels test` fails Comment show/edit/update/delete (still present in 2461)
Not a warm-up issue. The generated `CommentsControllerSpec.beforeEach` creates the comment with a
**hard-coded `post_id: 1`**, and `Comments.show/edit/update/delete` do
`findByKey(key=params.key, include="post")` — an inner join. On a fresh test DB there is no post 1
until `PostsControllerSpec` (alphabetically *after* Comments) creates one, so the join returns
nothing and the view gets `false`. Proven by pre-seeding the test DB with a post 1 → first run green.
Fix in the generator: the child spec should create the parent in `beforeEach`
(`variables.post = model("Post").create(...)` and use `post_id: variables.post.id`), and/or the
scaffold's `findByKey(include=)` should not make the record disappear when the parent is missing.
Demo mitigation stands: one off-screen `wheels test` in Beat 5.

### B. Tests run in a separate application scope that `wheels reload` never reloads
Specs run under `application.applicationName = "blogdemo_wheelsTest"` (85 routes) while the live
app is `blogdemo` (97 routes). Anything scaffolded after the first test run — the `api` namespace,
the `Product` model config — is invisible to the test app, so `ApiProductsControllerSpec` errors
with "Could not find the `apiProducts` route" and `ProductSpec` sees a model without validations.
Persistent across runs and across `wheels reload`. `wheels test` should reload (or restart) the
`_wheelsTest` application when it starts. Demo rule unchanged: never run tests after Beat 7.

## Still open from the first list (verified still present in 2461)
- #5 bare `wheels mcp` prints "missing module name" (say `wheels mcp wheels`).
- #6 `doctor` flags the scaffold's own mass-assignment pattern (5 warnings now).
- #9 `dateTimeSelect` repeats label + error six times.
- #13 console `findOne(include=…)` prints the row twice (flattened + JSON).
- #14 API JSON: `allowExplicitTimestamps:false` leaks; `149.99` → `149.990005493164`; 14 blank lines before the body.
- #15 MCP `test` failure returns only "Tests failed" without the report.
- (new) generated `ApiProductsControllerSpec` fails until B is fixed.

## Fixed since the first run (confirmed)
#1 snapshot broken `migrate` · #7 `stats` LOC · #8 seeder booleans for `publishedAt` · #10 double
title message · #11 doubled flash · #12 complexity panel · #2 MCP `generate` schema · #4 test DB
now migrates every run · #19 routes visible without reload.

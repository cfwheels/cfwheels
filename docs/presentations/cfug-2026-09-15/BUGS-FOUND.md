# Issues found while dry-running the MMCFUG demo (2026-09-10)

Tested on `develop` @ 35894067e (CLI `cli/lucli` + `vendor/wheels`), LuCLI 0.6.2, Lucee 7.0.0.395,
SQLite, Linux x86_64 / Java 21. Ordered by how much they matter for the Sept 15 demo.

## Blocks or visibly breaks the demo

1. **`wheels-be` snapshot 2418 is stale and broken for the demo.** `wheels migrate latest` fails with
   `No matching function [serverUrlBase] found`, `{50}` is ignored, migrations still emit `default=''`.
   The stable tap (`Formula/wheels.rb`) is pinned to **4.0.6**. → Cut a new snapshot / publish 4.1.0 assets
   and bump both formulas before the 15th, then `brew upgrade` on the demo machine and re-verify.
   (v4.1.0 release assets returned 404 from my sandbox — please confirm they exist.)

2. **`generate` is unusable over MCP.** `tools/list` shows `generate` and `create` with an empty
   `inputSchema` (`properties: {}`, `additionalProperties: false`). Any argument an agent sends becomes a
   `--key=value` flag: `{"type":"scaffold","name":"Tag"}` → `Unknown generator type: --type=scaffold`.
   There is no way to pass the positional `<type> <name> attr:type…`. Slide 20's "an agent can scaffold"
   is not true today. `routes`, `migrate`, `info`, `seed`, `reload`, `test` do work over MCP.

3. **First `wheels test` on a fresh test DB fails the first bundle's CRUD specs.** Deterministic:
   `CommentsControllerSpec` (first alphabetically) fails `show/edit/update/delete` with
   `there is no property with name [BODY] found in [boolean]` — the `beforeEach`
   `model("Comment").create(properties=…)` returns `false`. Second run: all green. A throwaway spec that
   does `model("Comment").new().save()` first makes everything pass; one that only touches `Post` does not.
   Not reproducible in dev via the console. Beat 6 in the live demo *is* a first run.

4. **Test DB never receives later migrations.** `app-runner.cfm` includes `tests/populate.cfm` only when
   `wheels_migrator_versions` is absent, so after the first run new migrations (`tags`, `products`) exist in
   dev but not in `db/test.sqlite`; their specs fail with "table could not be found". Suggest
   `migrateToLatest()` on the test DB on every run (no-op when current).

5. **Bare `wheels mcp` prints "missing module name. Usage: wheels mcp <module>" and exits 0.** LuCLI
   intercepts it before `Module.cfc::mcp()` (which prints the `.mcp.json` snippet) can run. Slide/run
   sheet must say `wheels mcp wheels`.

6. **`wheels doctor` flags the CLI's own scaffold output.** Nine "Raw params mass assignment" warnings on
   generated `Posts.cfc` / `Comments.cfc` / `Registrations.cfc`, including `findByKey(params.key)` which
   is not mass assignment. Either the generator should emit the pattern doctor wants, or the check needs
   narrowing. Awkward on stage.

7. **`wheels stats` LOC is wrong.** Controllers: 7 LOC / 388 comments; Models 0 LOC; Tests 0 LOC;
   "Code-to-test ratio: 1:0.00" on a project with 28 passing specs. Cfscript is being counted as comments.

## Visible on screen but not fatal

8. **Seeder + `publishedAt:datetime` → `true`/`false`.** `Seeder.$generateTestDataByType()` checks
   `FindNoCase("published", name)` (boolean branch) before the `datetime` type branch. Index page shows
   `PublishedAt: true`. Fix: type checks before name heuristics.

9. **`dateTimeSelect` in scaffold `_form.cfm` repeats label + error six times** (once per sub-select) on a
   validation failure.

10. **Empty title yields two messages**: "Title can't be empty" *and* "Title is the wrong length" —
    `validatesLengthOf` should probably `allowBlank=true` when the generator also emits presence.

11. **Flash renders twice on `/login`** ("You have been logged out. Log in You have been logged out.") —
    both the layout and `sessions/new.cfm` call `flashMessages()`.

12. **Debug bar "Code Complexity" panel prints literal `#local.codeComplexity.summary.files#`** etc. on a
    fresh app — summary line isn't interpolated.

13. **`findOne(include="comments")` in the console prints the flattened row (`commentbody`, `commentid`…)
    and then a second raw-JSON line** — two renderings of one result.

14. **API JSON**: create response includes internal `allowExplicitTimestamps:false`; `149.99` decimal reads
    back as `149.990005493164` from SQLite; ~12 blank lines precede the JSON body.

15. **MCP `test` tool on failure returns only** `"Tests failed — see the report above"` — the report is
    not in the tool result, so an agent cannot see which specs failed.

16. **`wheels coverage` when the suite fails** prints "suite HTTP 417" and near-zero coverage without
    saying the suite failed.

## Docs / behaviour mismatches worth fixing

17. **`wheels db reset` does not reset.** It runs pending migrations and reseeds; it never drops. The run
    sheet (and probably some docs) say it "nukes SQLite". Clean slate for SQLite is:
    `wheels stop && rm db/development.sqlite db/test.sqlite && wheels start && wheels migrate latest`.
    Deleting `db/*.sqlite` with the server running → `SQLITE_READONLY_DBMOVED` on every query.
    (`tests/populate.cfm`'s comment "Delete db/test.sqlite to force a fresh schema" needs "with the
    server stopped".)

18. **A failed `wheels start` leaves a registration** in `~/.wheels/servers/<name>`; the next start refuses
    with "registered to a different project: <unknown>". `wheels start --force` recovers. Consider
    cleaning up on failed start.

19. **`wheels routes` after a scaffold shows nothing new until `wheels reload`** (routes are cached in the
    running app). The scaffold's "Next steps" should include `wheels reload`. Also no way to hide the 38
    internal `/wheels/*` routes — a `--app-only` flag would help demos and daily use.

20. **Model config is cached too**: adding `hasMany("comments")` to `Post.cfc` needs `wheels reload`
    before `include="comments"` works (expected in dev? worth a line in the guides).

21. **`wheels routes` shows 16 rows for one `.resources()`** (each action twice: with and without
    `.[format]`). Fine, but "seven routes" in talk copy is wrong.

22. **Run-sheet policy example used a non-existent API** (`user.key() == resource.userId`). The generated
    policy uses `variables.user` (struct) and `variables.record`. Working "any signed-in user" rule:
    `return IsStruct(user) && !StructIsEmpty(user);`

23. `wheels new` template root also contains `rewrite.config` and hidden `.env`/`.gitignore` (deck's `ls` omitted `rewrite.config`).

# Mid-Michigan CFUG — Live Demo Run Sheet

**Session:** Wheels: Rails-Style CFML
**Date:** Tuesday, September 15, 2026 · 7:00 PM ET · Zoom → youtube.com/@cfml
**Length:** 90 minutes — 25 slides / 50 demo / 15 Q&A
**Presenter:** Peter Amiri
**Verified against:** `wheels-be` 4.1.0-snapshot.2461, 2026-09-10 evening — every demo command re-executed end to end (see `RETEST-2461.md`; first-round details in `DEMO-TEST-LOG.md` / `BUGS-FOUND.md`)

---

## The contract you make with the room

At minute 8, put this on screen and say it out loud:

> "In the next 50 minutes, with no IDE and no config files, we're going to build a
> blog with posts, comments, user accounts with hashed passwords, authorization
> policies, and a passing test suite. Every command I type is a command you can
> type tonight."

Then deliver exactly that list, in that order. The DHH video worked because he
named the target before he hit it.

---

## Before the stream

**The day before**

- [ ] **Publish 4.1.0 (or a fresh `wheels-be` snapshot) and bump the tap first.** As of Sept 10 `Formula/wheels.rb` pins 4.0.6 and snapshot 2418 has a broken `wheels migrate` (`serverUrlBase`). Then `brew update && brew upgrade wheels` — `wheels version` must show a build that includes the bcrypt auth generator (develop 35894067e or later). Read the number out loud to yourself.
- [ ] Full dry run, timed, start to finish. Note where you ran long.
- [ ] Record the dry run as your backup video (see Fallbacks).
- [ ] Build the checkpoint tags (below).
- [ ] Confirm Java 21 is what `wheels` picks up: `wheels doctor`.
- [ ] **Check `wheels seed --generate` actually saves Posts.** In `Seeder.$generateTestDataByType()` the boolean name-heuristic (`FindNoCase("published", name)`) runs before the `datetime` type check, so `publishedAt` is generated as `true`/`false`. Verified 2026-09-10: rows DO save, but the index page shows `PublishedAt: true`. Fix the ordering in the framework, or rename the demo column to `postedAt:datetime` in Beat 2 and the console queries.

**Checkpoint tags** — build the app once, tag each stage, so any failure is one
`git checkout` from recovery instead of a dead demo:

```bash
cd ~/demo && wheels new blogdemo && cd blogdemo
git init && git add -A && git commit -m "new" && git tag cp0-new
# ...after each demo beat below, commit and tag cp1-scaffold, cp2-comments,
#    cp3-auth, cp4-tests
```

Keep a second terminal tab already `cd`'d into a *finished* copy at `~/demo/blogdemo-final`.

**30 minutes before**

- [ ] Reboot. Seriously — a clean JVM and clean ports.
- [ ] `rm -rf ~/demo/blogdemo` so `wheels new` runs into an empty directory.
- [ ] Terminal font to 18–20pt, high-contrast theme, window at 1280×720 or 1600×900. Anything smaller is unreadable on a YouTube re-watch at 720p.
- [ ] macOS Do Not Disturb on. Quit Slack, Mail, Messages.
- [ ] Browser: new window, one tab, bookmarks bar hidden, zoom at 125%.
- [ ] Close every other app — Zoom shares CPU with a JVM boot.
- [ ] Check port 8080 is free: `lsof -i :8080`.
- [ ] Share the **window**, not the desktop. Have terminal + browser side by side, or practice ⌘-tab between two shared windows.
- [ ] Have `RUN-SHEET.md` open on your *second* monitor, not the shared one.

---

## The demo, beat by beat

Every command below was executed end to end on 2026-09-10 against `wheels-be` snapshot 2461
(LuCLI 0.6.2, Lucee 7.0.0.395, SQLite). Expected output is noted where it matters.
See `RETEST-2461.md` for the results and the two remaining test-runner root causes.

Times are elapsed-into-demo, starting when you leave the slides at ~minute 25.

> **Two rules that came out of the dry run**
> 1. **`wheels reload` after every scaffold and every model edit.** Routes and model config are
>    cached in the running app. Without it: `wheels routes` shows no `/posts`, `/register` 404s,
>    `include="comments"` says the association doesn't exist.
> 2. **The first `wheels test` on a fresh test DB fails the Comment show/edit/update/delete specs**
>    (the generated spec hard-codes `post_id: 1` and the controller's `findByKey(include="post")` inner-joins;
>    no Post 1 exists until the Posts specs run — see `RETEST-2461.md` A). Run `wheels test` once, off-screen,
>    right after the auth migration in Beat 5 so the Beat 6 run is the second one. And never run tests after
>    Beat 7's `api-resource` — specs run in a separate `_wheelsTest` application that `wheels reload` never
>    refreshes, so they can't see the new routes (B).

### Beat 1 — `wheels new` (4 min)

```bash
cd ~/demo
wheels new blogdemo
cd blogdemo
wheels start
```

**Say while it runs:** "No CommandBox, no server.json to hand-edit, no datasource
to define in the admin. SQLite is the default in 4.x, so a new app has a working
database before you've written a line. The CLI ships Lucee inside it — the only
thing it needs from your machine is Java 21."

First JVM boot is ~30–40 s before `/` answers. The welcome page reads
*"Your Wheels 4.1.x application is running on Lucee with blogdemo (development)."*
Point at it: version, engine, datasource, environment.

```bash
ls
# AGENTS.md  CLAUDE.md  app  config  db  lucee.json  public  rewrite.config  tests  vendor
```

**Land the point:** "Your code is in `app/`. The framework is in `vendor/`. They never mix —
that's what makes upgrades boring. And notice CLAUDE.md and AGENTS.md — we'll come back to those."

> ⏱ If `wheels start` is slow, keep talking. Do NOT re-run it. If it *fails* partway and the retry
> says "registered to a different project: <unknown>", run `wheels start --force`.

### Beat 2 — scaffold a Post (8 min)

```bash
wheels generate scaffold Post title:string{50} body:text publishedAt:datetime --dry-run
```

**Say:** "Here is everything it would write. Nothing has happened yet." Then for real:

```bash
wheels generate scaffold Post title:string{50} body:text publishedAt:datetime
```

Read the created files aloud: `app/models/Post.cfc`, the timestamped
`_create_posts_table.cfc` migration, `app/controllers/Posts.cfc`, five views,
`tests/specs/models/PostSpec.cfc`, `tests/specs/controllers/PostsControllerSpec.cfc`,
and `.resources("posts")` appended to `config/routes.cfm`.

**Say:** "Singular model, plural controller, plural table. I never told it any of
that. And `{50}` set the column length *and* wrote `validatesLengthOf(maximum=50)` into
the model — the schema and the validation come from one declaration."

```bash
wheels migrate latest          # "Created table posts"
wheels seed --generate         # "Seeded: 10 created, 0 skipped"
wheels reload                  # routes now appear without it on 2461, but model config still needs it — keep it
wheels routes | grep posts     # 16 rows: 7 actions × with/without .[format]
```

**Say over the route table:** "One line of config, the whole REST surface. Each route
is named — `posts`, `newPost`, `editPost`, `post` — and the views use
`linkTo(route="editPost", key=post.id)`, so nothing hard-codes a URL."
(The unfiltered table is 54 rows because it includes 38 internal `/wheels/*` routes — hence the grep.)

Browser → `http://localhost:8080/posts` → 10 seeded rows → **create a post titled
"Hello, Wheels"** (Beat 4's `LIKE '%Wheels%'` depends on it) → edit it → delete a seeded one.
Each step flashes "Post was created/updated/deleted successfully." **Do this slowly.** This is
the payoff shot of the whole talk.

> ⏱ Running long? Skip `--dry-run` and `wheels routes`, keep the browser CRUD.

### Beat 3 — open the generated code (5 min)

Open `app/models/Post.cfc` and `app/controllers/Posts.cfc` in the editor.

**Say:** "This is the difference between a scaffold and a black box. There is no
runtime magic reading my model at request time to invent a form. It wrote files.
I can delete half of this and it still runs."

The model already has `validatesPresenceOf("title,body,publishedAt")` and
`validatesLengthOf(property="title", maximum=50)`. Point at them. Then type — your first
hand-typed code, make it count:

```cfml
validatesExclusionOf(property="title", list="Untitled");   // all-named args — the mixed form throws
hasMany("comments");
```

> Whatever you type here must keep the scaffold's own sample data valid. `validatesUniquenessOf("title")`
> makes Beat 4's `seed --generate` roll back (seeded titles repeat); a `minimum=` on body fails the
> generated specs' `"MyText"`. Exclusion of a placeholder title is safe and reads as a real rule.

```bash
wheels reload
```

Browser: submit the form empty → inline red errors appear with no view changes.

**Say:** "The form partial already knew how to render errors. That's the
convention paying you back the second time."

> Known cosmetic (BUGS #9): the date selects repeat the PublishedAt error six times.

### Beat 4 — associations (5 min)

```bash
wheels generate scaffold Comment body:text --belongsTo=post
wheels migrate latest
wheels seed --generate         # 20 created: 10 more posts + 10 comments, post_id 1..10
wheels reload                  # new model + the hasMany you just added
```

**Say:** "`--belongsTo=post` added a `post_id` column to the migration and wired
`belongsTo("post")` into the model. I added `hasMany("comments")` on the Post a
minute ago, so the relationship is complete in both directions."

```bash
wheels console
```

```cfml
model("Post").findByKey(1).comments()          // → one-row table (comment 1)
model("Comment").findByKey(3).post().title     // → Test Title 3
model("Post").where("title", "LIKE", "%Wheels%").orderBy("publishedAt", "DESC").get()
                                               // → Hello, Wheels
```

**Say:** "Chainable query builder, associations as methods, parameterized
underneath — every one of those becomes a `cfqueryparam`. You cannot
accidentally write a SQL injection with the finder API."

> ⚠ Each console line is its own stateless request — variables do **not** carry between lines.
> `orderBy` takes `(property, direction)`. Avoid `findOne(include="comments")` on stage — it prints a
> flattened row plus a second JSON dump and looks broken (BUGS #13).

> ⏱ The console is the first thing to cut if you're behind.

### Beat 5 — authentication (10 min)

```bash
wheels generate auth --strategy=session
wheels migrate latest          # users table + unique email index
wheels reload                  # REQUIRED or /register 404s
wheels test > /dev/null 2>&1   # OFF-SCREEN warm-up (BUGS #3) — do this while talking
```

Read out what it generated: `User` model, `Sessions` / `Registrations` /
`Passwords` controllers, CSRF-safe views, a create-users migration with a unique
email index, routes and services wired in, plus specs.

Open `app/models/User.cfc`:

**Say:** "Passwords go through bcrypt — the framework's own `bcryptHash()` and
`bcryptVerify()`. Wheels ships jBCrypt inside the framework, so there is nothing
to install and nothing to hand-roll; the hashes are standard `$2a$` strings that
htpasswd and every other bcrypt library understand. Login timing is equalized.
And there's `bcryptNeedsRehash()` so you can raise the cost factor in five years
without a password reset email. That is not a checkbox — that is the thing every
one of us has hand-rolled badly at least once. The same hash verifies on Lucee,
Adobe, BoxLang and RustCFML."

Browser → `/register` (flash "Welcome!") → log out ("You have been logged out.")
→ `/login` wrong password ("Invalid email or password.") → correct ("Welcome back.").

Then authorization:

```bash
wheels generate policy Post
```

Open `app/policies/PostPolicy.cfc` — every action returns `false`.

**Say:** "Default-deny. Every action denies until you write the rule, and
`policyScope()` returns a no-rows query. The failure mode of forgetting to write
a policy is a 403, not a data leak."

Grant one rule live (the policy sees `user` as a struct and the record as `record`):

```cfml
public boolean function show() {
    return IsStruct(user) && !StructIsEmpty(user);   // any signed-in user
}
```

**Optional 403 moment (60 s):** add `authorize(post);` after `findByKey` in
`Posts.show`, `wheels reload`, hit `/posts/1` logged out → **403 Wheels.NotAuthorized**
with a suggested action and a *Copy* button (set-up for Beat 8). Log in → 200.
**Then delete the `authorize(post);` line and reload** — otherwise two Posts CRUD specs
fail with 403 in Beat 6.

> ⏱ If you're behind: generate auth, show the model, skip the policy — but say
> the default-deny sentence anyway.

### Beat 6 — tests (8 min)

```bash
wheels test                    # 27 passed (second run — see warm-up above)
```

**Say while it runs:** "Those specs came with the scaffold — a model spec and
seven CRUD controller specs per resource, plus the auth specs. WheelsTest is the
framework's own BDD runner — describe, it, expect — nothing extra to install."

Open `tests/specs/models/PostSpec.cfc`, add a real assertion **on body, not title**
(the `{50}` length rule keeps an empty title invalid even with presence removed, so
a title spec never goes red):

```cfml
it("requires a body", () => {
    var post = model("Post").new(title="No body here");
    expect(post.valid()).toBeFalse();
    expect(post.errorsOn("body")).notToBeEmpty();
});
```

```bash
wheels test                    # 28 passed
```

Green. Comment out `validatesPresenceOf(...)` in `Post.cfc`, `wheels reload`,
`wheels test` → **27 passed, 1 failed: requires a body**. Restore, reload, green.

**Say:** "Red, green. On a framework a lot of people in this room wrote off as
'that CFML Rails clone that never shipped.' It ships. It has for a while now."

> ⏱ The break-it-then-fix-it loop is the first cut if you're over. The passing run is not.

### Beat 7 — the tour (7 min)

```bash
wheels info            # version, engine, db, server status
wheels migrate diff    # "No differences found — models and database are in sync."
wheels coverage        # runs the suite, prints a CRAP table, reverts instrumentation
wheels generate api-resource Product name price:decimal sku:string
wheels migrate latest && wheels reload
curl -X POST localhost:8080/api/products -H 'Content-Type: application/json' \
     -d '{"product":{"name":"Brake Drum","price":149.99,"sku":"BD-1000"}}'   # 201 + JSON
curl localhost:8080/api/products                                              # 200
```

**Say over `api-resource`:** "Same generator, no views, JSON controller under an
`/api` namespace. The API story is the same story."

Then name — don't demo — what's in the box: middleware with CORS, CSP, HSTS and
rate limiting; SSE channels; background jobs; a storage abstraction with local and S3
drivers and a from-scratch SigV4 signer; Kamal-compatible deploy.

**Say:** "In Rails, four of those are gems. Here they're the framework."

> ✂ `wheels doctor` stays out (still flags the scaffold's own `new(params.x)`/`update(params.x)` five times).
> `wheels stats` is fixed on 2461 and can go back in if there's time. Don't run `wheels test` after
> `api-resource` (stale `_wheelsTest` application — RETEST-2461 B).

### Beat 8 — the AI angle (5 min)

```bash
wheels mcp wheels              # NOT bare `wheels mcp` — that prints "missing module name"
```

**Say:** "That's a stdio MCP server. Nineteen tools, auto-discovered from the CLI — generate,
migrate, seed, test, routes, reload. Point Claude Code or Cursor at your Wheels app and it can
scaffold a resource, run the migration, seed it and run the suite against your actual project — not its
memory of a framework it half-read on the internet. And `wheels new` drops a `CLAUDE.md`
and an `AGENTS.md` into the project so the assistant starts out knowing the conventions.
When something blows up, the dev error page has a Copy button that puts the whole exception
on the clipboard as JSON, ready to paste into your agent."

Show the `.mcp.json` line: `{"mcpServers":{"wheels":{"command":"wheels","args":["mcp","wheels"]}}}`

> ✅ Verified on 2461 over MCP: `generate {type:scaffold, name:Tag, attributes:"name:string{30} slug:string"}`
> → `migrate {action:latest}` → `reload` → `seed {generate:true}` → `/tags` served 200. If you want to show it
> live, a Claude Code session pointed at the project with the `.mcp.json` above is the cleanest way.

**The honest note — say this one, it buys you enormous credibility:** "I maintain
this framework as one person. The reason 4.x has moved this fast is that I'm not
doing it alone in the sense that matters — the CI, the issue triage, the
reproduction cases, the test enforcement are all agent-driven. That's a talk of
its own if Rick will have me back."


---

## Fallbacks

| If this breaks | Do this |
|---|---|
| `wheels new` fails or hangs | `cd ~/demo/blogdemo-final` in the second tab — "here's one I made earlier" — and keep going. Nobody minds. |
| Server won't start / port in use | `wheels stop`, then `wheels start --port=8081`. "Registered to a different project: <unknown>" after a failed start → `wheels start --force`. If it's still bad, switch to the backup video for that beat. |
| A generator errors | `git checkout cp<N>` to the next checkpoint tag and continue. Say "let me jump ahead" — not "that's odd." |
| Migration fails | `wheels migrate info` shows state. **`wheels db reset` does NOT drop anything** (it runs pending migrations + reseeds). Clean slate: `wheels stop && rm db/*.sqlite && wheels start && wheels migrate latest && wheels seed --generate` — never delete the SQLite files with the server running (`SQLITE_READONLY_DBMOVED`). |
| Tests fail unexpectedly | If it's the Comment CRUD specs on the first run, just run `wheels test` again (known first-run bug). Otherwise don't debug on stream. "That's a real bug and I'll fix it on air after the meeting" is a *great* moment. Move on. |
| Whole machine goes sideways | Play the recorded dry run and narrate over it. Have it open in QuickTime, paused, before you start. |

**The rule:** you get one debugging attempt, capped at 60 seconds. After that you
move to the fallback. A presenter who recovers smoothly looks better than one who
never breaks.

---

## Things to say if the room goes quiet

- "How many people here still have a CF app in production? …Right. That's why this matters — this isn't a rewrite, it's a place to put the next feature."
- "Rick, does this look like the Rails video?"
- "Question I always get: does it run on Adobe? 2018 through 2025. And on BoxLang, which is where a lot of new CFML is going to land — and on RustCFML, a JVM-free CFML interpreter written in Rust, which is a supported engine as of 4.x."

## Questions you will get — have the answer ready

**"Is this actually maintained?"** — 4.0 shipped this year, 4.1 is current, releases are on a regular cadence, changelog is public. One primary maintainer, and I'll be straight with you about that.

**"How do I move an existing app to it?"** — You don't, in one go. Wheels sits at a URL. Run it beside the legacy app and move a route at a time.

**"What about Adobe licensing?"** — Runs on Lucee, BoxLang and RustCFML, all open source. Your engine choice is yours.

**"Why not just use Rails/Laravel?"** — If you're hiring a new team and starting fresh, maybe you should. If you have twenty years of CFML and people who know it, this is how that codebase gets a modern shape without a rewrite you'll never finish.

**"Performance?"** — 4.0.6 and 4.1 together made model materialization roughly 3x faster. There's a benchmark suite in the repo. Happy to take specifics offline.

**"We still have RocketUnit tests."** — `wheels.Test` is deprecated in 4.1 with a one-time warning and goes away in 5.0. Same describe/it/expect shape in WheelsTest, so it is mostly a base-class rename.

---

## After the stream

- [ ] Post the deck link and the demo repo in the CFUG channel / to Rick for the YouTube description
- [ ] `wheels.dev` · `guides.wheels.dev` · `github.com/wheels-dev/wheels` · ForgeBox `wheels-core`
- [ ] Ask Rick about the intermediate session while the reception is fresh

# Demo runbook — "Wheels 4.1: Modern CFML, the Rails Way"

A rehearse-it-end-to-end script for the live build. Everything here is the
real CLI, real code, and real output — practice it twice and the night is
just typing.

This is **Part 2 of a ~60-minute talk** (see [`deck.md`](deck.md)). The live
build is the centerpiece at **~25 minutes**, leisurely; Parts 3–5 (the deeper
feature tour, the 4.1 release story, and the close) are slides and terminal
snippets, not more live typing. In a 1.5-hour meeting that leaves ~30 minutes
for announcements and Q&A.

Rehearsed against **Wheels 4.1.0-snapshot / upcoming 4.1**. 4.1 is what we're
shipping; the cut is held to absorb polish and the release blog is postponed
to ~September 17. Treat this build as 4.1.

## Prerequisites

- Wheels CLI 4.1.0-snapshot (`wheels --version`) — Homebrew/Scoop/apt. Java 21.
- A clean shell. No prior app state.
- Optional but recommended: run the build once the day before so the Lucee
  server JARs and the SQLite JDBC driver are cached (first boot is the slow one).
- The two-post seed file at [`demo-app/seeds.cfm`](demo-app/seeds.cfm) — copy
  it into the new app after the first migrate (LuCLI has no
  `wheels generate seed`).

> The rehearsal checklist is at the bottom — read it before the talk.

---

## Act 1 — the `wheels new` moment (≈2 min)

```bash
wheels new blog
cd blog
wheels start
```

Open the printed URL. **Point at the welcome sentence**:

> Your Wheels … application is running on Lucee with blog (development).

That's version, engine, datasource, and environment — a prose sentence, not
a `Wheels · engine · db · env` status chip.

**Say:** "That's the whole stack — a running app with zero config. No
`Application.cfc` hand-editing, no wiring, no XML. It's already up."

> Gotcha: `wheels new` may ask for the app name if you omit it; pass it as the
> positional arg as above. If `wheels start` picks a port you don't like,
> stop and restart with `--port`. If a leftover server name collides
> (registered to a different path), `wheels start --force`.

---

## Act 2 — scaffold + migrate + seed (≈4 min)

```bash
wheels generate scaffold Post title:string body:text
wheels migrate latest
```

Drop the prepared two-post seed into place, then seed. LuCLI has no
`wheels generate seed` — `wheels generate snippets seed-data` writes
Role/Setting stubs under `app/snippets/`, which is the wrong content
for this talk.

```bash
mkdir -p app/db
# from the talk checkout, or paste the 8 lines from demo-app/seeds.cfm
cp /path/to/docs/presentations/cfug-2026-09-15/demo-app/seeds.cfm app/db/seeds.cfm
wheels seed
```

Reload `/posts`. Two posts are on screen — no form-filling. Click through
show / edit / delete on one of them if you want the CRUD click-tour;
the seed already proved the list.

**Open one generated file** (`app/models/Post.cfc`, `app/controllers/Posts.cfc`)
to make the point that it's **real code you own**, not a black box.

**Say:** "One command produced the model, the migration, the controller, the
views, the tests, and the route. `wheels seed` put content on the page.
In Rails this is the `generate scaffold` moment — same idea, same payoff."

> Gotcha: the scaffold also drops a `.resources("posts")` line into
> `config/routes.cfm` automatically. Mention that you didn't touch routing yet.
> `wheels seed` needs the server already running (it is, from Act 1).

---

## Act 3 — associations + validation (≈4 min)

```bash
wheels generate scaffold Comment postId:integer author:string body:text
wheels migrate latest
```

Edit **`app/models/Post.cfc`** — add the association in `config()`:

```cfm
component extends="Model" {
    function config() {
        hasMany(name="comments", dependent="delete");
    }
}
```

Edit **`app/models/Comment.cfc`**:

```cfm
component extends="Model" {
    function config() {
        belongsTo(name="post");
        validatesPresenceOf("author,body");
    }
}
```

Show: open a seeded post, add comments, show `post.comments` in the view. Then
submit an empty comment and **let the validation error render**.

**Say:** "No foreign-key config. `belongsTo("post")` figures out `postId` from
the schema. `Post` ↔ `posts`, `Comment` ↔ `comments` — the convention *is*
the configuration."

> Gotcha: if you want nested URLs (`/posts/1/comments`), that's the callback
> syntax in routes — `.resources(name="posts", callback=function(map){ map.resources("comments"); })`.
> Skip it live unless time allows; flat routes keep the demo moving.
> After model edits, hard-reload with
> `?reload=true&password=<WHEELS_RELOAD_PASSWORD>` from `.env` — bare
> `?reload=true` is a silent no-op when a reload password is set (and
> `wheels new` always sets one).

---

## Act 4 — the 4.1 "wow" (≈6 min)

### 4a — route model binding

In **`config/routes.cfm`**, change the posts resource:

```cfm
mapper()
    .resources(name="posts", binding=true)
    .resources("comments")
    .wildcard()
.end();
```

In **`app/controllers/Posts.cfc`**, replace `findByKey` in `show()` with
`params.post`. Scaffolded `show()` is only the finder — there is **no**
`IsObject` / not-found guard to delete.

```cfm
function show() {
    post = params.post;
}
```

A missing `:key` 404s in the dispatcher before the action runs.

**Say:** "With `binding=true`, the dispatcher loads `params.post` before the
action. No `findByKey`. And `bindBy="slug"` swaps the segment to any column
for pretty URLs."

### 4b — one-command auth

```bash
wheels generate auth
wheels migrate latest
```

Reload and show registration + login + logout, all generated. **Point at the
`passwordDigest` column** and say: *PBKDF2-HMAC-SHA256 via the
`passwordHasher` service — per-user salt in the hash, constant-time verify.*

Do **not** call this bcrypt. `bcryptHash()` / `bcryptVerify()` /
`bcryptNeedsRehash()` are a separate 4.1 helper set (Part 4 slides) — they
are not what `generate auth` writes.

### 4c — coverage + the debug bar (the reliable wow)

```bash
wheels coverage --top=5      # change-risk ranking
```

Then the **debug bar** in the browser: request timing, params, queries, the
complexity panel. That's the tooling beat.

`wheels migrate diff` is 4.1 polish (preview what AutoMigrator would say).
Do **not** promise a live crash-free demo of it — mention it only as
"shipping / coming polish" if someone asks.

---

## Act 5 — close (≈2 min)

One slide, then Q&A:

> **Convention over configuration — but you own every line it generates.**

Point to `guides.wheels.dev`, `blog.wheels.dev` (the 4.1 series; the
release post is ~September 17), and `github.com/wheels-dev/wheels`.

**Say:** "Come build something with it — and when it breaks, file the issue.
That's how 4.1 got its security pass: real apps in the wild."

---

## Rehearsal checklist

- [ ] Run the full build once the day before (warms the server + JDBC cache).
- [ ] Time each act; trim Act 4c if you're over 20 minutes.
- [ ] Confirm `wheels generate auth` against the **4.1.0-snapshot** CLI
      you'll use on stage — this talk is the upcoming 4.1 surface, not 4.0.x.
- [ ] Have `demo-app/seeds.cfm` ready to copy (or the 8 lines on a sticky).
- [ ] Have a fallback if the venue Wi-Fi blocks Maven/CFPM downloads — pre-cache
      by running the build once online beforehand.
- [ ] Keep a clean `blog/` dir in a side terminal; if you fat-finger a step,
      `cd .. && rm -rf blog && wheels new blog` resets you in ~10 seconds.
      Then `wheels start --force` if the old `blog` server name is still
      registered.

## If it goes sideways

| Symptom | Fix |
|---|---|
| `wheels start` hangs on first boot | It's downloading engine JARs — wait, or restart. |
| Port already in use | `wheels start --port 8090` |
| Server name registered to another path | `wheels start --force` |
| Migration says "already applied" | `wheels migrate down` then `wheels migrate latest`, or just roll forward. |
| `wheels seed` refuses | Server must be running and bound to this project (`wheels start`). Confirm `app/db/seeds.cfm` exists. |
| Auth generator warns about existing `User` | You already have a User model — scaffold used `User`, pick a different model name with `--model=`. |
| Live edit didn't take effect | Hard reload: `?reload=true&password=<WHEELS_RELOAD_PASSWORD>` from `.env`. Bare `?reload=true` is refused when a password is set. |

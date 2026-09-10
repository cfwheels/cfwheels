# Wheels 4.1: Modern CFML, the Rails Way — a Live Build

Mid-Michigan CFUG · Tuesday, September 15, 2026 · 7:00 PM ET · Peter Amiri

A ~60-minute talk in five parts. Speaker notes are the `> Notes:`
blockquotes. The live build (Part 2) follows [`demo.md`](demo.md) beat-for-beat;
everything else is slides with a few terminal snippets.

This deck matches a rehearsal on **Wheels 4.1.0-snapshot / upcoming 4.1**.
4.1 is what we're shipping — the cut is being held to absorb polish, and the
release blog is postponed to ~September 17. Treat this build as 4.1.

**Timing:** Part 1 ≈ 10 · Part 2 ≈ 25 · Part 3 ≈ 15 · Part 4 ≈ 8 · Part 5 ≈ 3,
leaving ~30 min for announcements and Q&A in a 1.5-hour meeting.

---

# Part 1 — The pitch (10 min)

## Slide 1 — Title

**Wheels 4.1: Modern CFML, the Rails Way**
*A live build*

Peter Amiri · Mid-Michigan CFUG · September 15, 2026

> Notes: Thank Rick. One sentence of framing: "half of this is typing, half is
> the story of why CFML needed this." This is a 4.1 talk on a 4.1.0-snapshot
> build — the release is shipping imminently.

## Slide 2 — The one-liner

**Wheels is the convention-over-configuration MVC framework for CFML.**

- The project you knew as **CFWheels** — rebranded at v3.0.
- **4.1 is what we're shipping** — this build *is* 4.1; the cut is held
  deliberately so polish lands with it.
- Models, migrations, routes, controllers, views — wired by *naming*, not XML.

> Notes: The thesis. Say it slowly. Do not claim "4.1.0 shipped September 10"
> — Peter held the release to absorb polish bugs; the blog post is postponed
> to ~September 17. "This is 4.1" is the true sentence.

## Slide 3 — The Rails DNA

- Convention over configuration, the DHH way.
- `Post` → `posts` → `Posts.cfc` → `/posts`.
- Associations, validations, migrations read like Rails.
- If you've written Rails, **you already know the shape of Wheels**.

> Notes: Aim this at Rick and the RoR folks. It's the bridge that makes the
> rest of the talk land. Controllers are `Posts.cfc` / `Comments.cfc` — not
> `PostsController.cfc`.

## Slide 4 — A short history

- **~2006:** CFWheels announced, in the shadow of the Rails 1.x wave.
- **3.0:** the rebrand to Wheels.
- **4.0:** the big rewrite — dropped the WireBox dependency, shipped its own
  DI container, test framework, and `wheels` CLI.
- **4.1:** the release that makes it feel native, not ported.

> Notes: Give the arc in one breath. The point is continuity: the idea was
> right in 2006; the rewrite finally caught the execution up to the idea.

## Slide 5 — The pain it solves

CFML apps have historically been config-heavy: hand-wired `Application.cfc`,
XML, manual dependency glue. Wheels says **the naming convention is the
configuration** — and it generates real files you own.

> Notes: Name the pain explicitly — it's why the room is here. Then promise the
> antidote is the next 25 minutes.

---

# Part 2 — The live build (25 min)

## Slide 6 — What we're building

1. `wheels new` — a running app, in seconds.
2. **Scaffold + migrate + seed** — full CRUD, content on screen.
3. **Associations + validation** — comments on posts.
4. **Route model binding** — `params.post`, 404s for free.
5. **One-command auth** — PBKDF2, generated.
6. The CLI + debug bar.

> Notes: "No more slideware after this." Everything here is reproducible from
> the repo; the exact commands are in demo.md.

## Slide 7 — The `wheels new` moment

```
$ wheels new blog
$ cd blog && wheels start
```

A running app. The welcome page is a **prose sentence**:

> Your Wheels … application is running on Lucee with blog (development).

> Notes: Beat 1. Zero config to a running app. Gesture at that sentence —
> version, engine, datasource, environment, in English. If `wheels start`
> complains about a leftover server name, `--force`.

## Slide 8 — Scaffold + migrate + seed

```
$ wheels generate scaffold Post title:string body:text
$ wheels migrate latest
$ wheels seed
```

Model, migration, controller, views, tests, route — one command. Then two
posts on `/posts` without typing through the form.

> Notes: Beat 2, the "blog in 15 minutes" moment. Drop
> `demo-app/seeds.cfm` into `app/db/seeds.cfm` (LuCLI has no
> `wheels generate seed`). Open `app/controllers/Posts.cfc` — real code
> you own.

## Slide 9 — Associations + validation

```cfm
// Post.cfc
hasMany(name="comments", dependent="delete");
// Comment.cfc
belongsTo(name="post");
validatesPresenceOf("author,body");
```

`Post` ↔ `posts`. `belongsTo("post")` just works. Errors surface for free.

> Notes: Beat 3. Convention is the star — no FK config, no relationship XML.
> Show a validation failure live.

## Slide 10 — Route model binding

```cfm
.resources(name="posts", binding=true)

function show() {
    post = params.post;   // was findByKey(params.key)
}
```

The dispatcher loads `params.post` before the action; a missing `:key` is a
404. Scaffolded `show()` is only `findByKey` — replace it. `bindBy="slug"`
swaps the segment to any column for pretty URLs.

> Notes: Beat 4. The "wow" — the boilerplate literally disappears. There is
> no IsObject / not-found guard to delete.

## Slide 11 — One-command auth

```
$ wheels generate auth
$ wheels migrate latest
```

Registration + login + logout, generated. Column is **`passwordDigest`**.
Hashing is **PBKDF2-HMAC-SHA256** via the `passwordHasher` service.

> Notes: Beat 5. Point at `passwordDigest`. Do not say bcrypt here —
> `bcryptHash()` / `bcryptVerify()` are a separate 4.1 helper set (Part 4).

## Slide 12 — The CLI + debug bar

```
$ wheels coverage --top=5   # change-risk ranking
```

Plus the dev debug bar: request timing, params, queries, the complexity panel.

> Notes: Beat 6. This is the reliable wow. `migrate diff` is 4.1 polish —
> do not promise a live crash-free demo of it.

---

# Part 3 — The deeper tour (15 min)

## Slide 13 — The ORM

```cfm
model("User")
    .where("status", "active")
    .where("age", ">", 18)
    .orderBy("name")
    .get();

model("User").active().recent().findAll();   // named scopes
user.isDraft();                              // enum checkers
```

Chainable query builder, scopes, enums, `include=` associations, batch finders.

> Notes: Don't rebuild it live — show the shape and connect it to what they
> just saw. 2-/3-arg `where` is injection-safe; 1-arg is raw SQL.

## Slide 14 — DI container + middleware

```cfm
// config/services.cfm
local.di.map("emailService").to("app.lib.EmailService").asSingleton();
local.di.map("storage").toFactory(function() { return new ...; });

// config/settings.cfm
set(middleware=[new wheels.middleware.SecurityHeaders(), ...]);
```

Dependency injection *and* a middleware pipeline — the two things that used to
mean a third-party framework.

> Notes: "WireBox used to be a dependency. Now the container is `vendor/wheels`."

## Slide 15 — Background jobs + realtime

```cfm
job.enqueue(data={email: user.email});   // app/jobs/*.cfc
renderSSE(data=json, event="update");    // server-sent events
```

Queues, retries with backoff, and SSE/channels for live updates.

> Notes: Breadth over depth. Name them, don't demo them.

## Slide 16 — Storage + multi-tenancy

```cfm
service("storage").disk("s3").put("reports/q3.pdf", bytes);
service("storage").disk("s3").signedUrl(key=..., expiresIn=900);
```

`LocalDisk` / `S3Disk` behind one interface (SigV4, no AWS SDK), plus a
`TenantResolver` middleware for database-per-tenant apps.

> Notes: This is the "enterprise CFML" checklist item — files to S3 and
> multi-tenant routing out of the box.

## Slide 17 — Testing

```cfm
component extends="wheels.WheelsTest" {
    function run() {
        describe("Post", () => {
            it("validates", () => { expect(model("Post").new().valid()).toBeFalse(); });
        });
    }
}
```

BDD test framework built in (TestBox dependency gone), browser tests via
Playwright, and `wheels coverage` for change-risk.

> Notes: "Tests are first-class, not an afterthought."

## Slide 18 — The CLI

`wheels new · generate · migrate · seed · test · console · deploy · doctor · coverage`

A first-party CLI built on the LuCLI runtime — Homebrew/Scoop/apt. CommandBox
still works; the CLI is an accelerator, not a gate.

> Notes: Name the verbs. They already saw `new`, `generate`, `migrate`,
> `seed`, and `coverage`. The deploy verb (Kamal-style) is worth one
> sentence if time allows.

---

# Part 4 — The 4.1 release (8 min)

## Slide 19 — What's in 4.1

- **`generate auth`** — session/token/JWT scaffolds; **PBKDF2-HMAC-SHA256**
  into `passwordDigest`.
- **`bcryptHash()` / `bcryptVerify()`** — a *separate* 4.1 helper set
  (OpenBSD/jBCrypt-compatible). Not what `generate auth` uses.
- **`enableSession()`** — one-line auth wiring.
- **`bindBy=`** and **`toFactory()`** — routing and DI ergonomics.
- **CLI:** `coverage`, `generate --dry-run`, `--offline` — plus `migrate
  diff` as shipping polish.
- **The security-hardening pass** and a **2.5x** model-instantiation speedup.

> Notes: Keep bcrypt and `generate auth` in different sentences. Tie each
> other bullet to something they saw in the live build. The release is
> shipping imminently — this snapshot *is* the 4.1 surface.

## Slide 20 — The hardening pass

"Fail closed, everywhere" — mass-assignment strictness, sanitized `linkTo`
hrefs, typed storage errors, fail-closed tenant routing.

> Notes: One sentence on the philosophy: the framework should assume the worst
> and make you opt into the risky path.

## Slide 21 — 2.5x faster + coverage

Model instantiation rewritten (compile-time includes, no per-instance copy
loop) — and a `wheels coverage` command that ranks your change-riskiest files
by cyclomatic complexity × test coverage.

> Notes: The perf story has a fun punchline (the long way), but keep it to two
> sentences. Point at the debug bar's complexity panel.

---

# Part 5 — Close (3 min)

## Slide 22 — You own every line

> **Convention over configuration — but you own every line it generates.**

Generated code is yours to edit; `--force` regenerates it. Wheels isn't magic —
it's conventions plus real files.

> Notes: Pre-empt the "black box" objection. This is the trust statement.

## Slide 23 — Where to go, and Q&A

- **guides.wheels.dev** — the docs
- **blog.wheels.dev** — the 4.1 series (release post ~September 17)
- **github.com/wheels-dev/wheels** — issues, PRs, stars

> Notes: "Come build something with it — and file the bug when it breaks."
> Then open the floor.

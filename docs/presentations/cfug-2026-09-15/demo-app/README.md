# Demo app reference

The **target end-state** of the live build in [`../demo.md`](../demo.md) — the
files you *write by hand* during the talk. Everything else (controllers,
views, migrations, tests) is produced deterministically by `wheels generate`,
so this directory only captures what you actually type.

Use it to diff your rehearsal build against the finished shape:

```bash
diff app/models/Post.cfc docs/presentations/cfug-2026-09-15/demo-app/Post.cfc
diff app/models/Comment.cfc docs/presentations/cfug-2026-09-15/demo-app/Comment.cfc
```

## Seed (in the live-build script)

[`seeds.cfm`](seeds.cfm) is a **first-class ~30s beat** after the first Post
scaffold + migrate — not an afterthought. Copy it to `app/db/seeds.cfm` and
run `wheels seed` so `/posts` has two rows without typing through the form.

```bash
mkdir -p app/db
cp docs/presentations/cfug-2026-09-15/demo-app/seeds.cfm app/db/seeds.cfm
wheels seed
```

Why a prepared file instead of a generator:

- LuCLI has **no** `wheels generate seed` (`Unknown generator type: seed`).
- `wheels generate snippets seed-data` writes Role/Setting stubs under
  `app/snippets/` — wrong models for this talk, plus a copy step.
- Two `seedOnce()` calls on `Post` have no auth coupling (no `User`, no
  `passwordDigest`).
- `wheels seed` needs the server already running (true after Act 1).

If the copy path is awkward on stage, paste the eight lines from `seeds.cfm`
into `app/db/seeds.cfm` instead.

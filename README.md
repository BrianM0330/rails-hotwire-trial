# README

Rails 8 + Hotwire (Turbo/Stimulus) + Tailwind photo gallery on SQLite.

## Stack

- Ruby 3.4.9, Rails 8.1
- SQLite (app DB + `solid_cache` + `solid_queue` + `solid_cable`)
- Hotwire: Turbo + Stimulus
- Tailwind CSS via the standalone `tailwindcss-rails` binary
- Importmap (no JS build step — ES modules served directly)
- Active Storage with libvips
- Minitest

## Local development

```
bin/setup
```

That runs `bundle install`, prepares the DB, seeds it, and starts `bin/dev` (Rails + Tailwind watcher via foreman). Pass `--skip-server` to stop before launching.

To start the dev server later:

```
bin/dev
```

Note: plain `bin/rails s` will not rebuild Tailwind — always use `bin/dev`.

### Tests

```
bin/rails test            # unit + integration
bin/rails test:system     # browser tests (Capybara + Selenium)
bin/ci                    # full local CI: rubocop, brakeman, audits, tests
```

## Deployment

Deployed to Fly.io: <https://rails-hotwire-trial-earnest-current-5647.fly.dev>

```
fly deploy
```

Config lives in `fly.toml`. The app runs as a single machine in `sjc` with a persistent volume mounted at `/rails/storage` for SQLite + Active Storage. `bin/docker-entrypoint` runs `db:prepare` and `db:seed` on every boot (seeds are idempotent).

## Architectural decisions

### Auth

Stock Rails 8 `has_secure_password` — no Devise. No roles or JWT needed for this scope. If admin/RBAC requirements appeared, I'd reach for a library.

Sign-up is enabled to make the live demo more interactive.

### Photos

Storing the source URL only. The CSV reveals srcsets/dimensions are query-driven; if the CSV had to be the canonical source forever, persisting those fields would be worth it.

### Likes & comments

Unique indexes for DB integrity and to prevent duplicates. Pairs with `create_or_find_by` at the model layer.

### Counter caches

`likes_count` / `comments_count` on `Photo` to avoid N+1 on the gallery. Note: a raw SQL delete would skew the count; would add triggers if that became a real risk in production.

## AI-assisted sections

In a 72-hour window I let AI handle some boilerplate so I could focus on backend correctness:

- Landing page (industry-standard, generic)
- General visual design (clean, accessible, complementary to the Clever hex palette)
- Gallery + lightbox component (used the rails blocks pattern; I wrote a simpler Stimulus controller for the like button initially)

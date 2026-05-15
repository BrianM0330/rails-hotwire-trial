# Photo Gallery (Rails + Hotwire)

Live Rails app: <https://clever-rails-gallery.bmendo.dev/>

A full-stack photo gallery built with Rails 8.1, Hotwire, Tailwind v4, and SQLite. The goal is a boring, reviewer-friendly Rails submission: server-rendered pages, Turbo-powered partial updates, durable database state, predictable setup, and tests around the edge cases that matter.

## What to Look For

- Rails 8 `has_secure_password` authentication with seeded demo users and optional public sign-up.
- Photos, likes, comments, sessions, and counters are database-backed.
- The filled/outlined star is scoped to the current user, while the numeric count remains global.
- Likes use RESTful Rails routes plus Turbo Stream replacement, not SPA client state.
- Duplicate like creation is race-aware through `create_or_find_by` plus a unique `[user_id, photo_id]` index.
- Gallery rendering avoids per-card like queries by precomputing the current user's liked photo IDs once.
- DB integrity includes foreign keys, `NOT NULL`, unique indexes, and check constraints.
- Tests cover model constraints, request behavior, Turbo responses, auth gates, and rendered system behavior.

## Reviewer Quickstart

```bash
git clone <repo-url>
cd rails-hotwire-trial
bin/setup
```

`bin/setup` installs gems, prepares the database, seeds sample data from `photos.csv`, and starts the app through `bin/dev`.

For later runs:

```bash
bin/dev
```

Open <http://localhost:3000>. Use `bin/dev`, not `bin/rails s`, so the Rails server and Tailwind watcher both run.

## Test Accounts

All seeded users use `password`.

| Email              | Password |
| ------------------ | -------- |
| <brian@clever.com> | password |
| <ryan@clever.com>  | password |
| <jake@clever.com>  | password |
| <mike@clever.com>  | password |
| <admin@clever.com> | password |

Public sign-up is enabled so reviewers can exercise the live demo without relying only on seed accounts.

## Running Tests

```bash
bin/rails test         # model + controller/integration tests
bin/rails test:system  # Capybara/Selenium browser tests
bin/ci                 # local CI: setup, lint, security checks, tests, seed replant
```

## Tech Stack

- Ruby 3.4.9 / Rails 8.1
- SQLite for app data, cache, queue, and cable
- Hotwire Turbo Streams for like/unlike updates
- Stimulus for small local UI enhancements: PhotoSwipe setup and copy-to-clipboard feedback
- Tailwind CSS v4 through `tailwindcss-rails`, no Node toolchain
- Importmap for browser JavaScript modules
- Minitest + Capybara/Selenium

## Architecture Notes

### Authentication

Authentication uses the Rails 8 `has_secure_password` pattern rather than Devise. That keeps the auth surface small for this scope while still providing session-backed sign-in, sign-out, password reset scaffolding, and global auth gates for private gallery pages.

### Database Design

Photos are seeded from the provided CSV into SQLite. The `Photo` model stores the Pexels source metadata and generates responsive image URLs from the stored `pexels_id`, so the database does not need to persist every image variant.

Likes are durable rows with foreign keys to users and photos. The one-like-per-user-per-photo rule is enforced by the database with a unique index on `[user_id, photo_id]`. `likes_count` and `comments_count` are Rails counter caches, so the gallery does not count associations for every card render.

Database integrity is enforced with `NOT NULL` constraints, foreign keys, unique indexes, and check constraints for positive photo dimensions/source IDs and non-negative counters.

### Like Semantics & Race Conditions

The star reflects whether the current signed-in user liked the photo. A photo can show a non-filled star with a positive count if other users liked it.

Like creation uses `Current.user.likes.create_or_find_by(photo: @photo)`, paired with the unique database index, so duplicate or concurrent POSTs collapse to one row. Unlike is idempotent and scoped to the current user's like only.

For rendering, the index precomputes the current user's liked photo IDs in one query with `pluck(:photo_id).to_set` and passes that set into the card partials. That avoids N+1 like-state queries while keeping the UI current-user-aware.

### Hotwire vs Stimulus

Likes are intentionally server-confirmed Turbo Stream updates, not optimistic Stimulus state. A Stimulus-first approach could flip the icon immediately, but it would still need reconciliation for failed requests, auth redirects, duplicate clicks, and concurrent changes from another tab. Here the database write succeeds first, then the server returns the canonical button/count HTML.

Stimulus is still used where it fits without owning persistence: initializing PhotoSwipe and showing copy-to-clipboard feedback.
Before the realtime likes I did use Stimulus.

## Tests

The suite covers the product behavior and data-integrity paths rather than only smoke tests:

- Auth gates for private photo pages and like actions
- Public signup and session creation
- Like creation, duplicate prevention, idempotent create, and safe unlike
- Unlike scoped to the current user
- Current-user liked state versus global like count state
- Turbo Stream response shape for like/unlike
- Counter cache changes
- DB-level foreign key, uniqueness, not-null, and check constraints
- System coverage for rendered like state and liking from the gallery UI

## Tradeoffs

- Comments are modeled and seeded, but the visible MVP focuses on gallery browsing and likes. I kept the product surface small so the core interaction is polished and well-tested.
- Likes use Turbo Streams rather than optimistic Stimulus. That trades a tiny amount of perceived immediacy for simpler correctness and canonical server-rendered state.
- System tests are intentionally outside `bin/ci` because local browser availability varies; run `bin/rails test:system` when validating the full UI.

## Future Improvements

- Add a polished comments UI on the photo detail page using Turbo Streams.
- Add pagination or infinite scroll if the gallery grows beyond the provided CSV.
- Add search/filtering by photographer, orientation, or liked status.
- Add photographer ownership and authorization rules if photos become user-managed.
- Add Active Storage uploads if the app moves beyond seeded Pexels photos.

## Deployment

The Rails app is deployed on a VPS behind Caddy for automatic TLS and static asset serving.

Live Rails app: <https://clever-rails-gallery.bmendo.dev/>

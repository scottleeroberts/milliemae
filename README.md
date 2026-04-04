# Sew Twirly

`milliemae` is the repository name. The application itself is `Sew Twirly`: a Rails 8 platform for sharing sewing projects with shoppable image hotspots.

## Current Status

The core product is implemented and exercised by model, request, mailer, service, actor, and system specs.

- Public discovery feed with tag filters and pagination
- Public project pages with hotspot-based shopping links
- Public creator profiles with follow counts and social links
- Audience accounts with self-service sign-up
- Invite-only creator onboarding
- Creator dashboard for drafting, publishing, image upload, and hotspot annotation
- Admin dashboard for invitations, user role changes, project moderation, and recent-comment cleanup

What is not fully production-ready yet:

- `config/deploy.yml` still contains placeholder infrastructure values
- GitHub Actions runs security and lint checks, but not the RSpec suite
- Production mailer and storage services still need real environment-specific configuration

## Product Behavior

### Roles

- Visitors can browse published projects and creator profiles
- Audience users can sign up directly, then like projects, follow creators, and leave comments
- Creators are created through invitation acceptance and can manage their own projects, images, and hotspots
- Admins can invite creators, change user roles, unpublish/delete projects, and delete comments from the dashboard

### Core Domain

```text
User -> Project -> ProjectImage -> ProductLink
User -> Like -> Project
User -> Follow -> User
User -> Comment -> Project
User(admin) -> Invitation -> creator signup
```

Current model behavior from the app:

- `User` roles: `audience`, `creator`, `admin`
- Creator profile URLs use usernames: `/creators/:username`
- Project URLs use slugs: `/projects/:slug`
- Projects support Action Text bodies and up to 10 tags
- Project images are ordered and store analyzed width/height metadata
- Product links use normalized `x`/`y` coordinates from `0.0` to `1.0`
- Image uploads accept `jpeg`, `png`, `webp`, and `gif`, up to 10 MB
- Invitations expire after 7 days
- Login, sign-up, comments, and invitation acceptance are rate-limited with `rack-attack`
- The app only allows modern browsers outside test mode

## Stack

| Layer | Current choice |
| --- | --- |
| Framework | Rails 8.1.2 |
| Ruby | 3.4.7 |
| Database | PostgreSQL |
| Views | Slim |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS |
| Assets | Propshaft + Importmap + `tailwindcss-rails` |
| Auth | Devise |
| Rich text | Action Text |
| File uploads | Active Storage + `image_processing`/libvips |
| Jobs | `:async` in development, Solid Queue in production |
| Cache | memory store in development, Solid Cache in production |
| Deployment | Docker + Kamal scaffold |
| Tests | RSpec, FactoryBot, Capybara, Selenium |

Important correction versus the old README: this app does not use `solid_cable`, and it is not strictly “no build step” because Tailwind is watched in development via `bin/dev`.

## Local Setup

### Prerequisites

- Ruby `3.4.7`
- PostgreSQL
- `libvips` for image variants
- `libpq` development headers for the `pg` gem

If you do not want local native dependencies, use the Docker workflow below instead.

### Boot The App

```bash
bundle install
bin/setup --skip-server
bin/rails db:seed
bin/dev
```

Open [http://localhost:3000](http://localhost:3000).

Notes:

- `bin/setup` installs gems, prepares the database, clears logs/tmp, and can start `bin/dev`
- `bin/dev` runs the Rails server plus the Tailwind watcher through `foreman`
- If your local Postgres setup does not match Rails defaults, export `DATABASE_URL`
- Development uses local disk storage for uploads

## Docker Setup

The repository also includes a development `docker-compose.yml` with:

- `web` on port `3000`
- `db` on port `5432`
- `chrome` on port `4444` for Selenium-backed system specs

```bash
docker compose build
docker compose up -d
docker compose run --rm web bin/rails db:prepare
docker compose run --rm web bin/rails db:seed
```

Then open [http://localhost:3000](http://localhost:3000).

Inside Docker, the app runs through `bin/dev`, so CSS changes are watched there as well.

## Seed Data

`db/seeds.rb` creates a realistic demo dataset:

- 8 users total
- 7 projects total
- 5 published projects and 2 drafts
- 12 project images
- 19 hotspot product links
- likes, follows, and comments across the published feed

Seed accounts all use password `password123`:

| Role | Email |
| --- | --- |
| Admin | `admin@sewtwirly.com` |
| Creator | `emma@sewtwirly.com` |
| Creator | `sofia@sewtwirly.com` |
| Creator | `creator@sewtwirly.com` |
| Audience | `maya@example.com` |
| Audience | `lily@example.com` |
| Audience | `priya@example.com` |
| Audience | `user@sewtwirly.com` |

Seed image behavior:

- one seed image is committed at `db/seeds/images/floral_sundress_main.jpg`
- the rest are downloaded from `picsum.photos` if they are not already present locally
- a first seed run therefore benefits from internet access unless you vendor the remaining images into `db/seeds/images/`

## Tests And Quality Checks

### Test Commands

```bash
bin/rspec
bin/rspec spec/models
bin/rspec spec/requests
bin/rspec spec/system
bin/lint_factories
```

System specs require a remote Selenium Chrome endpoint. The simplest option is:

```bash
docker compose up -d db chrome
```

The test suite expects `SELENIUM_URL`, defaulting to `http://chrome:4444/wd/hub`.

### Static Analysis

```bash
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
```

### CI

GitHub Actions currently runs:

- Brakeman
- Bundler Audit
- `bin/importmap audit`
- RuboCop

It does not currently run `bin/rspec`.

## Deployment

The repo includes:

- a production `Dockerfile`
- `bin/kamal`
- `config/deploy.yml`

Before treating deployment as real, you need to replace scaffold values in [`config/deploy.yml`](/home/sroberts/Development/milliemae/config/deploy.yml):

- example server `192.168.0.1`
- example registry `localhost:5555`
- example production host defaults such as `example.com`/`sewtwirly.com`

Production-specific details from the current codebase:

- `RAILS_MASTER_KEY` is required
- `APP_DATABASE_PASSWORD` is required for the production database config
- `APP_HOST` should be set to your real host
- Active Storage is configured for local disk in production unless you change `config/storage.yml`
- Solid Queue is enabled in production and can run inside Puma when `SOLID_QUEUE_IN_PUMA=true`
- production mail delivery is not configured beyond placeholders

## Repository Map

```text
app/
  actors/        service_actor workflows for feed/admin/creator operations
  controllers/   public, creator, and admin controllers
  javascript/    Stimulus controllers for mobile nav and hotspots
  models/        users, projects, social graph, invites, images, links
  services/      image dimension analysis
  views/         Slim templates
config/
  deploy.yml     Kamal scaffold
  queue.yml      Solid Queue settings
  recurring.yml  recurring production queue maintenance task
db/
  schema.rb      primary application schema
  cache_schema.rb
  queue_schema.rb
spec/
  models/
  requests/
  services/
  mailers/
  actors/
  system/
```

## Practical Notes

- Audience sign-up is open; creator sign-up is invitation-only
- Invitation emails are enqueued with `deliver_later`
- In development, there is no mail preview or local email delivery tool configured by default
- Social interactions use Turbo Streams, but the app is not exposing a public API
- Public pages currently include `About` and `Privacy`

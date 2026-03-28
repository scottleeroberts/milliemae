# Sew Twirly

A Rails 8 platform for makers to showcase sewing projects with shoppable image hotspots. Creators upload project photos, annotate them with clickable product links, and build an audience through likes, follows, and comments.

## Features

- **Image hotspots** — Creators place clickable pins on project photos linking to patterns, fabrics, and notions
- **Invite-only creators** — Admins send email invitations; invitees claim a creator account via token
- **Social layer** — Registered users can like projects, follow creators, and leave comments (all via Turbo Streams, no page reloads)
- **Project publishing** — Draft/publish workflow with rich text descriptions, tagging, and a paginated discover feed
- **Admin dashboard** — User role management, content moderation, invitation tracking
- **Three user roles** — Anonymous visitors (read-only), audience (social features), creators (publish + hotspots)

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Rails 8.1, Ruby 3.4 |
| Database | PostgreSQL 17 |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS, Slim templates |
| Assets | Propshaft + Importmaps (no Node.js, no build step) |
| Auth | Devise (trackable, lockable, timeoutable) |
| Background | Solid Queue, Solid Cache, Solid Cable |
| Images | Active Storage + ImageProcessing |
| Testing | RSpec, FactoryBot, Capybara, Selenium |
| Deployment | Kamal (Docker-native) |
| CI | GitHub Actions (Brakeman, Bundler Audit, RuboCop) |

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- Git

Everything else runs inside containers.

## Getting Started

```bash
git clone <repo-url> && cd milliemae

# Generate credentials (required on first clone)
docker compose run --rm web bundle exec rails credentials:edit

# Start everything
docker compose up

# In a second terminal — set up the database
docker compose run --rm web bundle exec rails db:create db:migrate db:seed
```

Open [http://localhost:3000](http://localhost:3000). Seed accounts:

| Role | Email | Password |
|------|-------|----------|
| Creator | creator@sewtwirly.com | password123 |
| Audience | user@sewtwirly.com | password123 |

## Running Tests

```bash
# Start test dependencies
docker compose up -d db chrome

# Full suite (bin/rspec handles RAILS_ENV=test automatically)
bin/rspec

# Targeted runs
bin/rspec spec/models
bin/rspec spec/requests
bin/rspec spec/system                      # requires chrome container
bin/rspec spec/models/user_spec.rb:42      # single test by line
bin/lint_factories                         # isolated FactoryBot lint run
```

## Architecture

### User Model

Single `User` model with a role enum: `audience` (default), `creator`, `admin`. Usernames are auto-generated from names and used in URLs (`/creators/:username`).

### Core Models

```
User ──has_many──▶ Project ──has_many──▶ ProjectImage ──has_many──▶ ProductLink
  │                  │
  ├── Like ◀────────┘
  ├── Follow (follower ↔ following)
  ├── Comment ◀─────┘
  └── Invitation (sent_invitations)
```

- **Project** — Title, slug (auto-generated), rich text body (Action Text), tags (max 10), draft/published state
- **ProjectImage** — Ordered images with stored dimensions for responsive hotspot positioning
- **ProductLink** — Normalized x/y coordinates (0.0–1.0) for resolution-independent hotspot placement
- **Invitation** — Token-based with 7-day expiry, one pending invite per email

### Frontend

Slim templates, Tailwind CSS, and Hotwire with no JavaScript build step. Stimulus controllers handle mobile navigation, hotspot placement, and hotspot tooltips. Social interactions (likes, follows, comments) update the DOM via Turbo Streams.

## Docker Services

| Service | Purpose | Port |
|---------|---------|------|
| `web` | Rails app (Dockerfile.dev) | 3000 |
| `db` | PostgreSQL 17 | 5432 |
| `chrome` | Headless Chromium for system specs | 4444 |

```bash
# One-off commands
docker compose run --rm web bundle exec rails console
docker compose run --rm web bundle exec rails generate migration AddFieldToTable
docker compose run --rm web bundle install
```

## Deployment

Configured for [Kamal](https://kamal-deploy.org/) (Docker-native deployment). See `config/deploy.yml`.

```bash
bin/kamal deploy      # Build and deploy
bin/kamal logs -f     # Tail logs
bin/kamal console     # Rails console on server
```

Production requires `RAILS_MASTER_KEY` set via environment or `.kamal/secrets`. SSL is enforced. Active Storage defaults to local disk — configure for S3/GCS as needed.

## Project Structure

```
app/
├── controllers/          # Namespaced: admin/, creator/, plus public controllers
├── models/               # User, Project, ProjectImage, ProductLink, Like, Follow, Comment, etc.
├── views/                # Slim templates (not ERB)
├── javascript/           # Stimulus controllers (importmap-loaded)
└── mailers/              # InvitationMailer
config/
├── routes.rb             # Public, creator, admin, and Devise routes
├── deploy.yml            # Kamal deployment config
└── importmap.rb          # JavaScript dependencies
spec/
├── models/               # Unit tests
├── requests/             # Controller/API tests (admin/, creator/)
├── system/               # Browser tests (requires chrome container)
└── factories/            # FactoryBot factories
```

## Code Quality

```bash
docker compose run --rm web bin/rubocop         # Linting (RuboCop Omakase)
docker compose run --rm web bin/brakeman        # Security scanning
docker compose run --rm web bin/bundler-audit   # Dependency vulnerabilities
```

CI runs all three on every pull request via GitHub Actions.

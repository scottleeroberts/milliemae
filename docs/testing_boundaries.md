# Testing Boundaries

These rules document the spec cleanup decisions applied in April 2026. They are intended to keep the suite fast, readable, and behavior-focused.

## Core Rule

- Each behavior should have a primary home.
- Do not assert the same rule in model, actor, request, and system specs unless each layer is proving something materially different.

## Model Specs

- Own validations, associations with business value, scopes, and record-level domain behavior.
- Cover persistence details that do not depend on HTTP or browser behavior.
- Good examples in this app:
  - `Project` slug generation and tag replacement
  - `Invitation` email normalization and case-insensitive pending uniqueness
  - `Comment#destroyable_by?`
  - `ProjectImage` attachment validation

## Request Specs

- Own authentication, authorization, routing, redirects, status codes, flash, and Turbo versus HTML response behavior.
- Assert that the controller performs the right action, not every persistence side effect already covered by a model or service spec.
- Keep these examples:
  - creator-only resource loading and `404` behavior
  - invitation create and destroy response handling
  - like and follow auth and idempotency behavior
  - comment create and destroy response formats
- Avoid these examples:
  - slug generation details
  - Action Text persistence details
  - tag normalization and replacement details
  - attachment internals already covered by lower-level specs

## System Specs

- Own user-critical flows, especially Hotwire and Stimulus behavior that is difficult to prove below the browser.
- Prefer one end-to-end scenario per core interaction instead of splitting the same journey into many tiny examples.
- Keep these examples:
  - comment create and delete without reload
  - like and follow toggle flows
  - invitation acceptance flow
  - hotspot tooltip and annotation interactions
- Avoid system specs that only restate content already proven in request specs with no UI-specific value.

## Actor And Service Specs

- Keep actor specs only when the class coordinates multiple records, transactions, side effects, or typed failure paths.
- Thin wrappers around `save`, `update`, `destroy`, `publish!`, or `unpublish!` do not need their own spec layer.
- Service specs are justified when the service has its own behavior, such as image dimension analysis.

## Helper And Mailer Specs

- Helper specs should cover formatting or conditional presentation logic that would otherwise leak into model or request specs.
- Mailer specs should own mail content and delivery details rather than reasserting those details through request and system layers.

## Factories

- Keep default factories as cheap as possible.
- Use traits for expensive attachments or setup that only some examples need.
- In this app, prefer `:without_image` when a `project_image` example only needs associations.

## App-Specific Ownership Map

- Comments:
  - model owns validations and ownership predicates
  - request owns auth, published-project access, and Turbo versus HTML responses
  - system owns inline create and delete UX
- Invitations:
  - model owns normalization and pending uniqueness
  - actor or service owns transactional side effects
  - request owns admin-only access and response behavior
  - system owns the admin and recipient journeys
- Creator project images:
  - model and service own attachment validity and metadata behavior
  - request owns nested ownership rules and format branching
  - system owns upload, annotate, and removal UX
- Likes and follows:
  - request owns auth and toggle semantics
  - system owns one signed-in toggle scenario and one signed-out access scenario

## Review Checklist

- If a new spec repeats an existing assertion, delete the weaker layer or justify why both are needed.
- If a spec failure would be better explained by a model or service example, move the coverage down.
- If a browser flow matters to users, keep one strong system spec rather than many narrow ones.
- Prefer deleting low-value examples over introducing shared examples that obscure intent.

# Architecture Guidelines

These rules document the refactoring decisions applied in April 2026. They are intended to keep the app readable, testable, and close to normal Rails conventions.

## Models

- Keep models responsible for domain state, validations, associations, scopes, and domain actions that naturally belong to the record.
- Prefer model predicates for reusable authorization checks tied to a record, such as `Comment#destroyable_by?`.
- Do not put view formatting in models. Date labels, display strings, and similar presentation concerns belong in helpers or presenters.
- Avoid growing models with controller-specific branching or request-format logic.

## Helpers

- Use helpers for formatting and small presentation-oriented conditionals that are reused across views.
- Helpers should not persist data or coordinate multi-record workflows.

## Query And Loader Actors

- Read-side actors are acceptable when they package preload strategy, filtering, pagination, or aggregate calculations.
- Name read-side actors by intent:
  - `*Query` for collection reads and aggregate reads
  - `*Loader` for single-resource lookup with eager loading
- Keep query and loader actors side-effect free.

## Command Actors

- Use command actors only when they provide a real boundary:
  - multi-step transactions
  - external side effects
  - cross-model orchestration
  - reusable failure semantics
- Do not introduce a command actor for a single `save`, `update`, `destroy`, `publish!`, or `unpublish!` call with no extra coordination.
- When a command actor can fail in multiple expected ways that controllers must branch on, expose a typed failure reason rather than branching on the human-readable message text.

## Controllers

- Controllers should orchestrate request flow, not hold business rules.
- Shared resource lookup should live in focused private methods or concerns when multiple controllers need the same ownership and nesting rules.
- Keep Turbo Stream and HTML branching compact and close to the action outcome.

## Services

- Use a service object when behavior is procedural, side-effectful, and not naturally owned by a model or controller.
- Service objects should have clear input and a narrow responsibility, such as `ProjectImages::DimensionAnalyzer`.

## Testing

- Model specs own validations, associations with business value, domain predicates, and record-level behavior.
- Helper specs own view formatting logic moved out of models.
- Actor specs should exist only for actors with real orchestration, transactions, or typed failure behavior.
- Request specs own authentication, authorization, routing, response format, and controller integration.
- System specs should cover a small number of end-to-end Hotwire and user-facing flows, not duplicate every CRUD branch.

## Naming

- Prefer names that describe responsibility over generic CRUD names.
- `Index` and `Show` are acceptable in controllers, but read-side service classes should usually be named as queries or loaders.
- Parameter names should use domain nouns unless disambiguation is genuinely necessary.

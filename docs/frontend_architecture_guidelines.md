# Frontend Architecture Guidelines

These rules document the frontend cleanup decisions applied in April 2026.

## Stimulus

- Use Stimulus only for behavior that genuinely requires JavaScript.
- Keep controllers focused on one interaction surface.
- Prefer Stimulus targets, values, and classes over hardcoded selectors and repeated class-name strings.
- Keep controller state explicit and centralized. If a controller has open/closed or annotating/not-annotating state, represent that directly.
- Use DOM writes for dynamic geometry only when necessary, such as tooltip or annotation positioning.
- Clean up global listeners in `disconnect`.

## Accessibility

- Interactive drawers, menus, and tooltip-like surfaces must reflect state with ARIA attributes.
- Return focus after closing overlays when the trigger remains available.
- Buttons and links should remain keyboard operable without requiring custom key handling unless the interaction truly needs it.
- Motion effects should respect `prefers-reduced-motion`.

## CSS And Tailwind

- Keep shared interactive patterns in Tailwind component classes when the same utility stack appears across multiple templates.
- Avoid extracting everything into component classes. Only extract patterns that are repeated and stable.
- Use utility classes directly for page-specific layout and one-off composition.
- Keep animation and transition styling in CSS, not in Stimulus controllers.

## Hotspots

- Public and creator hotspot pins should share the same visual language unless there is a clear product reason to diverge.
- Shared hotspot styling belongs in the Tailwind component layer.
- Tooltip visibility and pin expanded state should stay synchronized.

## Flash Messages

- Flash dismissal behavior belongs in Stimulus.
- Flash appearance and transitions belong in CSS.

## Action Text

- [actiontext.css](/home/sroberts/Development/milliemae/app/assets/stylesheets/actiontext.css) is an isolated editor stylesheet.
- Do not add unrelated app component styling there.
- If editor-specific customizations are needed, keep them narrowly scoped to Trix or Action Text elements.

## Testing

- Use system specs for Stimulus-driven interactions that matter to users.
- Add assertions for state changes, not just visible text, when accessibility behavior is part of the change.
- For stylesheet-only guarantees that do not have a better runtime seam, file-level specs are acceptable.

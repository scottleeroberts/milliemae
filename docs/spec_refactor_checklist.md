# Spec Refactor Checklist

- [x] 1. Delete low-value comment actor specs and rebalance coverage.
- [x] 2. Delete low-value creator project image actor specs and rebalance coverage.
- [x] 3. Prune duplicate comment request and system assertions.
- [x] 4. Reduce invitation overlap across actor, request, and system layers.
- [x] 5. Collapse likes system specs to core scenarios.
- [x] 6. Collapse follows system specs to core scenarios.
- [x] 7. Introduce a lighter `project_image` factory path and update specs that do not need attachments.
- [x] 8. Remove request assertions that only restate persistence details.
- [x] 9. Review the CSS spec value and simplify or remove it.
- [ ] 10. Document testing boundaries to prevent future overlap.

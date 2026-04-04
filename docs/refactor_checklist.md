# Refactor Checklist

- [x] 1. Collapse trivial creator project CRUD actors into controller/model flow.
- [x] 2. Remove low-value actor specs made obsolete by the actor-heavy pattern and rebalance coverage.
- [x] 3. Introduce reusable loaders for creator-owned nested resources.
- [x] 4. Standardize authorization predicates for ownership and admin checks.
- [x] 5. Replace string-based failure handling with symbolic or domain-level reasons.
- [ ] 6. Extract invitation lookup and invalid-token handling into shared controller logic.
- [ ] 7. Move presentation helpers like `Project#published_date` out of models.
- [ ] 8. Rename retained read actors to clearer query/loader roles where appropriate.
- [ ] 9. Isolate image metadata extraction from `ProjectImage` persistence concerns.
- [ ] 10. Document architecture rules for models, queries, actors, and spec layers.

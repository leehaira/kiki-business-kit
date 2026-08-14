# docs/plan/ — Project / Epic planning

Canonical **project and Epic-level** planning lives here.

This folder is **not** runtime handoff and **not** a place for append-only Task history.

## Naming

| Pattern | Meaning | Execution source? |
|---------|---------|-------------------|
| `draft-*.md` | Raw human notes / unnormalized requirements | No — Leader must normalize first |
| `EPIC-xxx-<slug>.md` | Canonical Epic plan (long-lived) | Yes — for Epic-sized work; activate **one** Task at a time in runtime |

Example layout:

```text
docs/plan/
├── README.md
├── draft-client-requirements.md
├── draft-payment-notes.md
├── EPIC-001-foundation.md
├── EPIC-002-authentication.md
└── EPIC-003-billing.md
```

## Rules

- Do not treat `draft-*` as the accepted execution contract.
- Do not copy raw drafts wholesale into `docs/runtime/current-task-plan.md`.
- Do not create `docs/runtime/plan-*.md` history files.
- Not every Task needs an Epic. Trivial work needs neither Epic nor runtime plan.
- See `docs/examples/sample-epic-plan.md` and `docs/examples/sample-planning-scenarios.md`.

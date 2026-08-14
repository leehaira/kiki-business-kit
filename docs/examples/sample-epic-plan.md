# EPIC-008 — Collaborator commission system

> Example canonical Epic plan for `docs/plan/EPIC-008-collaborator-commission.md`.
> Epic = large outcome. Plan = HOW artifact, not a hierarchy level between Epic and Task.
> Do not create an Epic for typo/trivial fixes.

## Meta

| Field | Value |
|-------|-------|
| Epic ID | EPIC-008 |
| Status | approved |
| Phase | Phase 2 — Growth |
| Owner | tech-lead |
| Last updated | YYYY-MM-DD |
| Related status | `docs/PROJECT-STATUS.md` |
| Related design | `docs/design/...` (optional) |

Epic status values: `proposed` | `approved` | `active` | `done` | `superseded`

## Goal

Ship collaborator registration approval and commission visibility for admins and collaborators.

## Context

Billing phase already live. Commission rules exist in product brief; no schema yet.

## In scope

- Collaborator registration + admin approval
- Commission calculation for approved collaborators
- Admin list + collaborator history read APIs/UI

## Out of scope

- Payout provider integration
- Multi-currency FX

## User requirements (optional; not Story IDs)

- As an admin, I can approve collaborator registrations.
- As a collaborator, I can view my commission history.

## Architecture / approach

- Extend existing auth roles; add commission tables; keep public API envelope unchanged.

## Dependencies

- EPIC-002 Authentication (done)
- Shared admin layout components

## Risks

- Edge cases on prorated commission periods
- Manual UI tweaks on admin tables after QA

## Tasks

- TASK-081 — Schema + migrations
- TASK-082 — Registration API
- TASK-083 — Approval workflow
- TASK-084 — Commission calculation + history UI

Only **one** of these is active at a time in `docs/runtime/current-task-plan.md`.

## Acceptance / completion criteria

- [ ] Admin can approve/reject registrations
- [ ] Commission history matches calculation rules for fixtures
- [ ] No public API contract break outside accepted scope

## Notes

- Activate tasks sequentially; rewrite runtime plan per Task (do not append).

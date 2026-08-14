# Sample planning scenarios

> How deep to plan. Planning depth must be **proportional to complexity**.

## Hierarchy reminder

```text
Project → Phase → Epic → Task
```

- **Plan** = HOW artifact (`EPIC-*.md` or `current-task-plan.md`), not a work-item level.
- **Story** is not a core level (optional requirements text inside Epic plans only).

---

## A. Trivial fix

```text
Fix typo in README
```

- No Epic
- No `current-task-plan.md` required
- Still follow Git Policy; light review if code changed

---

## B. Standalone Task

```text
TASK-042 — Fix daily sending-limit calculation
```

- Write/rewrite `docs/runtime/current-task-plan.md` for TASK-042 only
- Related Epic optional (leave empty)
- No new `EPIC-*` unless scope grows

---

## C. Feature Epic

```text
EPIC-008 — Collaborator commission system
  TASK-081 Schema
  TASK-082 Registration
  TASK-083 Approval
  TASK-084 Commission calculation
```

- Canonical plan: `docs/plan/EPIC-008-collaborator-commission.md`
- Runtime: exactly one of TASK-081…084 in `current-task-plan.md`
- See [`sample-epic-plan.md`](sample-epic-plan.md)

---

## D. Redesign Epic (with design-system)

```text
EPIC-012 — Admin dashboard redesign
  TASK-121 Audit existing UI
  TASK-122 Update design system (design-system REDESIGN)
  TASK-123 Shared components
  TASK-124 Redesign pages
  TASK-125 Visual QA
```

- Epic plan in `docs/plan/`
- Visual rules → `DESIGN.md` + refs in `docs/design/`
- No separate design-only planning hierarchy

---

## E. New MVP phase

```text
Phase 1 — MVP
  EPIC-001 Foundation
  EPIC-002 Authentication
  EPIC-003 Core product
  EPIC-004 Admin
```

- Update `docs/PROJECT-STATUS.md` (Mode, Current phase, Current epic/task)
- Create one or more `EPIC-*.md` as needed
- Activate the first Task in `current-task-plan.md`

---

## Raw input → Leader normalize

```text
docs/plan/draft-client-requirements.md
        ↓
Leader analyzes
        ↓
Epic-sized? → docs/plan/EPIC-xxx-*.md → Tasks → one active Task in runtime
Task-sized? → current-task-plan.md only
Trivial?    → execute directly
```

Never treat `draft-*` as the execution contract.

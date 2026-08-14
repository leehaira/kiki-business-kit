# Project status

> Sole source of truth for project/phase **Mode**: `ACTIVE` / `DONE` / `MAINTAIN`.
> This is a **project/phase status index**, not a runtime Task handoff, Epic plan, roadmap dump, release notes, or long-term KB.
> Template placeholder: replace mode, phase, epic/task IDs, and dates with real values after apply. Do not treat sample choices as live project state.

## Current status

| Field | Value |
|-------|-------|
| Mode | ACTIVE |
| Current phase | Phase 1 — Deck Kiki Business Kit 1.0 |
| Current epic | |
| Current task | TASK-001 — Deck HTML + PDF |
| Related epic plan | Input: `docs/plan/draft-slides-1.0.md` |
| Related design | Slidewright design-system (không có Figma brand) |
| Phase status | qa |
| Last meaningful update | 2026-08-14 |
| Owner | tech-lead |

## Status definitions

| Mode | Meaning | Agent behavior |
|------|---------|----------------|
| ACTIVE | Đang implement phase/task | Dùng `docs/runtime/current-task-plan.md` cho đúng **một** Task đang chạy; cập nhật review/QA theo workflow |
| DONE | Phase/scope đã hoàn tất | Không tiếp tục implement nếu chưa có scope mới; chỉ review docs/status |
| MAINTAIN | Phase đã đóng, chỉ sửa nhỏ | Giữ thay đổi hẹp; không mở phase/Epic lớn nếu user chưa yêu cầu |

## Work hierarchy (canonical)

```text
Project
└── Phase          (delivery / release grouping)
    └── Epic       (large outcome; optional for small work)
        └── Task   (executable / reviewable unit)
```

- **Plan** is an artifact (HOW), not a hierarchy level: Epic → `docs/plan/EPIC-*.md`; current Task → `docs/runtime/current-task-plan.md`.
- **Story** is not a core work item. Optional user requirements may appear inside an Epic plan.
- Small bugs/maintenance may be a standalone Task with no Epic.

## Phase summary

| Phase | Status | Summary | Notes |
|-------|--------|---------|-------|
| Phase 1 | qa | Deck Kiki Business Kit 1.0 (HTML + PDF) | Artifact: `exports/slides/` |
| Phase 2 | planned |  |  |

## Manual UI / pixel adjustments

> Ghi nhận phần chỉnh tay ngoài agent để agent sau không “sửa ngược” hoặc hiểu nhầm là thiếu implement.

| Area | Manual adjustment | QA status | Notes |
|------|-------------------|-----------|-------|
| Example page/block |  | pending / pass / accepted-risk |  |

## Current handoff

- If ACTIVE and a Task is in progress: see `docs/runtime/current-task-plan.md` (exactly one Task).
- If no active Task: runtime plan may say `No active task.` / skeleton empty.
- If MAINTAIN: only accept small fixes, docs updates, or QA follow-ups unless user explicitly opens a new phase.
- If DONE: do not create new implementation work without a new approved scope.
- Epic planning (long-lived): `docs/plan/EPIC-*.md`. Raw notes: `docs/plan/draft-*.md` (not execution sources).

## Documentation sync checklist

- [ ] `docs/memory/project-memory.md` reflects active context.
- [ ] `docs/memory/decisions.md` has accepted decisions / contract changes.
- [ ] `docs/runtime/current-task-plan.md` matches the **current Task** (or no active task) — not project Mode.
- [ ] QA notes include known manual UI/pixel adjustments.

# Current Task Plan

> Temporary execution contract for **exactly one** active Task.

## Meta

| Field | Value |
|-------|--------|
| Task ID | TASK-001 |
| Task title | Deck Kiki Business Kit 1.0 — HTML + PDF |
| Related epic | |
| Related epic plan | Input: `docs/plan/draft-slides-1.0.md` (raw notes, not execution source) |
| Branch | current |
| Owner role | tech-lead → frontend-dev |
| Status | qa |
| Last updated | 2026-08-14 |

Task Status values: `planned` | `in-progress` | `blocked` | `review` | `qa` | `done`

## Goal

Dựng bài thuyết trình Kiki Business Kit 1.0 từ draft, xuất **một file HTML** (mở trực tiếp trên trình chiếu) và **một file PDF** vào `exports/`.

## Context

- User: `@Luffy` làm slide; xuất hết ở `/exports`; 1 HTML + 1 PDF; nguồn `docs/plan/draft-slides-1.0.md`.
- Track: **plain HTML** (≈16 slide, không cần React).
- Persona: Luffy = tech-lead (scope); Sanji = frontend-dev (dựng deck).

## In scope

- Deck HTML tự chứa (mở file, không build).
- PDF image-based 1920×1080, đủ nội dung từng slide.
- Speaker notes (không chiếu).
- Copy bám draft; sửa chính tả kỹ thuật (`Cloudflare`).

## Out of scope

- React/Vite deck.
- Đổi nội dung thương mại / giá so với draft.
- Logo/ảnh brand (repo chưa có asset).
- Commit/push.

## Acceptance criteria

- [x] `exports/slides/kiki-business-kit-1.0.html` chạy được, có nav dots + số slide, bàn phím.
- [x] `exports/slides/kiki-business-kit-1.0.pdf` đủ số trang = số slide (16).
- [x] Chữ đạt typography floor (body ≥ 40px trên canvas 1080p).
- [x] Không form/input; chỉ presenter click/keyboard.
- [x] Nội dung cover → KikiCMS → domain/hosting/care → KikiMail → Nana Lab → kết.

## Implementation breakdown

| ID | Assignee (role) | Description | Status |
|----|-----------------|-------------|--------|
| 1 | tech-lead | Scope, layout `exports/slides/`, task plan | done |
| 2 | frontend-dev | Scaffold/write HTML deck + notes | done |
| 3 | frontend-dev | Export PDF | done |
| 4 | code-reviewer | Review deck (a11y, overflow, copy) | done |
| 5 | qa-engineer | Spot-check HTML + PDF page count | done |

## Files / areas expected to change

- `exports/slides/kiki-business-kit-1.0.html`
- `exports/slides/kiki-business-kit-1.0.pdf`
- `exports/slides/kiki-business-kit-notes.md`
- `docs/runtime/*`, `docs/PROJECT-STATUS.md`, `docs/memory/*` (sync)

## Risks / constraints

- Related epic / epic plan: draft only
- Related design refs: `.cursor/skills/slidewright/references/design-system.md`
- Visual/design scope:
  - Design mode: CREATE
  - Approved design/reference: `docs/plan/draft-slides-1.0.md` (nội dung, không phải visual)
  - Approval gate before implementation: not required (user đã bảo làm slide)
- Tailwind CDN: không phụ thuộc utility cho layout cốt lõi — CSS trong `<style>`.
- PDF export cần Playwright + network (font/CDN nếu có).
- Slide 05 (3 kiến trúc) và bảng giá denser → siết `max` về floor, không cắt chữ.

## Validation

- Mở HTML, đi hết slide bằng → và dots.
- Export PDF, đối chiếu số trang.
- Zoom ~33%: đọc được body.

## Handoff notes

Tổ chức export:

```text
exports/slides/
  kiki-business-kit-1.0.html    # deck trình chiếu
  kiki-business-kit-1.0.pdf     # handout
  kiki-business-kit-notes.md
```

Palette: nền cát `#f3eee4`, mực `#141a22`, accent hổ phách `#c45c26`. Cover + divider tối.

## Docs sync before done

- [x] `docs/PROJECT-STATUS.md` updated if phase/mode/current epic/task changed.
- [x] `docs/memory/project-memory.md` updated if active context changed.
- [x] `docs/memory/decisions.md` updated if accepted decisions/contracts changed.
- [x] `docs/runtime/reviewer-report.md` and `docs/runtime/qa-checklist.md` reflect final review/QA status when those gates run.
- [ ] Related `docs/plan/EPIC-*.md` updated if Epic status/tasks changed.

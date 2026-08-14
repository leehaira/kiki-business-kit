# Runtime docs — khi nào dùng? (không điền lúc kickoff)

> **`docs/runtime/`** không có file `sample-*` điền sẵn vì **không ghi lúc khởi động dự án**.
> Template repo ship **skeleton** trong `docs/runtime/` (meta + section trống); điền khi bắt **task non-trivial** (định nghĩa trong `AGENTS.md` → Memory Protocol).
> Trạng thái tổng dự án/phase nằm ở `docs/PROJECT-STATUS.md`; runtime chỉ là handoff task/branch.

| File trong `docs/runtime/` | Ai ghi | Khi nào |
|----------------------------|--------|---------|
| `current-task-plan.md` | tech-lead | Task mới: **rewrite** cho đúng một Task (scope, acceptance, breakdown). Không gắn project Mode. |
| `reviewer-report.md` | code-reviewer | Sau review diff |
| `qa-checklist.md` | qa-engineer | Trước kết luận release readiness |
| `release-note-draft.md` | tùy | Nháp note cho user (không thay commit message) |

Project/phase Mode (`ACTIVE` / `DONE` / `MAINTAIN`) chỉ thuộc `docs/PROJECT-STATUS.md`. Epic HOW thuộc `docs/plan/EPIC-*.md`.

**Mô phỏng đầy đủ một lượt task (chat + nội dung từng file):** [`sample-task-workflow.md`](sample-task-workflow.md).
**Độ sâu planning:** [`sample-planning-scenarios.md`](sample-planning-scenarios.md).
**Epic plan mẫu:** [`sample-epic-plan.md`](sample-epic-plan.md).

**Kickoff dự án:** xem [`sample-project-kickoff.md`](sample-project-kickoff.md).

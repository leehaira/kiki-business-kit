# Mẫu khởi động dự án (kickoff)

> **Mục đích:** Liệt kê việc **đầu tiên** sau khi apply Agent Team template — file nào cần điền, file nào để trống đến task đầu tiên.
> Các file `sample-*.md` cùng thư mục là **ví dụ đã điền**; copy nội dung sang đúng chỗ trong `docs/kb/` và `docs/memory/` (đổi tên bỏ `sample-`, chỉnh theo dự án thật).

## Việc làm ngay sau apply template

| Thứ tự | Việc | File đích | Mẫu tham chiếu |
|--------|------|-----------|----------------|
| 1 | Chọn trạng thái tổng ban đầu | `docs/PROJECT-STATUS.md` | Điền mode `ACTIVE` nếu chuẩn bị implement |
| 2 | Mô tả kiến trúc & phạm vi | `docs/kb/architecture.md` | [`sample-architecture.md`](sample-architecture.md) |
| 3 | Bối cảnh stack, contract, rủi ro | `docs/memory/project-memory.md` | [`sample-project-memory.md`](sample-project-memory.md) |
| 4 | Ghi 1–3 quyết định kickoff (nếu có) | `docs/memory/decisions.md` | [`sample-decisions.md`](sample-decisions.md) |
| 5 | Rà `docs/kb/coding-standards.md` (template generic); bổ sung ngoại lệ dự án | `docs/kb/coding-standards.md` + memory | [`sample-coding-standards-notes.md`](sample-coding-standards-notes.md) |
| 6 | Tùy chỉnh deploy / smoke | `docs/kb/runbook-release.md` | [`sample-runbook-release.md`](sample-runbook-release.md) |
| 7 | Chạy task đầu tiên theo pipeline | — | [`sample-task-workflow.md`](sample-task-workflow.md) |

## Không điền lúc kickoff

| Thư mục | Lý do |
|---------|--------|
| `docs/runtime/*` | Chỉ dùng **theo task/branch** (plan, review, QA). Giữ skeleton sau apply; điền khi task **non-trivial** đầu tiên (xem `AGENTS.md`). |

## Checklist kickoff (rút gọn)

- [ ] `architecture.md` — domain, module, data flow, constraints
- [ ] `PROJECT-STATUS.md` — mode ban đầu (`ACTIVE`, `DONE`, hoặc `MAINTAIN`)
- [ ] `project-memory.md` — monorepo paths, stack, API/UI notes
- [ ] `decisions.md` — ít nhất stack/auth/envelope nếu đã chốt
- [ ] `coding-standards.md` — chỉ sửa khi có quy ước **khác template** (hoặc ghi tạm trong memory)
- [ ] `runbook-release.md` — lệnh deploy, smoke 3–5 case
- [ ] Xóa/thu hẹp `standards/*.mdc` không dùng (tùy stack)

## Sau kickoff

Khi bắt Task feature/bugfix: bắt đầu `@agents/tech-lead`, phân loại size; non-trivial thì rewrite `docs/runtime/current-task-plan.md` — xem [`sample-task-workflow.md`](sample-task-workflow.md) và [`sample-planning-scenarios.md`](sample-planning-scenarios.md). Epic-sized → thêm `docs/plan/EPIC-*.md` ([`sample-epic-plan.md`](sample-epic-plan.md)).

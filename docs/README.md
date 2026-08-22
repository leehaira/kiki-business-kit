# Documentation layout

Các loại tài liệu trong template phục vụ mục đích khác nhau. AI agents (IDE agents, CLI agents, hoặc công cụ tương đương) nên đọc đúng loại trước khi làm việc.

## Work hierarchy (canonical)

```text
Project
└── Phase          (delivery / release grouping — not a plan file type)
    └── Epic       (large outcome; optional for small work)
        └── Task   (executable / reviewable unit)
```

| Term | Meaning |
|------|---------|
| Project | Repository / product |
| Phase | Delivery/release grouping (e.g. MVP, Growth) |
| Epic | Large outcome that may contain many Tasks |
| Task | Smallest implementation/reviewable unit agents execute |
| Plan | **Artifact describing HOW** — not a hierarchy level |

- **Epic Plan** → `docs/plan/EPIC-xxx-*.md` (long-lived)
- **Current Task Plan** → `docs/runtime/current-task-plan.md` (exactly one active Task; rewrite on Task change)
- **Story** is not a core work item. Optional user requirements may live inside an Epic plan as plain bullets.
- Planning depth is proportional to complexity: trivial work needs neither Epic nor runtime plan.

## Source of truth

| Concern | Owner |
|---------|--------|
| Project/phase mode (`ACTIVE` / `DONE` / `MAINTAIN`) | `docs/PROJECT-STATUS.md` only |
| Epic planning | `docs/plan/EPIC-xxx-*.md` |
| Raw planning notes | `docs/plan/draft-*.md` (not execution sources) |
| Current Task execution | `docs/runtime/current-task-plan.md` |
| Current review | `docs/runtime/reviewer-report.md` |
| Current QA | `docs/runtime/qa-checklist.md` |
| Accepted architectural/project decisions | `docs/memory/` |
| Technical knowledge | `docs/kb/` |
| Accepted project design rules | root `DESIGN.md` (when used) |
| Design references / drafts | `docs/design/` |

Do not put project Mode on `current-task-plan.md`. Do not keep plan history under `docs/runtime/` (no `plan-1.md`, `auth-plan.md`, etc.).

| Loại | Vị trí | Ổn định | Nội dung điển hình |
|------|--------|---------|-------------------|
| Project status | `docs/PROJECT-STATUS.md` | Cập nhật theo phase | Mode tổng: ACTIVE / DONE / MAINTAIN; current phase/epic/task |
| Knowledge base | `docs/kb/` | Lâu dài | Chuẩn code, kiến trúc, runbook |
| Project memory | `docs/memory/` | Đến khi quyết định đổi | Context dự án, ADR ngắn |
| Project / Epic planning | `docs/plan/` | Trung–dài hạn | `EPIC-*.md` canonical; `draft-*` raw input |
| Guides | `docs/guides/` | Lâu dài | Hướng dẫn start/resume project cho onboarding |
| Examples | `docs/examples/` | Lâu dài | Mẫu kickoff, Epic plan, task workflow, scenarios |
| Runtime | `docs/runtime/` | Tạm (một Task hiện tại) | Current Task Plan, review, QA handoff |
| Skills | `.cursor/skills/*/SKILL.md` | Lâu dài (quy trình) | Workflow **thực thi** lặp lại — không ghi chuẩn kỹ thuật dài ở đây |
| Local automation queue | `.agent/` | Tạm/local | Optional queue/logs; không thay runtime/memory/KB |

Workflow vai trò agent (tech-lead → dev → review → QA): root **`AGENTS.md`**. Checklist trước commit: skill **`pre-propose-commit`** — không nhân bản trong `docs/kb/`.

`.agent/` là hàng đợi/logs cục bộ tùy chọn cho handoff rõ ràng. Nó không phải hệ planning/status mới và không thay `docs/runtime/current-task-plan.md`.

## `docs/plan/` — Project / Epic planning

`docs/plan/` và `docs/design/` là **optional / recommended**.

- `docs/plan/`: canonical **Epic-level** implementation plans (`EPIC-xxx-*.md`) plus optional raw notes (`draft-*.md`).
- `draft-*` = human/AI scratch input — **not** an execution source until Leader normalizes into an Epic plan and/or Current Task Plan.
- `EPIC-*` = long-lived HOW for a large outcome; may span many Tasks/days.
- Activate exactly one Task at a time via `docs/runtime/current-task-plan.md`.
- `docs/design/`: design references, screenshots, Figma export, PDF, visual evidence, hoặc notes đối chiếu giao diện.
- `DESIGN.md`: optional project-level canonical Design System khi được chốt; không thay `AGENTS.md`, memory, runtime, KB, hoặc business requirements.
- Quyết định kiến trúc/product đã chốt lâu dài ghi vào `docs/memory/`, không chỉ để trong `docs/plan/`.
- Không bắt buộc tạo Epic/plan cho backend/API nhỏ hoặc task đơn giản.
- Chi tiết naming: [`plan/README.md`](plan/README.md). Mẫu: [`examples/sample-epic-plan.md`](examples/sample-epic-plan.md), [`examples/sample-planning-scenarios.md`](examples/sample-planning-scenarios.md).

## `docs/PROJECT-STATUS.md` — Project status (tổng quan phase)

- File trạng thái **tổng** để agent biết dự án/phase đang `ACTIVE`, `DONE`, hay `MAINTAIN`.
- **Sole owner** of project/phase Mode.
- Có thể ghi Current phase / Current epic / Current task / Related epic plan.
- Không phải runtime Task handoff, Epic plan body, roadmap dump, release notes, hoặc long-term KB.
- Khác **`docs/memory/`**: status trả lời “hiện đang ở mode nào?”; memory ghi context/quyết định đang hiệu lực.
- Khác **`docs/runtime/`**: status là tổng quan dự án/phase; runtime là đúng **một** Task đang thực thi.

## `docs/kb/` — Knowledge base (dài hạn)

Thư mục chứa tài liệu tham chiếu **ổn định**, đã chốt — viết ngắn, rõ, tra cứu nhanh.

- Cập nhật khi chuẩn hoặc kiến trúc thay đổi có chủ đích.
- **Không** ghi trạng thái task đang chạy hay nội dung nháp theo branch.

**Gợi ý file trong `docs/kb/`:**

| File | Mục đích |
|------|----------|
| `architecture.md` | Kiến trúc tổng quan và ranh giới module |
| `coding-standards.md` | Chuẩn code theo stack; **hợp nhất quy ước markup đã chốt** (BEM, prefix, Bootstrap vs Tailwind theo vùng site, …) — tránh chỉ nằm trong chat |
| `runbook-release.md` | Quy trình release và smoke check |

## `docs/memory/` — Project memory

- Bối cảnh dự án **đang hiệu lực** và quyết định đã **chấp nhận**.
- `project-memory.md`: conventions, contract notes, rủi ro mở, checkpoint.
- `decisions.md`: nhật ký quyết định (date / decision / reason / impact).
- `agent-personas.md`: optional persona names / chat style documentation; không thay role rule trong `.cursor/rules/agents/` và không phải runtime config cho `scripts/agent-run.sh`.
- **Không** thay thế Current Task Plan hay báo cáo review từng lần chạy.

`.agent/aliases.env` là runtime command alias config cho `scripts/agent-run.sh`. Sửa file đó để đổi alias lệnh; sửa `docs/memory/agent-personas.md` khi muốn cập nhật persona names, tone, hoặc mô tả trong tài liệu. Role kỹ thuật trong `.cursor/rules/agents/*.mdc` vẫn là source of truth cho trách nhiệm, guardrails, Git Policy, và Definition of Done.

## `docs/runtime/` — Working-state (tạm thời)

- Fixed current-state artifacts only:

| File | Vai trò thường cập nhật | Mục đích |
|------|-------------------------|----------|
| `current-task-plan.md` | Tech Lead | Execution contract cho **đúng một** Task đang chạy |
| `reviewer-report.md` | Code Reviewer | Kết quả review diff (Critical / Warnings / Suggestions) |
| `qa-checklist.md` | QA Engineer | Test plan và release readiness cho phạm vi đang làm |
| `release-note-draft.md` | Bất kỳ agent (theo yêu cầu) | **Nháp** ghi chú release; không thay commit message hay changelog chính thức |

- `current-task-plan.md` owns **Task Status** (`planned` / `in-progress` / `blocked` / `review` / `qa` / `done`) — **not** project Mode.
- When the active Task changes, **rewrite/reset** the file; do not append the next Task under the previous one.
- After phase close with no active Task: skeleton or `No active task.` — do not fake Mode=`MAINTAIN` on the Task plan.
- Có thể ghi đè, xóa hoặc reset sau khi Task/PR kết thúc; **không** coi là memory/KB lâu dài.

Quyết định đã chốt lâu dài vẫn ghi vào `docs/memory/decisions.md` và `docs/memory/project-memory.md`, không chỉ để trong `docs/runtime/`.

## `.cursor/skills/` — Executable workflows

- **Skill** = hướng dẫn **làm gì, theo thứ tự nào** (team workflow, pre-propose commit, publish template, …).
- Khác **`docs/kb/`**: KB ghi **chuẩn/chính sách**; skill ghi **bước chạy** và mẫu báo cáo.
- Khác **`docs/runtime/`**: runtime là state/handoff **của Task hiện tại**; skill là playbook cố định trong repo.
- Agent có thể `@` chọn skill; không thay thế đọc `docs/kb/coding-standards.md` khi cần chuẩn markup/CSS.
- **`diataxis-writer`**: khi viết hoặc tái cấu trúc tài liệu người đọc — phân loại tutorial / how-to / reference / explanation và đặt đúng `docs/guides/` hoặc `docs/kb/` (xem `.cursor/skills/diataxis-writer/README.vi.md`).

Chi tiết workflow: root **`AGENTS.md`** (mục Documentation layers và Runtime handoff).

## Migration — repo apply template trước bản skeleton runtime

Nếu dự án đã chạy `apply-template.sh` **trước** khi template ship skeleton `docs/runtime/` và `docs/memory/` (ví dụ còn task demo `done`, ADR nội bộ template trong memory):

1. **Backup** `docs/runtime/`, `docs/memory/`, `docs/PROJECT-STATUS.md` nếu có nội dung dự án thật cần giữ.
2. **Re-apply** từ template mới với `--force` *chỉ* khi chấp nhận ghi đè, dùng `--safe` nếu muốn skip file đã tồn tại và chỉ copy phần còn thiếu, **hoặc** thủ công:
   - Reset `docs/runtime/*` về skeleton (meta trống, không Task giả; không gắn project Mode vào Task plan).
   - Rà `docs/memory/project-memory.md` và `docs/memory/decisions.md` — xóa mục chỉ thuộc template demo; giữ quyết định dự án thật.
3. **Kickoff lại** `docs/PROJECT-STATUS.md` (mode và phase thật).
4. Tiếp tục Task hiện tại: tech-lead điền lại `docs/runtime/current-task-plan.md` từ scope đã chấp nhận (một Task).

Không coi runtime cũ là trạng thái phase đang chạy nếu Meta/Status không khớp repo thật.

**Guides & examples:** `apply-template.sh` copy `docs/guides/` và `docs/examples/` vào project đích để có tài liệu onboarding local. `--force` ghi đè theo behavior hiện tại; `--safe` in `SKIP existing: <path>` và không ghi đè file đã có. Bắt đầu project mới → [`guides/start-new-project.md`](guides/start-new-project.md); quay lại project cũ → [`guides/resume-existing-project.md`](guides/resume-existing-project.md). Mẫu kickoff → [`examples/sample-project-kickoff.md`](examples/sample-project-kickoff.md); luồng một task → [`examples/sample-task-workflow.md`](examples/sample-task-workflow.md); Epic plan → [`examples/sample-epic-plan.md`](examples/sample-epic-plan.md); độ sâu planning → [`examples/sample-planning-scenarios.md`](examples/sample-planning-scenarios.md). Bảng đầy đủ: root [`README.md`](../README.md) mục *Tài liệu mẫu trong docs/examples/*.

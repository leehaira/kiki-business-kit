# Start New Project Workflow

## Mục tiêu

Guide này dùng khi:

* bắt đầu một project hoàn toàn mới,
* apply agent-team-template vào repo,
* setup workflow AI orchestration ban đầu.

---

# 1. Tạo project và apply template

```bash
mkdir -p /path/to/project
./apply-template.sh /path/to/project --force

cd /path/to/project
```

Lưu ý:

* apply-template.sh yêu cầu thư mục target phải tồn tại trước.
* Chỉ dùng `--force` trên **repo trống / mới tạo**. Trên repo đang chạy, `--force` ghi đè `.cursor/`, `.agent/`, `docs/memory/`, `docs/runtime/`, `docs/kb/` — backup trước.
* Sau bước này project sẽ có:

  * AGENTS.md
  * .cursor/rules
  * .agent
  * scripts/
  * docs/ (skeleton `kb/`, `memory/`, `runtime/` — chưa có nội dung task thật)

---

# 1b. Kickoff PROJECT-STATUS và memory

Ngay sau apply (trước task đầu tiên):

1. Điền `docs/PROJECT-STATUS.md` — chọn mode thật (`ACTIVE` khi sắp implement, `MAINTAIN` nếu chỉ sửa nhỏ).
2. Điền `docs/memory/project-memory.md` và `docs/memory/decisions.md` theo dự án.
3. Giữ `docs/runtime/*` ở skeleton — chỉ điền khi bắt task **non-trivial** (định nghĩa trong `AGENTS.md`).

Mẫu chi tiết (trong repo template): `docs/examples/sample-project-kickoff.md`.

---

# 2. Chọn crew mặc định hoặc đổi tên agent

Nếu dùng Luffy crew:

* không cần sửa gì.

Nếu muốn đổi crew:

* sửa:

  * .agent/aliases.env
  * docs/memory/agent-personas.md

Ví dụ:

```bash
AGENT_ALIAS_TECH_LEAD="naruto"
AGENT_ALIAS_BACKEND_DEV="sasuke"
```

Technical role vẫn giữ nguyên:

* tech-lead
* backend-dev
* frontend-dev
* code-reviewer
* qa-engineer
* delivery-auditor

Alias chỉ là lớp giao tiếp/tone.

---

# 3. Viết plan ban đầu

Cho mọi:

* brief,
* screenshot,
* requirement,
* brainstorm,
* phân tích AI,
* note khách hàng

vào:

```txt
docs/plan/
```

Quy ước:

```txt
docs/plan/draft-client-brief.md      # raw notes — chưa phải execution source
docs/plan/draft-navbar-ideas.md
docs/plan/EPIC-001-homepage.md       # canonical Epic plan sau khi Leader normalize
```

- `draft-*` = raw planning input / human notes
- `EPIC-*` = canonical Epic HOW (long-lived)
- Task đang chạy = `docs/runtime/current-task-plan.md` (đúng một Task)

Không copy nguyên draft vào runtime rồi coi đó là plan chính thức.

---

# 4. Tạo task đầu tiên

Ví dụ:

```bash
bash scripts/agent-task.sh "Build homepage hero section"
```

Task sẽ xuất hiện trong:

```txt
.agent/active/
```

---

# 5. Gọi Luffy (tech lead)

```bash
bash scripts/agent-run.sh --role luffy --copy
```

Paste prompt vào:

* Cursor
* Codex
* Gemini
* Claude
* Antigravity CLI (nếu dùng)

Luffy sẽ:

* đọc AGENTS.md
* đọc PROJECT-STATUS (Mode ACTIVE/DONE/MAINTAIN)
* đọc active task / `docs/plan` (`draft-*` hoặc `EPIC-*`) nếu cần
* phân loại size (TRIVIAL / TASK / EPIC)
* **rewrite** docs/runtime/current-task-plan.md cho đúng một Task (nếu non-trivial)

---

# 6. Gọi dev implement

Frontend:

```bash
bash scripts/agent-run.sh --role sanji --copy
```

Backend:

```bash
bash scripts/agent-run.sh --role zoro --copy
```

Paste prompt vào AI muốn dùng.

---

# 7. Review

```bash
bash scripts/agent-run.sh --role nami --copy
```

Review sẽ cập nhật:

```txt
docs/runtime/reviewer-report.md
```

---

# 8. QA

```bash
bash scripts/agent-run.sh --role chopper --copy
```

QA sẽ cập nhật:

```txt
docs/runtime/qa-checklist.md
```

---

# 9. Audit/release check nếu task lớn

```bash
bash scripts/agent-run.sh --role robin --copy
```

Robin dùng cho:

* task lớn,
* release,
* refactor,
* audit workflow/docs/runtime.

---

# 10. Commit và đóng task

Khi:

* scope hoàn thành,
* review pass,
* QA pass,
* agent đã chạy checklist **pre-propose-commit** (`.cursor/skills/pre-propose-commit/SKILL.md`).

**Commit/push** chỉ khi bạn gửi đúng cụm trong `AGENTS.md` → Git Policy, ví dụ:

```txt
ok commit và push
commit và push giúp mình
commit and push
```

Sau khi được phép, agent (hoặc bạn) chạy:

```bash
git add .
git commit -m "feat: build homepage hero section"
git push
```

Sau đó move task:

```bash
mv .agent/active/*.md .agent/done/
```

---

# Rule ngắn gọn

```txt
Luffy = chia việc / scope
Zoro = backend
Sanji = frontend
Nami = review
Chopper = QA
Robin = audit
```

Workflow hằng ngày:

```bash
bash scripts/agent-task.sh "Tên task"

bash scripts/agent-run.sh --role luffy --copy

bash scripts/agent-run.sh --role sanji --copy

bash scripts/agent-run.sh --role nami --copy

bash scripts/agent-run.sh --role chopper --copy
```

Hệ thống này là:

* human-controlled orchestration,
* không phải autonomous multi-agent system.

Bạn vẫn là người quyết định:

* AI nào làm gì,
* khi nào review,
* khi nào commit,
* khi nào đóng task.

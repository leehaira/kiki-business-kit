# Resume Existing Project Workflow

## Mục tiêu

Guide này dùng khi:

* quay lại project sau vài ngày,
* tiếp tục task dang dở,
* xử lý review/QA/fix cycle,
* tránh mất context.

---

# 1. Đừng code ngay

Khi quay lại project:

* đừng sửa code ngay,
* đừng chat freestyle ngay.

Trước tiên phải “khôi phục trạng thái”.

---

# 2. Đọc nhanh tình hình

Đọc (theo thứ tự):

```txt
AGENTS.md
docs/PROJECT-STATUS.md
docs/memory/project-memory.md
docs/memory/decisions.md
docs/runtime/current-task-plan.md
docs/runtime/reviewer-report.md
docs/runtime/qa-checklist.md
.agent/active/
```

Mục tiêu:

* biết task nào đang active,
* review tới đâu,
* QA fail chỗ nào,
* còn blocker gì.

---

# 2b. Runtime/memory lệch sau apply template cũ

Nếu `docs/runtime/current-task-plan.md` có **Status: done** hoặc task ID lạ (ví dụ `agent-run-wrapper`) mà dự án thật chưa làm xong — đó thường là artifact template cũ, **không** phải trạng thái hiện tại.

Làm:

1. Backup runtime/memory nếu có nội dung dự án thật.
2. Reset runtime về skeleton hoặc tech-lead viết lại plan cho task đang làm.
3. Đối chiếu `docs/PROJECT-STATUS.md` với thực tế repo (branch, PR, phase).

Chi tiết: `docs/README.md` → *Migration — repo apply template trước bản skeleton runtime*.

---

# 3. Xem task active

```bash
find .agent/active -maxdepth 1 -type f
```

Nếu:

* không có task active,
  → tạo task mới.

Nếu:

* có task active,
  → tiếp tục task đó.

---

# 4. Gọi lại đúng role

Ví dụ task đang dang dở frontend:

```bash
bash scripts/agent-run.sh --role sanji --copy
```

Ví dụ task đang review:

```bash
bash scripts/agent-run.sh --role nami --copy
```

Ví dụ cần scope lại:

```bash
bash scripts/agent-run.sh --role luffy --copy
```

---

# 5. Nếu QA/review phát hiện fix nhỏ

Không cần task mới.

Ví dụ:

* typo,
* spacing,
* warning nhẹ.

→ gọi dev sửa trực tiếp.

Ví dụ:

```bash
bash scripts/agent-run.sh --role sanji --copy
```

Sau đó paste thêm context:

```txt
QA found these issues:
- button spacing inconsistent on mobile
- typo in hero subtitle

Fix only these issues.
Do not expand scope.
```

---

# 6. Nếu scope đổi lớn

Ví dụ:

* thêm feature,
* đổi flow,
* refactor lớn.

→ tạo task fix mới.

Ví dụ:

```bash
bash scripts/agent-task.sh "Fix mobile navigation flow after QA"
```

Rồi quay lại:

* Luffy
* dev
* review
* QA

---

# 7. Đóng task cũ trước khi mở task lớn mới

Đừng để:

* quá nhiều active task,
* runtime không rõ task nào đang sống.

Nguyên tắc:

* 1 task active chính
* hoặc rất ít active task rõ ràng.

---

# 8. Khi nào cần Robin?

Robin thường dùng cho:

* task lớn,
* release,
* refactor,
* audit docs/runtime/workflow.

Task nhỏ thường không cần Robin.

Ví dụ:

* typo,
* spacing,
* responsive nhỏ.

---

# 9. Commit chỉ sau khi approve

QA pass chưa đủ.

Chỉ commit khi:

* bạn đã approve,
* không còn blocker,
* scope đã đúng ý.

---

# 10. Đóng task

Task chỉ được coi là done khi:

* scope hoàn thành,
* review pass,
* QA pass,
* bạn approve,
* commit xong.

Sau đó move task:

```bash
mv .agent/active/*.md .agent/done/
```

---

# Rule ngắn gọn

Task nhỏ:

* fix trực tiếp.

Task đổi scope:

* tạo task mới → gọi Luffy lại.

Role đổi:

* nên mở chat mới.

Project quay lại:

* đọc runtime trước, code sau.

---

# Mindset quan trọng

Hệ thống này không nhằm:

* thay thế PM,
* tự động code mọi thứ,
* autonomous multi-agent.

Mục tiêu thật là:

* giữ workflow rõ ràng,
* giảm mental load,
* giảm context drift,
* giúp nhiều AI behave nhất quán hơn,
* giữ project có trạng thái rõ sau nhiều ngày quay lại.

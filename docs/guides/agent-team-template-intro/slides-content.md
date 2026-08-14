# Agent Team Template — nội dung slide

> File nguồn nội dung cho deck. Sửa ở đây trước, rồi cập nhật `index.html`.
> Thư mục: `docs/guides/agent-team-template-intro/`
> Ngôn ngữ: tiếng Việt sát nghĩa; giữ nguyên thuật ngữ kỹ thuật nếu dịch sẽ sai/lệch (agent, Epic, Task, commit, QA…).

---

## Slide 1 — Title

**Layout:** Title

- Badge: Template · Cursor / Codex / Gemini / Claude
- Headline: Agent Team Template
- Lead: Harness điều phối AI Agent theo vai trò, tích hợp tài liệu, quy trình và quy tắc phối hợp được chuẩn hóa trong một cấu trúc thống nhất.
- Footer: Giới thiệu cấu trúc và cách dùng

---

## Slide 2 — Vấn đề

**Layout:** Bulleted point  
**Heading:** Lập trình với AI dễ rối khi thiếu harness

- Nhiều agent / nhiều chat → phạm vi (scope) bị lệch
- Docs và code không cùng một nguồn chuẩn
- Review / QA bị bỏ qua vì “làm cho xong”
- Kế hoạch dài hạn lẫn với bàn giao tạm thời (handoff)

---

## Slide 3 — Template giải quyết gì

**Layout:** Bulleted point  
**Heading:** Một harness cố định cho mọi repo

- Vai trò rõ: tech-lead → dev → review → QA
- Docs phân tầng: plan / memory / runtime / KB
- Skill dùng lại: `pre-propose-commit`, `close-phase`, `design-system`
- Áp dụng một lần bằng `apply-template.sh`

---

## Slide 4 — Dành cho ai & công cụ nào

**Layout:** Two-column compare  
**Heading:** Ai dùng? và Chạy trên đâu?

**Cột trái — Ai dùng**
- Leader / tech-lead chốt phạm vi
- Dev triển khai theo hợp đồng (contract) đã chốt
- Reviewer + QA giữ cổng chất lượng

**Cột phải — Chạy trên**
- Cursor (rules + `@agents`)
- Codex CLI / Gemini CLI / Claude Code
- Sử dụng AGENTS.md làm nguồn quy trình

---

## Slide 5 — Pipeline mặc định

**Layout:** Bulleted point  
**Heading:** Thứ tự không được đảo

1. tech-lead — chốt Scope (phạm vi), kế hoạch, tiêu chí chấp nhận
2. backend-dev / frontend-dev — triển khai
3. code-reviewer — mục nghiêm trọng (Critical) phải sửa
4. qa-engineer — kiểm tra sẵn sàng release (phát hành)
5. User xác nhận xong → mới commit/push

---

## Slide 6 — Hierarchy công việc

**Layout:** Bulleted point (hoặc diagram text)  
**Heading:** Cấu trúc phân rõ công việc

- **Phase** = nhóm công việc theo giai đoạn / release
- **Epic** = mục tiêu lớn, được chia thành nhiều Task
- **Task** = đơn vị thực thi nhỏ nhất
- Task nhỏ có thể đứng độc lập — không bắt buộc thuộc Epic

---

## Slide 7 — Plan không phải cấp hierarchy

**Layout:** Two-column compare

**Heading:** Plan không phải một cấp hierarchy (phân cấp)

**Cột trái — Cái gì (WHAT)**
- Epic = mục tiêu lớn
- Task = việc đang làm

**Cột phải — Cách làm (HOW / artifact)**
- Epic Plan → `docs/plan/EPIC-*.md`
- Current Task Plan → `docs/runtime/current-task-plan.md`
- Viết lại khi đổi Task — không nối thêm lịch sử

---

## Slide 8 — Phân tầng docs

**Layout:** Bulleted point  
**Heading:** Mỗi thư mục một việc

- `docs/plan/` — kế hoạch Epic chính thức (`EPIC-*`) + ghi chú nháp (`draft-*`)
- `docs/runtime/` — bàn giao tạm thời cho **đúng một** Task đang chạy
- `docs/memory/` — quyết định đã được team chấp nhận (nhớ dự án)
- `docs/kb/` — Knowledge Base: chuẩn / kiến thức kỹ thuật dài hạn
- PROJECT-STATUS.md — trạng thái tổng: ACTIVE (đang làm) / DONE (đã xong) / MAINTAIN (bảo trì)

---

## Slide 9 — Nguồn chuẩn (source of truth)

**Layout:** Bulleted point  
**Heading:** Mỗi thông tin — một nguồn chuẩn duy nhất

- Trạng thái dự án & Phase → `PROJECT-STATUS.md`
- Kế hoạch Epic → `docs/plan/EPIC-*.md`
- Task đang thực hiện → `current-task-plan.md`
- Runtime chỉ giữ trạng thái hiện tại — không lưu lịch sử kế hoạch

---

## Slide 10 — Skills nổi bật

**Layout:** Bulleted point  
**Heading:** Skills bổ sung, không phải agent mới

- `team-workflow` / `close-phase` / `pre-propose-commit`
- `design-system` — CREATE / EXTEND / REDESIGN
- Taste + `frontend-design-qa` + Browser QA
- `api-security` · `slidewright`
- Gắn vào `frontend-dev` / `qa-engineer` — không tạo thêm vai trò mới

---

## Slide 11 — Độ sâu planning

**Layout:** Bulleted point  
**Heading:** Lập kế hoạch theo độ phức tạp

- **Trivial** → làm thẳng, không cần Epic / không cần runtime plan
- **Task** → chỉ `current-task-plan.md`
- **Epic** → `EPIC-*.md` + mở đúng một Task đang chạy
- **Phase mới** → cập nhật `PROJECT-STATUS` rồi mới chia Epic/Task

---

## Slide 12 — Bắt đầu project mới

**Layout:** Bulleted point  
**Heading:** 4 bước sau khi apply

1. Chạy `./apply-template.sh /path/to/project`
2. Điền `PROJECT-STATUS` + memory/KB
3. (Tuỳ chọn) ghi `draft-*` hoặc `EPIC-*` trong `docs/plan/`
4. Tech-lead viết lại `current-task-plan.md` → gọi dev

Hướng dẫn chi tiết: `docs/guides/start-new-project.md`

---

## Slide 13 — Git & Definition of Done

**Layout:** Bulleted point  
**Heading:** Commit chỉ khi được xác nhận

- Chỉ commit/push khi user nói rõ (vd. “ok commit và push”)
- Trước khi đề xuất: skill `pre-propose-commit`
- Chỉ coi là hoàn thành khi: Tech Lead chấp nhận phạm vi + không còn lỗi nghiêm trọng + QA đạt + User xác nhận

---

## Slide 14 — Kết

**Layout:** Title / closing

- Headline: Một Harness — Nhiều Agent — Vận hành như một Team
- Lead: Đọc AGENTS.md → nắm cấu trúc dự án → bắt đầu Phase đầu tiên
- Footer: Repo `agent-team-template` private created by leehaira in GitHub

---

## Ghi chú thiết kế deck

- Track: Plain HTML (mở `index.html` trực tiếp)
- Font tiêu đề: tránh Syne + letter-spacing âm (chữ dính) — dùng Manrope, spacing bình thường
- Palette: nền slate lạnh + accent teal
- ~14 slides; một ý / slide; bullet ngắn
- Speaker notes: `agent-team-template-intro-notes.md`

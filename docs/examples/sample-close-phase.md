# Mẫu đóng phase và audit tiến độ

> Dùng khi một phase đã implement xong, cần xác nhận docs/status không còn ghi “chờ implement”, hoặc khi chuyển dự án sang `MAINTAIN`.

## 1. Delivery audit read-only

Copy prompt này khi muốn audit tiến độ trước khi đóng phase:

```text
Review tiến độ so docs/plan/ — READ ONLY.
Đọc: PROJECT-STATUS.md, docs/plan/EPIC-*.md (và draft-* nếu có), docs/design/**,
docs/memory/*.md, docs/runtime/*.md, git log -30,
git diff <baseline>..HEAD --stat.
Output:
1) phase | epic/plan | đã làm | còn thiếu | file liên quan
2) rủi ro / lệch thiết kế
3) 3–5 việc ưu tiên tiếp theo
Không sửa code, không chạy build.
```

Role gợi ý: `@agents/delivery-auditor`.

## 2. Close phase

Sau khi audit không còn blocker, dùng skill `close-phase`:

```text
@close-phase
Đóng Phase N.
Chuyển PROJECT-STATUS sang DONE hoặc MAINTAIN.
Đồng bộ current-task-plan, memory, decisions, QA checklist.
Ghi nhận chỉnh tay UI/pixel nếu có.
Không commit/push.
```

## 3. File cần đồng bộ

| File | Cần ghi gì |
|------|------------|
| `docs/PROJECT-STATUS.md` | Mode `DONE` hoặc `MAINTAIN` (**sole owner**), phase summary, clear/update current epic/task, manual UI/pixel notes |
| `docs/runtime/current-task-plan.md` | Task Status `done`, rồi skeleton / `No active task.` — **không** gắn Mode=`MAINTAIN` lên Task plan |
| `docs/plan/EPIC-*.md` | Đánh dấu Epic `done` / `superseded` nếu phase dùng Epic |
| `docs/runtime/qa-checklist.md` | Browser verified / not verified, viewport, design reference, trạng thái QA cuối |
| `docs/memory/project-memory.md` | Context đang hiệu lực sau phase |
| `docs/memory/decisions.md` | Quyết định/contract đã chốt trong phase |

## 4. Khi chuyển sang MAINTAIN

- Chỉ nhận bugfix nhỏ, docs sync, QA follow-up, hoặc chỉnh UI/pixel đã được user yêu cầu.
- Không mở feature/refactor lớn nếu user chưa mở phase mới.
- Nếu có chỉnh tay sau QA, refresh `qa-checklist.md` trước khi báo ready.
- Project Mode chỉ đọc từ `PROJECT-STATUS.md`, không suy ra từ Task plan.
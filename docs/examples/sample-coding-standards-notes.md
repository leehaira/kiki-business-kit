# Ghi chú kickoff: coding standards (ví dụ)

> File **`docs/kb/coding-standards.md`** trong template đã là chuẩn **generic** đầy đủ — **không cần copy lại** sang `sample-*`.  
> Lúc khởi động dự án, làm một trong hai cách:

## Cách A — Chỉ khác template một chút

Ghi **ngắn** vào `docs/memory/project-memory.md` (mục Working conventions), ví dụ:

- Không dùng BEM; chỉ Bootstrap utility trên client.
- API: prefix route `/api/v1` (Nest global prefix).
- Commit message: tiếng Việt hoặc tiếng Anh — chọn một.

Khi ổn định sau 1–2 sprint → chuyển sang **Cách B**.

## Cách B — Chốt lâu dài trong KB

Thêm mục vào cuối `docs/kb/coding-standards.md` (hoặc section riêng):

```markdown
## Quy ước project-name (đã chốt YYYY-MM-DD)

- Monorepo: API Nest trong `project-name-api/`; client Nuxt trong `project-name-client/`.
- UI: Bootstrap 5; không Tailwind trên client.
- API errors: `{ statusCode, message }` — không đổi field `message` sang `msg`.
```

Đồng thời ghi entry tương ứng trong `docs/memory/decisions.md` nếu ảnh hưởng contract.

## Không làm lúc kickoff

- Nhân đôi toàn bộ `coding-standards.md` vào file mới.
- Ghi checklist commit/workflow vào KB (đã có trong `AGENTS.md` và skills).

## Tham chiếu

- Chuẩn generic: [`kb/coding-standards.md`](kb/coding-standards.md)
- Mẫu memory: [`sample-project-memory.md`](sample-project-memory.md)

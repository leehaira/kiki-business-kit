# Project memory (ví dụ — copy sang `docs/memory/project-memory.md`)

> Cập nhật khi bối cảnh đổi. Đây là **ngữ cảnh đang hiệu lực**, không thay `docs/kb/coding-standards.md` cho chuẩn dài hạn.

## Monorepo / layout

- Root: `project-name/` (workspace)
- `project-name-api/` — NestJS 11, Jest, ESLint
- `project-name-client/` — Nuxt 3, Bootstrap 5, Pinia
- `project-name-admin/` — Nuxt 3, i18n, Bootstrap 5

## Current decisions (active) — tóm tắt

- API list: envelope `{ data, meta: { page, limit, total } }` (chi tiết → `decisions.md`).
- Auth: header `token` (legacy); không đổi sang Bearer trừ ADR mới.

## Working conventions

- **API contract notes:**
  - Lỗi: `{ statusCode, message, error? }`
  - Date: Unix ms trong JSON
- **UI/UX notes:**
  - Form: dùng `FormInput`, `FormSelect` trong `components/form/`
  - Modal: component `Modal.vue` + Bootstrap JS qua `useNuxtApp().$bootstrap`
- **Testing notes:**
  - API: `npm test` trong `project-name-api`
  - Client: lint bắt buộc; E2E chưa bắt buộc mọi PR

## Open risks

- Token trong header không chuẩn OAuth2 — cân nhắc migration (chưa schedule).
  - Mitigation: document trong ADR trước khi đổi.

## Next checkpoints

- [ ] Điền `architecture.md` khớp module thật
- [ ] Task đầu tiên: chạy pipeline agent + `current-task-plan.md`
- [ ] Sau sprint 1: rút quy ước ổn định vào `coding-standards.md`

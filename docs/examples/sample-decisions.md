# Decisions log (ví dụ — copy sang `docs/memory/decisions.md`)

> Chỉ ghi quyết định **đã chấp nhận**. Kickoff thường có 1–3 entry; thêm dần theo task.

## Template entry

- Date: YYYY-MM-DD
- Decision:
- Reason:
- Impact:
- Owner:

---

## Entries

### 2026-05-01 — Stack monorepo

- **Decision:** Client/admin = Nuxt 3 + Bootstrap; API = NestJS + TypeScript.
- **Reason:** Đội đã có kinh nghiệm; tái sử dụng component form.
- **Impact:** Agent dùng `stack-examples-nuxt-vue.mdc` và `stack-examples-nestjs-typescript.mdc`.
- **Owner:** tech-lead / user

### 2026-05-01 — Pagination envelope

- **Decision:** Mọi list API trả `{ data: T[], meta: { page, limit, total } }`.
- **Reason:** Thống nhất client binding table + `Pagination.vue`.
- **Impact:** Không đổi shape khi thêm filter (chỉ thêm query param).
- **Owner:** tech-lead

### (Ví dụ entry tương lai — xóa khi copy sang dự án mới)

- Date: YYYY-MM-DD
- Decision: …
- Reason: …
- Impact: …
- Owner: …

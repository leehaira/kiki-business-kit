# Architecture (ví dụ — copy sang `docs/kb/architecture.md`)

> Placeholder `project-name` thay bằng tên dự án thật.

## System scope

- **Domain:** SaaS quản lý thiết bị / vận hành cho tenant (ví dụ minh họa).
- **In scope:** Web client (Nuxt), admin portal, REST API (Nest), đồng bộ thiết bị.
- **Out of scope:** Firmware thiết bị; billing phức tạp (phase 2).

## Main modules

| Module | Repo / path | Vai trò |
|--------|-------------|---------|
| Client app | `project-name-client/` | Người dùng tenant: dashboard, nhiệm vụ, bản đồ |
| Admin | `project-name-admin/` | Vận hành nội bộ: tenant, user, cấu hình |
| API | `project-name-api/` | NestJS: auth, business logic, persistence |
| Shared lib | `project-name-common/` (nếu có) | Types, utils dùng chung |

## Data flow (high level)

- **Entry points:** HTTPS → API; SSR/SPA client gọi API qua token header.
- **Processing:** Controller → service → DB (Mongo/Postgres — ghi rõ); queue/event nếu có.
- **Storage/integrations:** Object storage upload; email optional.

## Constraints

- **Security:** Token header; escape output; không log secret.
- **Performance:** List API có pagination; tránh N+1 trên list lớn.
- **Compatibility:** Node LTS + browser evergreen; mobile web responsive (không app native trong scope này).

## References

- Related ADRs: `docs/memory/decisions.md`
- Related standards: `docs/kb/coding-standards.md`, `docs/kb/runbook-release.md`

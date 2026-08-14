# Runbook release (ví dụ — copy sang `docs/kb/runbook-release.md`)

> Điền lệnh và URL thật của dự án; xóa dòng ghi chú `(ví dụ)`.

## Trước merge / tag

- [ ] Scope release đã chốt (tech-lead / user).
- [ ] Review: không còn Critical.
- [ ] `cd project-name-api && npm run lint && npm test` — PASS
- [ ] `cd project-name-client && npm run lint` — PASS (và build nếu PR chạm CI build)
- [ ] Migration DB / env: đã review; biến mới trong `.env.example`
- [ ] `docs/memory/decisions.md` cập nhật nếu breaking change

## Deploy

- [ ] Tag / image: `v1.2.3` + commit SHA `abc1234` (ví dụ)
- [ ] **Staging:** `deploy-staging.sh` hoặc pipeline GitHub Actions `workflow: deploy-staging`
- [ ] **Production:** sau smoke staging; rollback = deploy tag `v1.2.2`
- [ ] Biến môi trường: so khớp checklist DevOps (link nội bộ nếu có)

## Smoke sau deploy (ví dụ 5 case)

- [ ] `GET /health` → 200
- [ ] Login client → dashboard load
- [ ] List mission (hoặc entity chính) → có data, pagination OK
- [ ] Một thao tác ghi (create/update) → thành công
- [ ] Log 15 phút: không spike 5xx

## Sau release

- [ ] Changelog / release note chính thức (không chỉ `docs/runtime/release-note-draft.md`)
- [ ] Reset / archive `docs/runtime/*`
- [ ] Chuẩn mới → `coding-standards.md` hoặc `decisions.md`

## Tham chiếu

- QA từng đợt: `docs/runtime/qa-checklist.md`
- Chuẩn code: `docs/kb/coding-standards.md`

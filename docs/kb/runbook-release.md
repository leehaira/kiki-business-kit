# Runbook release (template)

Checklist ngắn trước/sau release. Điền theo dự án; chi tiết smoke test ghi trong `docs/runtime/qa-checklist.md` cho từng đợt.

## Trước merge / tag

- [ ] Scope release đã chốt (tech-lead / user).
- [ ] Review: không còn Critical; Warnings đã xử lý hoặc chấp nhận có ghi chú.
- [ ] Test: unit/integration theo risk; E2E nếu pipeline có và phạm vi yêu cầu.
- [ ] Migration DB / env: đã review; biến môi trường mới documented.
- [ ] `docs/memory/decisions.md` cập nhật nếu có thay đổi contract hoặc hành vi breaking.

## Deploy

- [ ] Build artifact / image version ghi rõ (tag, commit SHA).
- [ ] Deploy theo quy trình team (staging → production hoặc single env).
- [ ] Rollback plan: tag/commit trước đó, lệnh hoặc link runbook hạ tầng.

## Smoke sau deploy

- [ ] Health / login / luồng chính (liệt kê 3–5 case theo sản phẩm).
- [ ] API critical path (1–2 endpoint hoặc job).
- [ ] Log/monitoring: không spike lỗi 5xx trong cửa sổ quan sát.

## Sau release

- [ ] Cập nhật changelog / release note chính thức (không chỉ `docs/runtime/release-note-draft.md`).
- [ ] Archive hoặc reset `docs/runtime/*` cho task tiếp theo.
- [ ] Rút kinh nghiệm vào `docs/kb/` hoặc `decisions.md` nếu có chuẩn mới.

## Tham chiếu

- QA chi tiết: `docs/runtime/qa-checklist.md`
- Chuẩn code: `docs/kb/coding-standards.md`

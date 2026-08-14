# QA checklist (runtime)

> Working-state cho release readiness của phạm vi task hiện tại.

## Meta

| Field | Value |
|-------|--------|
| Feature / scope | TASK-001 Deck Kiki Business Kit 1.0 HTML + PDF |
| QA role | qa-engineer (Chopper) |
| Target environment | file HTML local + PDF; smoke qua http://127.0.0.1:8765 |
| Last updated | 2026-08-14 |
| Readiness | PASS WITH ISSUES (font CDN) |

## Test plan

| Area | Test type | Steps / command | Expected | Status |
|------|-----------|-----------------|----------|--------|
| HTML load | Smoke | Mở `kiki-business-kit-1.0.html` | Title + slide 1 cover | pass |
| Nav | Keyboard / dots | 16 dots `aria-label="Slide N"`; → / ← | 1–16, prev disabled ở 1, next disabled ở 16 | pass |
| PDF export | Script | `export-deck-pdf.py` → 16 trang | 16/16 captured | pass |
| Overflow | Visual 1920×1080 | PNG slides 4,5,6,9,10,13,14,16 | Không clip chữ | pass |
| Copy | Review | Giá hosting, WP Care, KikiMail PRO 1–6 | Khớp draft | pass |
| A11y chrome | Snapshot | `#nav` buttons + dots | Có nhãn | pass |

## Regression focus

- Deck mới, không đụng app khác.
- Không đảo pixel tay (chưa có).

## Release readiness

- [x] No unresolved Critical from `reviewer-report.md`
- [x] Relevant automated checks pass (or skip documented) — repo không có lint/test cho HTML tĩnh
- [x] Manual smoke completed for agreed scope
- [x] Rollback / feature-flag noted if applicable — N/A (artifact tĩnh)

## Known gaps / accepted risks

- Google Fonts cần mạng khi mở HTML lần đầu.
- PDF có thanh nav (đúng frame trình chiếu, không phải handout in ẩn chrome).
- 16 slide vs 13 mục đánh số trong draft: thêm divider KikiCMS/KikiMail và tách Nana Lab — nội dung không bị cắt.

## Handoff notes

Deliverables:

- `exports/slides/kiki-business-kit-1.0.html`
- `exports/slides/kiki-business-kit-1.0.pdf`
- `exports/slides/kiki-business-kit-notes.md` (không chiếu)

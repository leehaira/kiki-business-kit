# Reviewer report (runtime)

> Working-state sau code review. Không thay `docs/memory/decisions.md` trừ khi đã chốt quyết định lâu dài.

## Meta

| Field | Value |
|-------|--------|
| Reviewed scope (PR / branch / files) | `exports/slides/kiki-business-kit-1.0.html`, notes, PDF; `docs/runtime/current-task-plan.md` |
| Reviewer role | code-reviewer (Nami) |
| Review date | 2026-08-14 |
| Verdict | Approve with warnings |

## Summary

Deck HTML 16 slide, nav dots + counter, bàn phím. Copy bám `docs/plan/draft-slides-1.0.md`. PDF 16 trang 1920×1080. Không form/input. Không critical.

## Critical (must fix before merge)

- [x] Không có

## Warnings (should fix)

- [ ] HTML phụ thuộc Google Fonts (Be Vietnam Pro). Offline/máy chặn CDN → fallback `system-ui`, layout vẫn đọc được nhưng khác font lúc export PDF.
- [ ] File PDF ~5MB (image-based, 16 trang @2x) — bình thường với exporter hiện tại.

## Suggestions (optional)

- [ ] Có thể nhúng font woff2 nếu cần mở HTML hoàn toàn offline.
- [ ] Dot strip trên 16 slide hơi nhỏ trên projector — vẫn click được; không chặn trình chiếu.

## Security / contract / test gaps

- Không có API/secret. SĐT và email trên slide lấy từ draft (thông tin liên hệ công khai).
- Không có test tự động cho deck (đúng với HTML tĩnh).

## Handoff notes (for implementer or QA)

- Đối chiếu PDF vs HTML: cùng 16 slide. Spot-check visual: cover, process, 3 kiến trúc, hosting, WP Care, bảng giá KikiMail, Nana Lab, kết — không clip.
- Chính tả kỹ thuật: `Cloudflare` (draft ghi Cloudfare).

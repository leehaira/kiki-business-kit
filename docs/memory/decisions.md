# Decisions Log

Ghi ngắn gọn theo thời gian để truy vết quyết định kỹ thuật.

> **Skeleton sau apply template:** xóa mục mẫu dưới khi ghi quyết định thật. Tham chiếu: `docs/examples/sample-decisions.md`.

## Template entry

- Date: YYYY-MM-DD
- Decision:
- Reason:
- Impact:
- Owner:

---

## Entries

- Date: 2026-08-14
- Decision: Artifact slide = `exports/slides/kiki-business-kit.{html,pdf}`; 16 slide (thêm divider CMS/Mail + tách Nana Lab so với 13 mục đánh số trong draft). Sửa `Cloudfare` → `Cloudflare`.
- Reason: Trình chiếu cần nhịp phần; draft là raw notes.
- Impact: Khi giá/copy đổi, sửa HTML rồi export lại PDF.
- Owner: tech-lead

- Date: 2026-08-14
- Decision: File xuất đặt tên `kiki-business-kit-<phiên-bản>.html` và `.pdf` (bản hiện tại `1.0`). Bản mới không ghi đè bản cũ.
- Reason: Cần giữ lịch sử xuất khi ra bản sau.
- Impact: README trỏ bản hiện hành; notes không gắn version.
- Owner: tech-lead

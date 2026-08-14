# Coding standards (template)

## Vai trò tài liệu trong repo

| Loại | Vị trí | Mục đích |
|------|--------|----------|
| **Knowledge base** | `docs/kb/*` | Chuẩn và kiến thức **ổn định**, dùng tra cứu lâu dài. Cập nhật khi team **chốt** thay đổi chuẩn. |
| **Skills** | `.cursor/skills/*/SKILL.md` | **Quy trình thực thi** lặp lại (workflow, checklist trước commit, publish, …). Không ghi chuẩn kỹ thuật dài hạn ở đây. |
| **Runtime** | `docs/runtime/*` | Trạng thái làm việc **tạm** theo task/branch (plan, review, QA). Có thể xóa/reset sau khi xong. |
| **Memory** | `docs/memory/*` | Bối cảnh và quyết định **đã chấp nhận** của dự án cụ thể (không thay KB). |

File này là **chuẩn kỹ thuật generic** cho template. Dự án triển khai nên **bổ sung** quy ước riêng vào đây (hoặc ghi nhắn trong `docs/memory/project-memory.md`) sau khi đã thống nhất — ví dụ: prefix BEM, vùng site dùng Bootstrap vs Tailwind.

**Liên quan Cursor:** rule `.cursor/rules/standards/*.mdc` hỗ trợ agent trong IDE (globs, ví dụ markup). KB là nguồn **chốt** cho người và agent; khi hai nơi khác nhau, ưu tiên **KB + memory** đã ghi nhận quyết định dự án.

---

## Naming conventions

### Chung

- Tên phản ánh **vai trò** (what) hơn cách triển khai (how).
- Một quy ước casing cho mỗi ngôn ngữ; không trộn `snake_case` / `camelCase` trong cùng lớp file trừ khi framework bắt buộc.
- Tránh viết tắt không chuẩn; chấp nhận từ viết tắt đã có trong domain (ví dụ `id`, `url`, `api`).

### Gợi ý theo loại file (điều chỉnh theo stack)

| Loại | Gợi ý | Ví dụ (minh họa) |
|------|--------|------------------|
| Component / class | PascalCase hoặc theo framework | `UserCard`, `user-card.vue` |
| Hàm / biến | camelCase (JS/TS/PHP method) hoặc snake_case (Python, PHP function) | `getUserById`, `get_user_by_id` |
| Hằng số | UPPER_SNAKE | `MAX_RETRY_COUNT` |
| File module | kebab-case hoặc theo convention repo | `media-content.scss` |
| Test | đuôi/mô tả rõ đối tượng | `user-card.spec.ts` |

### CSS / markup

- Block BEM: prefix thống nhất (ví dụ `c-` cho component, `l-` cho layout) — **ghi rõ trong dự án** nếu khác template.
- Modifier: `--` (ví dụ `c-card--featured`).
- Element: `__` (ví dụ `c-card__title`).
- Không đặt tên class theo màu/kích thước cố định trừ design token có chủ đích (`is-active`, `has-error` là state, không phải màu).

### WordPress (theme)

- Template page: `template-pages/page-{slug}.php` hoặc convention team.
- Partial: `template-parts/{area}/{name}.php`.
- Text domain: một domain cố định cho theme (ví dụ `my-theme`).

---

## CSS strategy

1. **Một nguồn sự thật cho layout/component:** BEM + SCSS cho phần “của dự án”; utility framework cho layout/spacing khi đã chọn stack.
2. **Không sửa vendor:** Bootstrap/Tailwind build — override trong layer dự án.
3. **Độ đặc hiệu có kiểm soát:** Tránh chuỗi selector sâu; ưu tiên class BEM và token.
4. **Token trước magic number:** màu, spacing, typography qua biến SCSS hoặc theme config.
5. **Phạm vi file:** Một block/component chính → một partial SCSS (hoặc module CSS) tương ứng; tránh file “kitchen sink”.

Khi dự án có cả Bootstrap và Tailwind, ghi trong KB hoặc memory **ranh giới theo module/trang** (ví dụ: admin = Bootstrap, marketing = Tailwind).

---

## Design reference and optional Taste capability

- Priority: user requirement → approved design/Figma/screenshot → project memory →
  existing design system/components/tokens → this KB → frontend rules → Taste defaults
  → Hallmark-derived heuristics.
- Approved design is a fidelity target, not permission to redesign. Use
  `image-to-code`; reserve `design-taste-frontend` for greenfield direction or explicit
  visual refinement.
- Reuse existing SCSS variables, tokens, mixins, breakpoints, components, and installed
  CSS framework. Do not add Tailwind, Bootstrap, Motion/GSAP, icon packages, UI
  frameworks, or component libraries solely because a skill recommends them.
- `docs/design/` stores approved references and design handoff; `docs/runtime/` stores
  task scope/status/review/QA. Do not duplicate their responsibilities.
- Optional root `DESIGN.md` is the canonical long-term Design System when accepted.
  Drafts and screenshots stay in `docs/design/`; do not put the system into runtime.
- For project-level CREATE / EXTEND / REDESIGN of the Design System, use
  `.cursor/skills/design-system/SKILL.md` before Taste. Map semantic rules into existing
  tokens/components/CSS stack; do not invent a parallel system.
- For template-first work, approve HTML/Pug/Vue + CSS/SCSS before WordPress/Nuxt
  integration unless the accepted scope explicitly combines those steps.
- Use `frontend-design-qa` for design preflight, inspiration study, read-only audit, and
  post-build anti-slop checks. Its aesthetic findings are advisory unless backed by
  fidelity, accessibility, responsive, regression, or accepted project requirements.

Execution details and routing live in `.cursor/skills/design-system/SKILL.md`,
`.cursor/skills/taste-integration/SKILL.md`, and
`.cursor/skills/frontend-design-qa/SKILL.md`; do not duplicate their workflows here.
Taste runtime defaults to local digests; full vendored upstream Taste files are archives
and are not part of the normal load path.

## Optional runtime browser QA

- Local Chrome/Chromium via `browser-qa` + `browser-use` CLI/CDP is the default for
  real-browser localhost evidence. MCP, cloud, tunnels, and API keys are optional.
- Install Browser Use only with explicit authorization; missing tooling ⇒ `not verified`
  / `BLOCKED`, never pretend tested.
- Browser artifacts stay outside the repo (or an ignored path); never in `docs/runtime`.
- Functional/runtime ownership: `browser-qa` / `qa-engineer`. Visual/design fidelity:
  `frontend-design-qa`. Severity labels: Critical / Major / Minor / Advisory.

---

## BEM conventions

- **Block:** thự thể UI độc lập (`c-media-content`).
- **Element:** phần chỉ có ý nghĩa trong block (`c-media-content__title`).
- **Modifier:** biến thể block/element (`c-section--large-top`, `c-button--primary`).
- Không lồng selector kiểu `.block .block__el` nếu có thể gán class trực tiếp trên node.
- Không dùng element của element (`block__a__b`); tách block mới hoặc flatten tên element.
- HTML semantic giữ vai trò (`section`, `nav`, `button`); BEM chỉ trên `class`.

---

## Bootstrap / Tailwind utility strategy

### Nguyên tắc

- **Detect stack** từ manifest/config trước khi gợi ý class (xem rule `css-framework-adaptive` trong IDE).
- **Một utility family trên một cây markup** (không trộn Bootstrap + Tailwind trên cùng node trừ khi repo đã có tiền lệ).
- **BEM đặt tên component; utility lo layout/spacing/responsive** (`row`, `col-*`, `mb-3`, `flex`, `gap-*`, …).
- Utility trên wrapper; BEM trên phần tử mang ý nghĩa component.

### Bootstrap

- Dùng grid/spacing của **phiên bản** đã cài; không copy class từ tài liệu phiên bản khác.
- Container/row/col theo pattern trang hiện có.

### Tailwind

- Theo `tailwind.config` (prefix, content paths, breakpoints).
- Template Pug/Vue/HTML phải nằm trong `content` để tránh purge nhầm.
- `@apply` chỉ khi dự án đã dùng pattern đó; ưu tiên class trong markup khi team chọn utility-first.

### Plain CSS/SCSS

- Không gợi ý utility framework khi repo không có dependency tương ứng.

---

## SCSS structure

Gợi ý thư mục (điều chỉnh theo build tool):

```text
styles/
  abstracts/     # variables, mixins, functions (không output CSS thuần)
  base/          # reset, typography, element defaults
  components/    # một file per block BEM chính
  layout/        # header, footer, grid shell
  utilities/     # helper class hẹp (nếu cần)
  main.scss      # @use / @import có thứ tự
```

- Dùng `@use` / namespace thay vì global `@import` khi toolchain hỗ trợ.
- Biến: `$color-primary`, `$space-md` — tên mô tả vai trò, không ` $blue`.
- Mixin chỉ cho lặp **≥ 3** lần hoặc logic phức tạp; tránh mixin một dòng.
- Không nest quá 3 cấp; flatten bằng BEM class.

---

## Responsive principles

- **Mobile-first:** base style cho viewport nhỏ; `min-width` media query cho breakpoint lớn hơn.
- Breakpoint **theo design system** (không invent số lẻ trừ khi đã ghi trong token).
- Hình ảnh: `srcset` / sizes khi cần; không scale bằng width cố định trong CSS một cách cứng nhắc.
- Touch target tối thiểu ~44×44px cho control chính (hướng dẫn, không thay thế test thiết bị).
- Ẩn/hiện nội dung: ưu tiên layout/CSS; tránh duplicate nội dung chỉ để “ẩn trên mobile” nếu ảnh hưởng a11y/SEO.

---

## Accessibility baseline

- DOM **semantic** (`button` cho action, `a` + `href` cho navigation, heading hierarchy `h1`→`h6` không nhảy cấp).
- Mọi input có **label** liên kết (`for`/`id` hoặc `aria-labelledby`).
- Ảnh mang thông tin: `alt` mô tả; decorative: `alt=""`.
- Focus visible; không `outline: none` không thay thế.
- Tương tác bàn phím: menu, modal, tab trap đúng pattern (focus trap, Esc đóng khi áp dụng).
- Màu không là tín hiệu duy nhất; tỷ lệ tương phản theo WCAG mục tiêu team (thường AA cho text).
- Sau Pug/JSX compile: kiểm tra **HTML render** (class/role/aria còn đúng).

Chi tiết ví dụ markup: rule `frontend-bem-a11y-planning` và stack examples trong `.cursor/rules/standards/`.

---

## WordPress theme conventions

- **Escape output** theo ngữ cảnh: `esc_html`, `esc_attr`, `esc_url`, `wp_kses_post`.
- **Sanitize input** trước lưu/xử lý: `sanitize_text_field`, `absint`, …
- Truy vấn: WordPress API (`WP_Query`, …); SQL thô qua `$wpdb->prepare` khi bắt buộc.
- Asset: `wp_enqueue_style` / `wp_enqueue_script`; không hardcode `<link>`/`<script>` trong template.
- Logic: `functions.php` + hooks nhỏ; view mỏng trong template.
- Cấu trúc gợi ý: `template-parts/`, `template-pages/`, `widgets/` (một widget ≈ một block landing).
- i18n: `__`, `_e`, `esc_html__` với text domain nhất quán.
- Markup/CSS: tuân BEM + utility strategy ở trên; PHP security theo rule `wordpress-theme-php`.

---

## Component architecture

### Frontend (SPA / SSR / static)

- **Một trách nhiệm** mỗi component; props/events typed khi dùng TypeScript.
- Container (data) vs presentational (UI) khi độ phức tạp tăng — không bắt buộc cho mọi leaf component.
- State: local trước; lift state khi cần chia sẻ; global store chỉ cho cross-cutting đã justify.
- Không duplicate business rule ở nhiều layer (validate một nơi “source of truth”).
- Test: unit cho logic; integration/E2E cho luồng quan trọng — mức độ theo risk (ghi trong QA plan runtime).

### Static / Pug / HTML partial

- Section = block BEM; partial tái sử dụng qua include/mixin với tham số rõ ràng.
- Không nhúng logic nghiệp vụ trong template; data từ layer compile hoặc CMS.

### API boundary (full-stack)

- Contract JSON ổn định; thay đổi contract cần approval và ghi `docs/memory/decisions.md`.

---

## Git and commit expectations

Đây là **kỳ vọng chuẩn**, không phải checklist lệnh (checklist thực thi nằm ở skill `pre-propose-commit`).

- **Một commit = một ý định** (feature slice, fix, docs) — tránh “WIP dump” trên main.
- Message: imperative, ngắn subject (~50 ký tự); body giải thích **why** khi cần.
- Không commit secret (`.env`, key, credential).
- Agent **không** `git commit` / `git push` trừ khi user phê duyệt rõ (xem `AGENTS.md` Git Policy).
- Trước khi đề xuất commit: tóm tắt phạm vi + lint/test đã chạy (skill, không lặp bước ở đây).
- PR ưu tiên cho thay đổi không trivial; review bắt buộc theo workflow team.

Convention nhánh (ví dụ minh họa, team tự chọn): `feature/…`, `fix/…`, `docs/…`.

---

## AI agent editing guardrails

- **Đọc trước khi sửa:** `docs/memory/*`, `docs/kb/*`, runtime handoff nếu task đang mở.
- **Thay đổi phẫu thuật:** chỉ file/ dòng phục vụ yêu cầu; không refactor lan man.
- **Không đổi API contract** im lặng; escalate tech-lead, ghi memory.
- **Không trùng lặp workflow** trong KB (commit checklist, role rotation → `AGENTS.md` + skills).
- **Chuẩn markup/CSS:** detect stack; không trộn utility families; BEM cho component CSS.
- **Dọn dẹp:** xóa import/biến do **chính thay đổi của agent** gây thừa; không xóa dead code cũ trừ khi được yêu cầu.
- **Uncertainty:** hỏi user hoặc ghi giả định trong runtime plan — không đoán convention dự án.
- Sau quyết định lâu dài: cập nhật `docs/memory/decisions.md` và/hoặc bổ sung mục trong file KB này.

Hành vi tối thiểu khi codegen: xem rule `karpathy-guidelines` (think before coding, simplicity, goal-driven verification).

---

## Cập nhật chuẩn dự án

### Ghi ở đâu (tránh nhầm tầng)

| Nội dung | Nơi ghi | Ví dụ |
|----------|---------|--------|
| Chuẩn kỹ thuật **đã chốt**, áp dụng lâu dài | **`docs/kb/coding-standards.md`** (mục tương ứng) | “Landing chỉ Tailwind, admin chỉ Bootstrap” |
| Quyết định có **lý do + impact** | `docs/memory/decisions.md` | ADR: đổi format API lỗi |
| Ghi nhớ **ngắn**, đang thử / chưa chốt | `docs/memory/project-memory.md` | “Đang thử prefix `u-` cho utility wrapper” |
| Handoff task hiện tại | `docs/runtime/*` | Plan/review/QA — **không** làm chuẩn chính thức |
| Snippet IDE theo loại file | `.cursor/rules/standards/*.mdc` | Ví dụ Pug+BEM (tùy chọn, mirror KB) |

**Có thêm chuẩn mới?** → thêm **mục hoặc đoạn** trong file này (hoặc file KB riêng nếu quá lớn, ví dụ `docs/kb/api-conventions.md` và link từ đây). Không nhét workflow (commit checklist, thứ tự role) vào KB.

### Khi nào nên đưa vào `coding-standards.md`

Cập nhật KB khi **ít nhất một** dấu hiệu sau đúng:

- Cùng một quy ước được **nhắc lại ≥ 2 lần** trong review hoặc chat (prefix class, cấu trúc thư mục, format lỗi API, …).
- Dev/agent **không chắc** và chọn khác nhau trên cùng loại file → cần một quyết định binding.
- Onboarding: người mới hỏi “team mình làm thế nào?” và câu trả lời **không** nằm trong template generic ở trên.
- Ngoại lệ so với template (không BEM, chỉ utility, text domain WP khác, …) đã **được user/tech-lead chốt**.
- Chuẩn ảnh hưởng **nhiều module** hoặc **nhiều PR** sắp tới (tránh drift im lặng).

**Chưa cần KB** (giữ `project-memory` hoặc runtime): thử nghiệm một PR, spike, hoặc quy ước chỉ một module/feature tạm thời.

### Gợi ý trong lúc làm dự án (nhận biết sớm)

Trong task bình thường, **ghi nháp ngay** khi thấy:

| Tình huống | Hành động gợi ý |
|------------|------------------|
| Reviewer/agent sửa cùng kiểu lỗi convention (tên file, escape WP, class utility) | Ghi 1 dòng vào `project-memory.md` → tech-lead chốt → đưa vào mục KB tương ứng |
| User nói “từ giờ team làm X” | `decisions.md` + cập nhật KB trong cùng PR hoặc PR docs ngay sau |
| Phát hiện repo **khác** template (stack, không có BEM) | Kickoff: 3–5 bullet trong `project-memory`; sau 1 sprint chốt → `coding-standards.md` |
| Chỉ cần agent **tự nhớ khi mở `.php` / `.pug`** | Cân nhắc thêm/sửa `standards/*.mdc` **sau khi** KB đã có policy (KB là nguồn chốt) |
| Chuẩn chỉ cho **một ticket** | `docs/runtime/current-task-plan.md` — không đưa KB |

**Tech-lead / review nhẹ:** cuối task hoặc PR, hỏi một câu — *“Có quy ước mới cần đưa vào `coding-standards.md` không?”* Nếu có → mở issue hoặc commit docs nhỏ (tránh chỉ nằm trong chat).

### Quy trình cập nhật (ngắn)

1. Thống nhất (review / tech-lead / user).
2. Ghi `docs/memory/decisions.md` nếu là quyết định kiến trúc/contract.
3. Sửa mục tương ứng trong **`coding-standards.md`** (hoặc file KB mới + link).
4. Rút gọn hoặc xóa bản nháp trùng trong `project-memory.md`.
5. Tùy chọn: đồng bộ ví dụ trong `.cursor/rules/standards/` nếu team dùng Cursor rules làm mirror.

### Phạm vi nên mở rộng trong file này

Khi dự án trưởng thành, thêm mục (generic, có ví dụ minh họa) cho các chủ đề team thực sự dùng, ví dụ:

- API / JSON (envelope lỗi, versioning, pagination)
- Database (migration, naming bảng/cột)
- Logging & observability (format log, không log secret)
- Security baseline (ngoài WordPress: auth, CORS, headers)
- Testing (mức bắt buộc theo loại thay đổi)
- i18n / locale (nếu đa ngôn ngữ)

Giữ mỗi mục **ngắn + quy tắc có thể kiểm tra**; chi tiết dài đưa sang `docs/kb/runbook-*.md` hoặc tool riêng.

## Tham chiếu (template)

| Chủ đề | IDE rule (ví dụ) |
|--------|------------------|
| BEM + a11y | `frontend-bem-a11y-planning.mdc` |
| Bootstrap / Tailwind detect | `css-framework-adaptive.mdc` |
| Markup examples | `stack-examples-bem-html-pug-bootstrap-tailwind.mdc` |
| WordPress PHP | `wordpress-theme-php.mdc` |
| TypeScript / perf | `typescript-and-performance.mdc` |
| NestJS API | `stack-examples-nestjs-typescript.mdc` |
| Nuxt 3 + Vue | `stack-examples-nuxt-vue.mdc` |
| Release checklist | `docs/kb/runbook-release.md` |

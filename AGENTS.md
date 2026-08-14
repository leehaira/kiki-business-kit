# Agent Workflow

This repository uses a role-based Agent workflow.

## Operating Mode

- Enterprise mode: prioritize safety, auditability, and predictable delivery.
- Use concise communication, but always include risks and validation status.
- Do not skip required review or QA gates for speed.

## Team Communication Style

- Respond in Vietnamese.
- Default to concise answers; expand only when the user asks for more detail.
- Lead with the conclusion, then supporting detail.
- Avoid motivational filler and empty phrasing.

## Decision Style

- When trade-offs matter, offer at most two viable options with a clear recommendation.
- When there is no meaningful trade-off, state one clear recommendation.

## Default Execution Order

1. `@agents/tech-lead` for architecture, scope, and task breakdown.
2. `@agents/backend-dev` and/or `@agents/frontend-dev` for implementation.
3. `@agents/code-reviewer` for mandatory review after code changes.
4. Apply required fixes from review.
5. `@agents/qa-engineer` for test planning and release readiness checks.

- **Cursor:** attach the matching `@agents/...` rule from the picker (see **Invoking roles (Cursor / headless CLIs)**).
- **Codex CLI (and other CLIs without `@` rules):** follow the same sequence by reading the matching persona under `.cursor/rules/agents/*.mdc` (see **Role Emulation**).

## Conflict resolution

- When `@agents/backend-dev` and `@agents/frontend-dev` disagree on a **shared contract** (e.g. JSON response shape, error payload, field naming, pagination envelope), **pause divergent coding** and escalate to **`@agents/tech-lead`** for one binding decision that fits scope and API stability.
- The tech-lead outcome stands until the **user** overrides; both sides then implement to match.
- Record the outcome in **`docs/memory/decisions.md`** (date / decision / reason / impact). Update **`docs/memory/project-memory.md`** if active context or the agreed contract changes.
- Pairs with **Guardrails**: no silent API contract drift—disputes are arbitrated here, then written down.

## Invoking roles (Cursor / headless CLIs)

### Cursor

- Attach a persona by typing `@` in chat and choosing the rule (e.g. `agents/tech-lead` or the file name shown in the picker). Paths live under `.cursor/rules/agents/*.mdc`.
- Phrases like “Automatically invoke” inside a rule `description` are guidance only; Cursor does not auto-rotate agents—you follow the order above unless you explicitly skip a step.
- Technical standards load from `.cursor/rules/standards/*.mdc` via `alwaysApply` or `globs`; see each file’s frontmatter.

### Codex CLI

- Treat this file as the workflow router; concrete steps, stack examples, and prompts are in **Codex CLI Usage** and **Role Emulation** below.
- Codex does not apply Cursor `globs` automatically—open the `.mdc` / `SKILL.md` files the task needs (do not assume rules were pre-loaded).

## Agent Persona & AI Assignment

Technical role rules in **`.cursor/rules/agents/*.mdc`** remain the source of truth.

- `docs/memory/agent-personas.md` (or a project `agent-personas.md`) is optional memory for friendly aliases and default AI assignment only.
- When available, agents should read the project persona/AI assignment file before starting role-based work.
- Prompts like “Act as `@agents/backend-dev`”, “Act as Zoro backend mode”, or “Use Nami reviewer mode” should resolve to the matching technical role when an alias is defined.
- If the alias exists, map it back to the technical role under `.cursor/rules/agents/*.mdc`, then apply that role.
- If the alias is unknown, ask the user to clarify or use the clearest technical role in the prompt.
- Persona alias affects **tone only**. It must not override responsibilities, standards, Git Policy, Guardrails, review/QA gates, or Definition of Done.
- Tool/interface and model/provider are separate layers. Agents may switch tool/model for token limits, quota errors, long context, or better tooling, but switching tool/model must not change the technical role.

## Documentation layers

| Layer | Path | Purpose |
|-------|------|---------|
| Project status | `docs/PROJECT-STATUS.md` | Sole owner of project/phase mode: ACTIVE, DONE, or MAINTAIN; current phase/epic/task pointers |
| Project / Epic planning | `docs/plan/` | Canonical `EPIC-*.md` plans; optional `draft-*` raw notes (not execution sources) |
| Knowledge base | `docs/kb/` | Stable long-term reference |
| Project memory | `docs/memory/` | Accepted context and decisions |
| Runtime working-state | `docs/runtime/` | Temporary handoff for **exactly one** current Task |

Canonical work hierarchy: **Project → Phase → Epic → Task**. **Plan** is a HOW artifact (Epic Plan / Current Task Plan), not a hierarchy level. **Story** is not a core work item.

See **`docs/README.md`** for the full distinction. Runtime files are **not** long-term memory, KB, or plan history.

## Memory Protocol

- Before non-trivial work, read when they exist:
  - `docs/PROJECT-STATUS.md`
  - `docs/memory/project-memory.md`
  - `docs/memory/decisions.md`
  - `docs/runtime/current-task-plan.md`
- If these files are empty, missing, or not relevant, continue normally (do not block).
- After **accepted** long-term decisions, update memory succinctly:
  - `docs/memory/project-memory.md`: active project context.
  - `docs/memory/decisions.md`: date / decision / reason / impact log.
- Use `docs/kb/*` as stable references; do not put task handoff or draft review/QA state into KB or memory.

### Non-trivial vs trivial task

Use this to decide whether `docs/runtime/current-task-plan.md` and full Memory Protocol are required before implementation:

| Treat as **non-trivial** (plan + read PROJECT-STATUS, memory, decisions) | Treat as **trivial** (may skip `current-task-plan`; still follow Git Policy and review when code changes) |
|--------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| Feature mới, refactor có rủi ro, nhiều file hoặc cross-layer (API + UI) | Typo, comment, one-liner với scope user nêu rõ |
| Thay đổi API contract, schema, auth, hoặc hành vi user-facing | Docs-only một file, không đổi contract |
| Cần review/QA gate formal cho release | User nói rõ task trivial / hotfix tối thiểu |

When unsure, default to **non-trivial** and let tech-lead confirm scope in `current-task-plan.md`.

## Runtime handoff

`docs/runtime/` holds **working-state** for multi-agent handoff (any IDE agent, CLI agent, or equivalent). Use fixed current-state files only — never `docs/runtime/plan-*.md` history. Reset or archive after the Task/PR ends; promote durable outcomes to `docs/memory/`.

`docs/runtime/current-task-plan.md` is the temporary execution contract for **exactly one** active Task. Rewrite/reset it when the active Task changes; do not append the next Task under the previous one.

- It owns **Task Status** (e.g. `planned` / `in-progress` / `blocked` / `review` / `qa` / `done`).
- It does **not** own project/phase Mode. `ACTIVE` / `DONE` / `MAINTAIN` live only in `docs/PROJECT-STATUS.md`.
- Related Epic / Epic plan fields are optional (standalone Tasks allowed).
- When no Task is active, leave skeleton empty or write `No active task.`

| File | Typical owner | When |
|------|---------------|------|
| `current-task-plan.md` | Tech Lead | Create or rewrite for each **non-trivial** Task |
| `reviewer-report.md` | Code Reviewer | After reviewing code changes |
| `qa-checklist.md` | QA Engineer | Before declaring release readiness |
| `release-note-draft.md` | Any agent (as needed) | Optional user-facing release **draft** only — does not replace the official commit message or changelog |

Rules:

- Runtime content must not substitute for `docs/memory/decisions.md` or `docs/memory/project-memory.md` when a decision is **final**.
- Do not treat runtime files as the canonical project history or Epic plan store (`docs/plan/EPIC-*.md` owns Epic HOW).

## Phase closure and MAINTAIN mode

Use **`.cursor/skills/close-phase/SKILL.md`** when a user asks to close a phase, mark work done, switch to maintenance, or finalize a completed implementation phase.

`@agents/delivery-auditor` is optional and read-only; it is not part of the default delivery gate. Use it to audit progress before closing a phase or when docs/status may be out of sync.

Closing a phase requires:

- `docs/PROJECT-STATUS.md` reflects the final phase status and mode (`DONE` or `MAINTAIN`) — **sole owner** of project Mode.
- `docs/runtime/current-task-plan.md` marks the last Task `done` (or `No active task.` / skeleton) — never set project Mode on the Task plan.
- `docs/runtime/qa-checklist.md` records final QA status and any accepted risks.
- Manual UI/pixel adjustments made outside agents are recorded in `PROJECT-STATUS.md` and/or QA notes so future agents do not reverse them.
- `docs/memory/project-memory.md` and `docs/memory/decisions.md` are updated when active context, accepted decisions, or contracts changed.
- Related Epic plans under `docs/plan/` may move to `done` / `superseded` when applicable.

When `PROJECT-STATUS.md` says **MAINTAIN**:

- Keep changes narrow: bugfixes, copy tweaks, docs sync, QA follow-ups, or explicitly requested UI/pixel fixes.
- Do not start a new feature phase, refactor, or API contract change without explicit user approval.
- If the user requests new scope, switch back to ACTIVE by updating `PROJECT-STATUS.md` (and write a new Current Task Plan only if the work is non-trivial).

## Guardrails

- Keep changes surgical and aligned with accepted scope.
- Do not change API contracts unless explicitly approved.
- Prioritize correctness, security, and testability over speed.
- Before merge/release: no critical review issues, tests pass, QA checklist complete.
- Prefer PR-based delivery for non-trivial changes.
- Follow **Git Policy** for commits and pushes.

## Git Policy

- Do not run `git commit` or `git push` until the user explicitly approves git operations in this conversation (Cursor chat, Codex CLI, Gemini CLI, or Claude Code session).
- Treat approval as explicit when the user sends one of these (or clearly the same intent in one message): `ok commit và push`, `commit và push giúp mình`, `commit and push`.
- Before proposing a commit, follow **`.cursor/skills/pre-propose-commit/SKILL.md`**: run checks that exist in this repo (lint / format check / typecheck / fast tests as applicable), then present results using that skill’s report template. The report must include a short summary of what changed (scope of files/behavior) and test or lint status (what ran and result, or why nothing ran).

## Definition of Done

- Scope accepted by `@agents/tech-lead` is implemented.
- Mandatory review by `@agents/code-reviewer` has no unresolved critical issues.
- QA readiness from `@agents/qa-engineer` is complete for the agreed scope.
- Documentation is synced: `docs/PROJECT-STATUS.md`, `docs/memory/*`, and relevant `docs/runtime/*` no longer contradict the implemented state.
- Manual UI/pixel adjustments are recorded in status/QA notes when they affect future agent work.
- User explicitly confirms the task is done.

## Release Command Checklist

Run these only in the target project repository (not in template repo unless updating template):

1. `git status`
2. `git add -A`
3. `git commit -m "<message>"`
4. `git push`

If creating a PR-based flow, push branch first and open PR after push.

## Codex CLI Usage

- When running in Codex CLI, treat this `AGENTS.md` as the primary instruction file.
- Codex cannot rely on Cursor auto-loading `.cursor/rules/*.mdc` by `globs`; open the files you need explicitly.
- **Standards by stack:** read the smallest useful set under `.cursor/rules/standards/*.mdc` for the task (skip files your repo does not ship). Examples:
  - Frontend / markup / BEM / a11y:
    - `.cursor/rules/standards/frontend-bem-a11y-planning.mdc`
    - `.cursor/rules/standards/css-framework-adaptive.mdc`
    - `.cursor/rules/standards/stack-examples-bem-html-pug-bootstrap-tailwind.mdc`
  - WordPress theme:
    - `.cursor/rules/standards/wordpress-theme-php.mdc`
  - Backend API (e.g. FastAPI):
    - `.cursor/rules/standards/stack-examples-fastapi-python.mdc`
  - Backend API (NestJS):
    - `.cursor/rules/standards/stack-examples-nestjs-typescript.mdc`
  - TypeScript / React:
    - `.cursor/rules/standards/typescript-and-performance.mdc`
    - `.cursor/rules/standards/stack-examples-react-typescript.mdc`
  - Nuxt 3 + Vue:
    - `.cursor/rules/standards/stack-examples-nuxt-vue.mdc`
    - `.cursor/rules/standards/composition-api-and-testing.mdc`
  - Cross-cutting discipline (when useful):
    - `.cursor/rules/standards/karpathy-guidelines.mdc`
- **Typical openers** (user or wrapper script can paste):
  - `Read AGENTS.md first, then act as @agents/frontend-dev.`
  - `Read AGENTS.md and relevant standards before editing Pug/SCSS.`
  - `For project-level UI design-system work, read .cursor/skills/design-system/SKILL.md after @agents/frontend-dev.`
  - `Follow .cursor/skills/pre-propose-commit/SKILL.md before proposing commit.`
- For role-based work, read the matching persona in `.cursor/rules/agents/*.mdc` (see **Role Emulation**).
- For repeatable workflows, read the matching skill in `.cursor/skills/*/SKILL.md`.
- Before non-trivial code changes, Codex should:
  1. Read this file.
  2. Read `docs/memory/*` and `docs/runtime/current-task-plan.md` if they exist (see **Memory Protocol**).
  3. Inspect relevant `.cursor/rules/standards/*.mdc` (by stack, not the whole tree by default).
  4. Implement surgically.
  5. Report changed files and validation status.

## Gemini CLI Usage

- Read **`GEMINI.md`** at the repository root first for Gemini-oriented coordination (roles, standards paths, suggested phases). **Binding workflow, Git policy, and Definition of Done remain in this `AGENTS.md`.**
- Gemini environments differ: features such as `update_topic`, `invoke_agent`, or built-in “Validate” hooks apply **only if your Gemini CLI or wrapper exposes them**. If not available, follow the same manual steps as Codex: read the persona `.mdc`, read relevant standards, then run checks per **`.cursor/skills/pre-propose-commit/SKILL.md`** before suggesting a commit.
- **Language:** Keep the Vietnamese preference defined in this document unless the user asks otherwise.

## Claude Code Usage

- Read **`CLAUDE.md`** at the repository root first for Claude-oriented coordination (role auto-mapping, standards by file type, memory layers, tools). **Binding workflow, Git policy, and Definition of Done remain in this `AGENTS.md`.**
- Claude Code has **no** Cursor `@` rule picker and does not auto-apply `globs`. When the user writes `@agents/<role>` or "act as <role>", Claude **must** open the matching persona under `.cursor/rules/agents/*.mdc` (see **Role Emulation**) and then read only the relevant standards listed in `CLAUDE.md` § 3.
- If the project ships **Claude Code subagents** under `.claude/agents/*.md` with the same role names, use them as the invocation surface; the binding behavior is still defined by `.cursor/rules/agents/*.mdc` so all CLIs stay consistent.
- Before suggesting a commit, run the checks in **`.cursor/skills/pre-propose-commit/SKILL.md`** and report results — same Git Policy as Codex / Gemini.

## Role Emulation

Use this when the tool has **no** Cursor `@` rule picker (e.g. **Codex CLI**, **Gemini CLI**, **Claude Code**, or other headless CLIs): map “act as `@agents/...`” to reading the matching `.mdc` under `.cursor/rules/agents/` (and read **`GEMINI.md`** or **`CLAUDE.md`** first when using those tools, if present).

When prompted with:
- "act as @agents/frontend-dev"
- "act as @agents/backend-dev"
- "act as @agents/tech-lead"
- "act as @agents/code-reviewer"
- "act as @agents/qa-engineer"
- "act as @agents/delivery-auditor"

The agent should:

1. Read the corresponding rule file in:
   `.cursor/rules/agents/*.mdc`

2. Apply the persona, workflow, and constraints from that rule.

3. Read any relevant standards in:
   `.cursor/rules/standards/*.mdc`

4. Follow repository guardrails and Git Policy from this `AGENTS.md`.

## Rule Sources

- Role rules: `.cursor/rules/agents/*.mdc`
- Technical standards: `.cursor/rules/standards/*.mdc`
- Repeatable workflows (lint/test before commit, publish, template copy): `.cursor/skills/*/SKILL.md`

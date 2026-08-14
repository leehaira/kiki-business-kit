#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ACTIVE_DIR="$ROOT_DIR/.agent/active"
ALIASES_FILE="$ROOT_DIR/.agent/aliases.env"
RUNTIME_PLAN="$ROOT_DIR/docs/runtime/current-task-plan.md"
COPY_PROMPT=0
ROLE_INPUT=""

AGENT_ALIAS_TECH_LEAD="luffy"
AGENT_ALIAS_BACKEND_DEV="zoro"
AGENT_ALIAS_FRONTEND_DEV="sanji"
AGENT_ALIAS_CODE_REVIEWER="nami"
AGENT_ALIAS_QA_ENGINEER="chopper"
AGENT_ALIAS_DELIVERY_AUDITOR="robin"

if [ -f "$ALIASES_FILE" ]; then
  # shellcheck disable=SC1090
  . "$ALIASES_FILE"
fi

usage() {
  echo "Usage: bash scripts/agent-run.sh [--role <role>] [--copy]" >&2
}

runtime_plan_has_meaningful_content() {
  [ -s "$RUNTIME_PLAN" ] || return 1
  grep -Eq '^\| Task ID \|[[:space:]]*[^|[:space:]][^|]*\|' "$RUNTIME_PLAN" && return 0
  grep -Eq '^\| Task ID / branch \|[[:space:]]*[^|[:space:]][^|]*\|' "$RUNTIME_PLAN" && return 0
  grep -Eq '^\| Task title \|[[:space:]]*[^|[:space:]][^|]*\|' "$RUNTIME_PLAN" && return 0
  grep -Eq '^\| Status \|[[:space:]]*(planned|in-progress|blocked|review|qa|done)[[:space:]]*\|' "$RUNTIME_PLAN" && return 0
  grep -Eq '^\| Status \|[[:space:]]*[^|[:space:]][^|]*\|' "$RUNTIME_PLAN" && return 0
  grep -Eq '^- \[[xX]\]' "$RUNTIME_PLAN" && return 0
  grep -Eq '^No active task\.' "$RUNTIME_PLAN" && return 1
  return 1
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --copy)
      COPY_PROMPT=1
      shift
      ;;
    --role)
      if [ "$#" -lt 2 ] || [ -z "$2" ]; then
        usage
        exit 2
      fi
      ROLE_INPUT=$2
      shift 2
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

if [ -n "$ROLE_INPUT" ] && printf "%s" "$ROLE_INPUT" | LC_ALL=C grep -q '[[:cntrl:]]'; then
  echo "Role must not contain control characters." >&2
  exit 2
fi

NEWLINE='
'
CR=$(printf '\r')
case "$ROLE_INPUT" in
  *"$NEWLINE"*|*"$CR"*)
    echo "Role must not contain control characters." >&2
    exit 2
    ;;
esac

ROLE_KEY=$(printf "%s" "$ROLE_INPUT" | tr "[:upper:]" "[:lower:]")
ALIAS_TECH_LEAD=$(printf "%s" "$AGENT_ALIAS_TECH_LEAD" | tr "[:upper:]" "[:lower:]")
ALIAS_BACKEND_DEV=$(printf "%s" "$AGENT_ALIAS_BACKEND_DEV" | tr "[:upper:]" "[:lower:]")
ALIAS_FRONTEND_DEV=$(printf "%s" "$AGENT_ALIAS_FRONTEND_DEV" | tr "[:upper:]" "[:lower:]")
ALIAS_CODE_REVIEWER=$(printf "%s" "$AGENT_ALIAS_CODE_REVIEWER" | tr "[:upper:]" "[:lower:]")
ALIAS_QA_ENGINEER=$(printf "%s" "$AGENT_ALIAS_QA_ENGINEER" | tr "[:upper:]" "[:lower:]")
ALIAS_DELIVERY_AUDITOR=$(printf "%s" "$AGENT_ALIAS_DELIVERY_AUDITOR" | tr "[:upper:]" "[:lower:]")
DISPLAY_ALIAS_TECH_LEAD=$(printf "%s" "$AGENT_ALIAS_TECH_LEAD" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
DISPLAY_ALIAS_BACKEND_DEV=$(printf "%s" "$AGENT_ALIAS_BACKEND_DEV" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
DISPLAY_ALIAS_FRONTEND_DEV=$(printf "%s" "$AGENT_ALIAS_FRONTEND_DEV" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
DISPLAY_ALIAS_CODE_REVIEWER=$(printf "%s" "$AGENT_ALIAS_CODE_REVIEWER" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
DISPLAY_ALIAS_QA_ENGINEER=$(printf "%s" "$AGENT_ALIAS_QA_ENGINEER" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
DISPLAY_ALIAS_DELIVERY_AUDITOR=$(printf "%s" "$AGENT_ALIAS_DELIVERY_AUDITOR" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')

case "$ROLE_KEY" in
  "")
    ACT_LINE="Act as the appropriate technical role for the active task."
    ;;
  tech-lead|backend-dev|frontend-dev|code-reviewer|qa-engineer|delivery-auditor)
    ACT_LINE="Act as $ROLE_KEY."
    ;;
  *)
    if [ -n "$ALIAS_TECH_LEAD" ] && [ "$ROLE_KEY" = "$ALIAS_TECH_LEAD" ]; then
      ACT_LINE="Act as tech-lead (alias: $DISPLAY_ALIAS_TECH_LEAD)."
    elif [ -n "$ALIAS_BACKEND_DEV" ] && [ "$ROLE_KEY" = "$ALIAS_BACKEND_DEV" ]; then
      ACT_LINE="Act as backend-dev (alias: $DISPLAY_ALIAS_BACKEND_DEV)."
    elif [ -n "$ALIAS_FRONTEND_DEV" ] && [ "$ROLE_KEY" = "$ALIAS_FRONTEND_DEV" ]; then
      ACT_LINE="Act as frontend-dev (alias: $DISPLAY_ALIAS_FRONTEND_DEV)."
    elif [ -n "$ALIAS_CODE_REVIEWER" ] && [ "$ROLE_KEY" = "$ALIAS_CODE_REVIEWER" ]; then
      ACT_LINE="Act as code-reviewer (alias: $DISPLAY_ALIAS_CODE_REVIEWER)."
    elif [ -n "$ALIAS_QA_ENGINEER" ] && [ "$ROLE_KEY" = "$ALIAS_QA_ENGINEER" ]; then
      ACT_LINE="Act as qa-engineer (alias: $DISPLAY_ALIAS_QA_ENGINEER)."
    elif [ -n "$ALIAS_DELIVERY_AUDITOR" ] && [ "$ROLE_KEY" = "$ALIAS_DELIVERY_AUDITOR" ]; then
      ACT_LINE="Act as delivery-auditor (alias: $DISPLAY_ALIAS_DELIVERY_AUDITOR)."
    else
      ACT_LINE="Act as $ROLE_INPUT."
    fi
    ;;
esac

if [ ! -d "$ACTIVE_DIR" ]; then
  echo "Missing .agent/active/ directory." >&2
  echo "Create a task first: bash scripts/agent-task.sh \"short task title\"" >&2
  exit 1
fi

TASK_PATH=""
for candidate in "$ACTIVE_DIR"/*.md; do
  [ -e "$candidate" ] || continue
  if [ -z "$TASK_PATH" ] || [ "$candidate" -nt "$TASK_PATH" ]; then
    TASK_PATH=$candidate
  fi
done

if [ -z "$TASK_PATH" ]; then
  echo "No active task markdown found in .agent/active/." >&2
  echo "Create a task first: bash scripts/agent-task.sh \"short task title\"" >&2
  exit 1
fi

REL_TASK=${TASK_PATH#"$ROOT_DIR"/}

PROMPT=$(cat <<PROMPT_TEXT
$ACT_LINE

Read:
- AGENTS.md
- .agent/orchestration.md
- docs/PROJECT-STATUS.md
- docs/memory/project-memory.md
- docs/memory/decisions.md
- $REL_TASK
- docs/runtime/current-task-plan.md
- docs/memory/agent-personas.md if available

Task:
- Classify work size (TRIVIAL / TASK / EPIC). For Epic-sized work, maintain docs/plan/EPIC-*.md.
- Rewrite docs/runtime/current-task-plan.md for exactly one accepted Task when the task is non-trivial. Do not append task history. Do not put project Mode on the Task plan.
- Implement only accepted scope.
- Update docs/runtime/reviewer-report.md after review.
- Update docs/runtime/qa-checklist.md after validation.
- Stop before commit/push. Never commit or push.

Report:
- Files changed
- Checks run
- Risks
- Next recommended role
PROMPT_TEXT
)

if ! runtime_plan_has_meaningful_content; then
  echo "WARNING:"
  echo "Active task exists but current-task-plan.md may still be empty or placeholder-only."
  echo "Consider running:"
  echo "bash scripts/agent-run.sh --role luffy --copy"
  echo
  echo "before implementation."
  echo
fi

echo "Active task: $REL_TASK"
echo
echo "Required context files:"
echo "- AGENTS.md"
echo "- .agent/orchestration.md"
echo "- docs/PROJECT-STATUS.md"
echo "- docs/memory/project-memory.md"
echo "- docs/memory/decisions.md"
echo "- $REL_TASK"
echo "- docs/runtime/current-task-plan.md"
echo "- docs/memory/agent-personas.md (if available)"
echo
echo "Ready-to-copy prompt for Codex/Cursor/Gemini:"
echo "-----"
printf "%s\n" "$PROMPT"
echo "-----"

if [ "$COPY_PROMPT" -eq 1 ]; then
  if command -v pbcopy >/dev/null 2>&1; then
    if printf "%s\n" "$PROMPT" | pbcopy; then
      echo "Prompt copied to clipboard with pbcopy."
    else
      echo "pbcopy failed; prompt was printed only." >&2
    fi
  else
    echo "pbcopy not available; prompt was printed only." >&2
  fi
fi

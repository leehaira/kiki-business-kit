#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
AGENT_DIR="$ROOT_DIR/.agent"

if [ "$#" -ne 1 ]; then
  echo "Usage: scripts/agent-task.sh \"short task title\"" >&2
  exit 2
fi

TASK_TITLE=$1

NEWLINE='
'
CR=$(printf '\r')
case "$TASK_TITLE" in
  *"$NEWLINE"*|*"$CR"*)
    echo "Task title must not contain newline or control characters." >&2
    exit 2
    ;;
esac

if printf "%s" "$TASK_TITLE" | LC_ALL=C grep -q '[[:cntrl:]]'; then
  echo "Task title must not contain newline or control characters." >&2
  exit 2
fi

CREATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
STAMP=$(date -u +"%Y%m%d-%H%M%S")
SLUG=$(printf "%s" "$TASK_TITLE" | tr "[:upper:]" "[:lower:]" | sed "s/[^a-z0-9][^a-z0-9]*/-/g; s/^-//; s/-$//")

if [ -z "$SLUG" ]; then
  SLUG="task"
fi

mkdir -p "$AGENT_DIR/inbox" "$AGENT_DIR/active" "$AGENT_DIR/done" "$AGENT_DIR/logs" "$AGENT_DIR/templates"

TEMPLATE="$AGENT_DIR/templates/task.md"
INBOX_FILE="$AGENT_DIR/inbox/$STAMP-$SLUG.md"
ACTIVE_FILE="$AGENT_DIR/active/$STAMP-$SLUG.md"
ESC_TASK_TITLE=$(printf "%s" "$TASK_TITLE" | sed 's/[\/&\\]/\\&/g')
ESC_CREATED_AT=$(printf "%s" "$CREATED_AT" | sed 's/[\/&\\]/\\&/g')

if [ ! -f "$TEMPLATE" ]; then
  cat > "$TEMPLATE" <<'TASK_TEMPLATE'
# Task: {{TASK_TITLE}}

| Field | Value |
|-------|-------|
| Created | {{CREATED_AT}} |
| Source | `.agent/inbox` |
| State | active |

## Request

{{TASK_TITLE}}

## Handoff

- Follow `AGENTS.md`.
- Convert accepted scope into `docs/runtime/current-task-plan.md` before implementation when the task is non-trivial.
- Keep review output in `docs/runtime/reviewer-report.md`.
- Keep QA output in `docs/runtime/qa-checklist.md`.
TASK_TEMPLATE
fi

sed "s/{{TASK_TITLE}}/$ESC_TASK_TITLE/g; s/{{CREATED_AT}}/$ESC_CREATED_AT/g" "$TEMPLATE" > "$INBOX_FILE"
mv "$INBOX_FILE" "$ACTIVE_FILE"

echo "Created active task: $ACTIVE_FILE"
echo
echo "Reminder: convert accepted scope into docs/runtime/current-task-plan.md before implementation when the task is non-trivial."
echo
echo "Next recommended role order:"
echo "tech-lead -> frontend-dev/backend-dev -> code-reviewer -> qa-engineer -> delivery-auditor if needed"

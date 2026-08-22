#!/usr/bin/env bash
set -euo pipefail

# apply-template.sh
# Muc tieu: copy bo Agent Team template vao mot du an dich:
#   - .cursor/
#   - AGENTS.md
#   - GEMINI.md (neu co trong template)
#   - CLAUDE.md (neu co trong template)
#   - .agent/, scripts/agent-task.sh, scripts/agent-run.sh (optional local queue automation)
#   - docs/PROJECT-STATUS.md
#   - docs/kb/, docs/memory/, docs/runtime/, docs/plan/, docs/design/, docs/guides/, docs/examples/
#
# Cach dung:
#   ./apply-template.sh <target-project-path> [--force|--safe]
# Vi du:
#   ./apply-template.sh "/Volumes/Bigdata/git/my-new-project"
#   ./apply-template.sh "/Volumes/Bigdata/git/my-new-project" --force
#   ./apply-template.sh "/Volumes/Bigdata/git/my-new-project" --safe

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <target-project-path> [--force|--safe]"
  exit 1
fi

TARGET_DIR="$1"
MODE_FLAG="${2:-}"

if [[ $# -eq 2 && "${MODE_FLAG}" != "--force" && "${MODE_FLAG}" != "--safe" ]]; then
  echo "Invalid option: ${MODE_FLAG}"
  echo "Usage: $0 <target-project-path> [--force|--safe]"
  exit 1
fi

FORCE_MODE=0
SAFE_MODE=0
if [[ "${MODE_FLAG}" == "--force" ]]; then
  FORCE_MODE=1
elif [[ "${MODE_FLAG}" == "--safe" ]]; then
  SAFE_MODE=1
fi

if [[ ! -d "${TARGET_DIR}" ]]; then
  echo "Thu muc dich khong ton tai: ${TARGET_DIR}"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SOURCE_CURSOR_DIR="${SCRIPT_DIR}/.cursor"
SOURCE_AGENTS_FILE="${SCRIPT_DIR}/AGENTS.md"
SOURCE_GEMINI_FILE="${SCRIPT_DIR}/GEMINI.md"
SOURCE_CLAUDE_FILE="${SCRIPT_DIR}/CLAUDE.md"
SOURCE_AGENT_DIR="${SCRIPT_DIR}/.agent"
SOURCE_AGENT_ALIASES_FILE="${SCRIPT_DIR}/.agent/aliases.env"
SOURCE_AGENT_TASK_SCRIPT="${SCRIPT_DIR}/scripts/agent-task.sh"
SOURCE_AGENT_RUN_SCRIPT="${SCRIPT_DIR}/scripts/agent-run.sh"
SOURCE_PROJECT_STATUS_FILE="${SCRIPT_DIR}/docs/PROJECT-STATUS.md"
SOURCE_DOCS_KB="${SCRIPT_DIR}/docs/kb"
SOURCE_DOCS_MEMORY="${SCRIPT_DIR}/docs/memory"
SOURCE_DOCS_RUNTIME="${SCRIPT_DIR}/docs/runtime"
SOURCE_DOCS_PLAN="${SCRIPT_DIR}/docs/plan"
SOURCE_DOCS_DESIGN="${SCRIPT_DIR}/docs/design"
SOURCE_DOCS_GUIDES="${SCRIPT_DIR}/docs/guides"
SOURCE_DOCS_EXAMPLES="${SCRIPT_DIR}/docs/examples"

TARGET_CURSOR_DIR="${TARGET_DIR}/.cursor"
TARGET_AGENTS_FILE="${TARGET_DIR}/AGENTS.md"
TARGET_GEMINI_FILE="${TARGET_DIR}/GEMINI.md"
TARGET_CLAUDE_FILE="${TARGET_DIR}/CLAUDE.md"
TARGET_AGENT_DIR="${TARGET_DIR}/.agent"
TARGET_AGENT_TASK_SCRIPT="${TARGET_DIR}/scripts/agent-task.sh"
TARGET_AGENT_RUN_SCRIPT="${TARGET_DIR}/scripts/agent-run.sh"
TARGET_PROJECT_STATUS_FILE="${TARGET_DIR}/docs/PROJECT-STATUS.md"
TARGET_DOCS_MEMORY_PM="${TARGET_DIR}/docs/memory/project-memory.md"
TARGET_DOCS_MEMORY_DEC="${TARGET_DIR}/docs/memory/decisions.md"
TARGET_DOCS_RUNTIME_PLAN="${TARGET_DIR}/docs/runtime/current-task-plan.md"
TARGET_DOCS_RUNTIME_REVIEW="${TARGET_DIR}/docs/runtime/reviewer-report.md"
TARGET_DOCS_RUNTIME_QA="${TARGET_DIR}/docs/runtime/qa-checklist.md"

check_no_doc_conflicts() {
  local source_dir="$1"
  local target_dir="$2"
  local label="$3"
  local item

  if [[ ! -d "${source_dir}" || ! -d "${target_dir}" ]]; then
    return
  fi

  shopt -s nullglob dotglob
  for item in "${source_dir}"/*; do
    if [[ -e "${target_dir}/$(basename "${item}")" ]]; then
      shopt -u nullglob dotglob
      echo "Da ton tai ${label}/$(basename "${item}") trong du an dich."
      echo "Neu ban muon ghi de, chay lai voi --force"
      exit 1
    fi
  done
  shopt -u nullglob dotglob
}

target_rel_path() {
  local path="$1"
  printf "%s" "${path#${TARGET_DIR}/}"
}

copy_file() {
  local source_file="$1"
  local target_file="$2"

  if [[ "${SAFE_MODE}" -eq 1 && -e "${target_file}" ]]; then
    echo "SKIP existing: $(target_rel_path "${target_file}")"
    return
  fi

  mkdir -p "$(dirname "${target_file}")"
  cp "${source_file}" "${target_file}"
}

copy_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"
  local item

  [[ -d "${source_dir}" ]] || return
  if [[ "${SAFE_MODE}" -eq 1 && -e "${target_dir}" && ! -d "${target_dir}" ]]; then
    echo "SKIP existing: $(target_rel_path "${target_dir}")"
    return
  fi
  mkdir -p "${target_dir}"

  shopt -s nullglob dotglob
  for item in "${source_dir}"/*; do
    if [[ -d "${item}" ]]; then
      copy_dir_contents "${item}" "${target_dir}/$(basename "${item}")"
    else
      copy_file "${item}" "${target_dir}/$(basename "${item}")"
    fi
  done
  shopt -u nullglob dotglob
}

ensure_empty_file() {
  local target_file="$1"

  if [[ "${SAFE_MODE}" -eq 1 && -e "${target_file}" ]]; then
    echo "SKIP existing: $(target_rel_path "${target_file}")"
    return
  fi

  mkdir -p "$(dirname "${target_file}")"
  touch "${target_file}"
}

copy_executable() {
  local source_file="$1"
  local target_file="$2"
  local target_existed=0

  if [[ -e "${target_file}" ]]; then
    target_existed=1
  fi

  copy_file "${source_file}" "${target_file}"
  if [[ "${SAFE_MODE}" -eq 0 || "${target_existed}" -eq 0 ]]; then
    chmod +x "${target_file}"
  fi
}

if [[ ! -d "${SOURCE_CURSOR_DIR}" || ! -f "${SOURCE_AGENTS_FILE}" ]]; then
  echo "Template khong hop le: thieu .cursor/ hoac AGENTS.md"
  exit 1
fi

if [[ ! -d "${SOURCE_DOCS_KB}" || ! -d "${SOURCE_DOCS_MEMORY}" || ! -d "${SOURCE_DOCS_RUNTIME}" ]]; then
  echo "Template khong hop le: thieu docs/kb/, docs/memory/, hoac docs/runtime/"
  exit 1
fi

if [[ "${FORCE_MODE}" -eq 0 && "${SAFE_MODE}" -eq 0 ]]; then
  if [[ -e "${TARGET_CURSOR_DIR}" || -e "${TARGET_AGENTS_FILE}" ]]; then
    echo "Da ton tai .cursor hoac AGENTS.md trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${SOURCE_GEMINI_FILE}" && -f "${TARGET_GEMINI_FILE}" ]]; then
    echo "Da ton tai GEMINI.md trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${SOURCE_CLAUDE_FILE}" && -f "${TARGET_CLAUDE_FILE}" ]]; then
    echo "Da ton tai CLAUDE.md trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -d "${SOURCE_AGENT_DIR}" && -e "${TARGET_AGENT_DIR}" ]]; then
    echo "Da ton tai .agent/ trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${SOURCE_AGENT_TASK_SCRIPT}" && -f "${TARGET_AGENT_TASK_SCRIPT}" ]]; then
    echo "Da ton tai scripts/agent-task.sh trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${SOURCE_AGENT_RUN_SCRIPT}" && -f "${TARGET_AGENT_RUN_SCRIPT}" ]]; then
    echo "Da ton tai scripts/agent-run.sh trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${TARGET_DOCS_MEMORY_PM}" || -f "${TARGET_DOCS_MEMORY_DEC}" ]]; then
    echo "Da ton tai docs/memory (project-memory.md hoac decisions.md) trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${SOURCE_PROJECT_STATUS_FILE}" && -f "${TARGET_PROJECT_STATUS_FILE}" ]]; then
    echo "Da ton tai docs/PROJECT-STATUS.md trong du an dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -f "${TARGET_DOCS_RUNTIME_PLAN}" || -f "${TARGET_DOCS_RUNTIME_REVIEW}" || -f "${TARGET_DOCS_RUNTIME_QA}" ]]; then
    echo "Da ton tai docs/runtime/ (current-task-plan, reviewer-report, hoac qa-checklist) trong duan dich."
    echo "Neu ban muon ghi de, chay lai voi --force"
    exit 1
  fi
  if [[ -d "${TARGET_DIR}/docs/kb" ]]; then
    shopt -s nullglob dotglob
    kb_existing=( "${TARGET_DIR}/docs/kb"/* )
    shopt -u nullglob dotglob
    if [[ ${#kb_existing[@]} -gt 0 ]]; then
      echo "Da ton tai docs/kb/ co file trong du an dich (de tranh ghi de KB)."
      echo "Neu ban muon ghi de, chay lai voi --force"
      exit 1
    fi
  fi
  check_no_doc_conflicts "${SOURCE_DOCS_GUIDES}" "${TARGET_DIR}/docs/guides" "docs/guides"
  check_no_doc_conflicts "${SOURCE_DOCS_EXAMPLES}" "${TARGET_DIR}/docs/examples" "docs/examples"
fi

if [[ "${FORCE_MODE}" -eq 1 ]]; then
  echo "CANH BAO: --force se ghi de .cursor/, .agent/, docs/kb/, docs/memory/, docs/runtime/, docs/guides/, docs/examples/, docs/PROJECT-STATUS.md tren du an dich."
  echo "Chi dung tren repo moi hoac sau khi da backup."
fi

if [[ "${SAFE_MODE}" -eq 1 ]]; then
  echo "SAFE mode: existing files will be skipped."
fi

echo "Dang copy .cursor/ vao du an dich..."
if [[ "${FORCE_MODE}" -eq 1 ]]; then
  rm -rf "${TARGET_CURSOR_DIR}"
fi
copy_dir_contents "${SOURCE_CURSOR_DIR}" "${TARGET_CURSOR_DIR}"

echo "Dang copy AGENTS.md..."
copy_file "${SOURCE_AGENTS_FILE}" "${TARGET_AGENTS_FILE}"

if [[ -f "${SOURCE_GEMINI_FILE}" ]]; then
  echo "Dang copy GEMINI.md..."
  copy_file "${SOURCE_GEMINI_FILE}" "${TARGET_GEMINI_FILE}"
fi

if [[ -f "${SOURCE_CLAUDE_FILE}" ]]; then
  echo "Dang copy CLAUDE.md..."
  copy_file "${SOURCE_CLAUDE_FILE}" "${TARGET_CLAUDE_FILE}"
fi

if [[ -d "${SOURCE_AGENT_DIR}" ]]; then
  echo "Dang copy .agent/..."
  if [[ "${FORCE_MODE}" -eq 1 ]]; then
    rm -rf "${TARGET_AGENT_DIR}"
  fi
  mkdir -p \
    "${TARGET_AGENT_DIR}/inbox" \
    "${TARGET_AGENT_DIR}/active" \
    "${TARGET_AGENT_DIR}/done" \
    "${TARGET_AGENT_DIR}/logs" \
    "${TARGET_AGENT_DIR}/templates"
  copy_file "${SOURCE_AGENT_DIR}/orchestration.md" "${TARGET_AGENT_DIR}/orchestration.md"
  copy_file "${SOURCE_AGENT_DIR}/templates/task.md" "${TARGET_AGENT_DIR}/templates/task.md"
  if [[ -f "${SOURCE_AGENT_ALIASES_FILE}" ]]; then
    copy_file "${SOURCE_AGENT_ALIASES_FILE}" "${TARGET_AGENT_DIR}/aliases.env"
  fi
  ensure_empty_file "${TARGET_AGENT_DIR}/inbox/.gitkeep"
  ensure_empty_file "${TARGET_AGENT_DIR}/active/.gitkeep"
  ensure_empty_file "${TARGET_AGENT_DIR}/done/.gitkeep"
  ensure_empty_file "${TARGET_AGENT_DIR}/logs/.gitkeep"
fi

if [[ -f "${SOURCE_AGENT_TASK_SCRIPT}" ]]; then
  echo "Dang copy scripts/agent-task.sh..."
  copy_executable "${SOURCE_AGENT_TASK_SCRIPT}" "${TARGET_AGENT_TASK_SCRIPT}"
fi

if [[ -f "${SOURCE_AGENT_RUN_SCRIPT}" ]]; then
  echo "Dang copy scripts/agent-run.sh..."
  copy_executable "${SOURCE_AGENT_RUN_SCRIPT}" "${TARGET_AGENT_RUN_SCRIPT}"
fi

echo "Dang copy docs/kb, docs/memory, docs/runtime, docs/plan, docs/design, docs/guides, docs/examples..."
mkdir -p "${TARGET_DIR}/docs/kb" "${TARGET_DIR}/docs/memory" "${TARGET_DIR}/docs/runtime" "${TARGET_DIR}/docs/plan" "${TARGET_DIR}/docs/design"
if [[ -f "${SOURCE_PROJECT_STATUS_FILE}" ]]; then
  copy_file "${SOURCE_PROJECT_STATUS_FILE}" "${TARGET_PROJECT_STATUS_FILE}"
fi
copy_dir_contents "${SOURCE_DOCS_KB}" "${TARGET_DIR}/docs/kb"
copy_dir_contents "${SOURCE_DOCS_MEMORY}" "${TARGET_DIR}/docs/memory"
copy_dir_contents "${SOURCE_DOCS_RUNTIME}" "${TARGET_DIR}/docs/runtime"
if [[ -d "${SOURCE_DOCS_GUIDES}" ]]; then
  copy_dir_contents "${SOURCE_DOCS_GUIDES}" "${TARGET_DIR}/docs/guides"
fi
if [[ -d "${SOURCE_DOCS_EXAMPLES}" ]]; then
  copy_dir_contents "${SOURCE_DOCS_EXAMPLES}" "${TARGET_DIR}/docs/examples"
fi
if [[ -d "${SOURCE_DOCS_PLAN}" ]]; then
  copy_dir_contents "${SOURCE_DOCS_PLAN}" "${TARGET_DIR}/docs/plan"
else
  ensure_empty_file "${TARGET_DIR}/docs/plan/.gitkeep"
fi
if [[ -d "${SOURCE_DOCS_DESIGN}" ]]; then
  copy_dir_contents "${SOURCE_DOCS_DESIGN}" "${TARGET_DIR}/docs/design"
else
  ensure_empty_file "${TARGET_DIR}/docs/design/.gitkeep"
fi
if [[ -f "${SCRIPT_DIR}/docs/README.md" ]]; then
  copy_file "${SCRIPT_DIR}/docs/README.md" "${TARGET_DIR}/docs/README.md"
fi

echo "Hoan tat."
echo "Buoc tiep theo:"
echo "1) Dien docs/PROJECT-STATUS.md va docs/memory/* (kickoff); giu docs/runtime/* skeleton den task non-trivial"
echo "2) Mo repo dich trong Cursor (va/hoac CLI doc AGENTS.md / GEMINI.md / CLAUDE.md)"
echo "3) Bat dau voi @agents/tech-lead (Cursor) hoac doc AGENTS.md + persona .mdc"
echo "4) Queue cuc bo (tuy chon): bash scripts/agent-task.sh \"short task title\""
echo "5) Prompt task active: bash scripts/agent-run.sh [--copy]"
echo "6) Guides/examples da duoc copy vao docs/guides va docs/examples trong repo dich"

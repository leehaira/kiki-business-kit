#!/usr/bin/env bash
set -euo pipefail

# publish-to-github.sh
# Muc tieu: tao repo GitHub ca nhan tu project local va push lan dau.
#
# Cach dung:
#   ./publish-to-github.sh <repo-name> [public|private]
# Vi du:
#   ./publish-to-github.sh robot-saas-template private

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <repo-name> [public|private]"
  exit 1
fi

REPO_NAME="$1"
VISIBILITY="${2:-private}"

if [[ "${VISIBILITY}" != "public" && "${VISIBILITY}" != "private" ]]; then
  echo "Visibility phai la 'public' hoac 'private'."
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Chua cai GitHub CLI (gh). Cai dat truoc khi chay script."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Ban chua dang nhap gh. Chay: gh auth login"
  exit 1
fi

if [[ ! -d .git ]]; then
  echo "Khoi tao git repository..."
  git init
fi

if [[ -z "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)" ]]; then
  git checkout -b main
fi

# Neu chua co commit nao, tao commit dau tien.
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "Tao initial commit..."
  git add -A
  git commit -m "chore: initial commit"
else
  # Neu co thay doi chua commit thi commit gon.
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "Co thay doi chua commit, dang commit..."
    git add -A
    git commit -m "chore: update project files"
  fi
fi

if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote 'origin' da ton tai. Dang push len origin..."
  CURRENT_BRANCH="$(git branch --show-current)"
  git push -u origin "${CURRENT_BRANCH}"
  echo "Hoan tat push len remote hien tai."
  exit 0
fi

if [[ "${VISIBILITY}" == "public" ]]; then
  GH_VISIBILITY_FLAG="--public"
else
  GH_VISIBILITY_FLAG="--private"
fi

echo "Tao repo GitHub va push lan dau..."
gh repo create "${REPO_NAME}" ${GH_VISIBILITY_FLAG} --source=. --remote=origin --push

echo "Hoan tat. Repo da duoc tao va push len GitHub."

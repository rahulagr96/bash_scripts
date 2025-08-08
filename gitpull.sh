#!/usr/bin/env bash
# gitpull.sh — Fetch + Pull all git repos up to a configurable depth
# Usage:
#   ./gitpull.sh                 # scan 2 levels deep (default)
#   ./gitpull.sh -d 3            # scan 3 levels deep
#   DEPTH=1 ./gitpull.sh         # also works via env var
#
# What it does per repo:
#   1) git fetch --all --prune
#   2) git pull --rebase --autostash   (only on the current branch)
#
# Output is emoji-loud and readable. 🎉

set -euo pipefail

# --------- args ---------
DEPTH="${DEPTH:-2}"   # change this line for default depth (for depth 1) -> DEPTH="${DEPTH:-1}
while getopts ":d:h" opt; do
  case "$opt" in
    d) DEPTH="$OPTARG" ;;
    h)
      echo "Usage: $0 [-d DEPTH]"
      echo "  -d DEPTH   How many levels of subdirectories to scan (default: 2)"
      exit 0
      ;;
    \?)
      echo "❌ Unknown option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Validate depth is a positive integer
if ! [[ "$DEPTH" =~ ^[0-9]+$ ]] || [[ "$DEPTH" -lt 1 ]]; then
  echo "❌ DEPTH must be a positive integer (got: $DEPTH)" >&2
  exit 1
fi

# --------- styling ---------
BOLD="$(tput bold || true)"
DIM="$(tput dim || true)"
RESET="$(tput sgr0 || true)"
divider() { printf "\n%s\n" "────────────────────────────────────────────────────────────"; }

# --------- counters ---------
updated=0
skipped=0
failed=0
total=0

echo -e "🚀 ${BOLD}Scanning for Git repos (max depth: ${DEPTH})...${RESET}"

while IFS= read -r -d '' dir; do
  if [[ -d "$dir/.git" ]] || git -C "$dir" rev-parse --git-dir &>/dev/null; then
    ((total++)) || true
    repo="$dir"

    divider
    echo -e "📦 ${BOLD}${repo}${RESET}"

    remotes=$(git -C "$repo" remote -v 2>/dev/null | awk '!seen[$0]++')
    if [[ -n "${remotes}" ]]; then
      echo -e "🌐 Remotes:\n${DIM}${remotes}${RESET}"
    else
      echo -e "🌐 ${DIM}(no remotes configured)${RESET}"
    fi

    echo -e "⬇️  ${BOLD}git fetch --all --prune${RESET}"
    if ! git -C "$repo" fetch --all --prune; then
      echo -e "❌ ${BOLD}Fetch failed for${RESET} ${repo}"
      ((failed++)) || true
      continue
    fi

    current_branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")"
    if [[ "$current_branch" == "HEAD" || "$current_branch" == "DETACHED" ]]; then
      echo -e "⚠️  ${BOLD}Detached HEAD${RESET} — skipping pull (fetch already done)."
      ((skipped++)) || true
      continue
    fi

    echo -e "🔄 ${BOLD}git pull --rebase --autostash${RESET} (on ${current_branch})"
    if git -C "$repo" pull --rebase --autostash; then
      latest_commit="$(git -C "$repo" log --oneline -1 2>/dev/null || echo "(no commits)")"
      echo -e "✅ ${BOLD}Updated${RESET} ${repo} ${DIM}(${latest_commit})${RESET}"
      ((updated++)) || true
    else
      echo -e "❌ ${BOLD}Pull failed for${RESET} ${repo}"
      ((failed++)) || true
    fi
  fi
done < <(find . -mindepth 1 -maxdepth "$DEPTH" -type d -not -path '*/.git*' -print0)

divider
echo -e "📊 ${BOLD}Summary${RESET}"
echo -e "  📁 Repos found: ${total}"
echo -e "  ✅ Updated    : ${updated}"
echo -e "  ⚠️  Skipped     : ${skipped}"
echo -e "  ❌ Failed      : ${failed}"
divider
echo -e "🎉 ${BOLD}All done!${RESET}"

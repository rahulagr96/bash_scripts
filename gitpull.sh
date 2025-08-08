#!/usr/bin/env bash
# gitpull.sh — Fetch + Pull all top-level git repos here
# Usage: bash gitpull.sh
# Tip: make it executable once: chmod +x gitpull.sh && ./gitpull.sh

set -euo pipefail

# --------- styling ---------
BOLD="$(tput bold || true)"
DIM="$(tput dim || true)"
RESET="$(tput sgr0 || true)"

divider() { printf "\n%s\n" "────────────────────────────────────────────────────────────"; }

# --------- counters ---------
updated=0
skipped=0
failed=0

echo -e "🚀 ${BOLD}Scanning top-level directories for Git repos...${RESET}"

# Find top-level directories (no recursion). Works fine for:
# - (ignores gitpull.sh because it’s a file)
for d in */ ; do
  # Skip if not a directory for whatever reason
  [[ -d "$d" ]] || continue

  # Check if it's a git repo
  if [[ -d "${d}/.git" ]] || git -C "$d" rev-parse --git-dir &>/dev/null; then
    repo="${d%/}"
    divider
    echo -e "📦 ${BOLD}${repo}${RESET}"

    # Print remote info (visible but compact)
    remotes=$(git -C "$repo" remote -v 2>/dev/null | awk '!seen[$0]++')
    if [[ -n "${remotes}" ]]; then
      echo -e "🌐 Remotes:\n${DIM}${remotes}${RESET}"
    else
      echo -e "🌐 ${DIM}(no remotes configured)${RESET}"
    fi

    # Fetch all branches from all remotes
    echo -e "⬇️  ${BOLD}git fetch --all --prune${RESET}"
    if ! git -C "$repo" fetch --all --prune; then
      echo -e "❌ ${BOLD}Fetch failed for${RESET} ${repo}"
      ((failed++)) || true
      continue
    fi

    # Determine current branch (may be detached)
    current_branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")"
    if [[ "$current_branch" == "HEAD" || "$current_branch" == "DETACHED" ]]; then
      echo -e "⚠️  ${BOLD}Detached HEAD${RESET} — skipping pull (fetch already done)."
      ((skipped++)) || true
      continue
    fi

    # Pull for the current branch only (safe & expected)
    echo -e "🔄 ${BOLD}git pull --rebase --autostash${RESET} (on ${current_branch})"
    if git -C "$repo" pull --rebase --autostash; then
      # Show a compact post-update status
      latest_commit="$(git -C "$repo" log --oneline -1 2>/dev/null || echo "(no commits)")"
      echo -e "✅ ${BOLD}Updated${RESET} ${repo} ${DIM}(${latest_commit})${RESET}"
      ((updated++)) || true
    else
      echo -e "❌ ${BOLD}Pull failed for${RESET} ${repo}"
      ((failed++)) || true
    fi

  else
    # Not a git repo — skip quietly
    ((skipped++)) || true
  fi
done

divider
echo -e "📊 ${BOLD}Summary${RESET}"
echo -e "  ✅ Updated: ${updated}"
echo -e "  ⚠️  Skipped: ${skipped}"
echo -e "  ❌ Failed : ${failed}"
divider
echo -e "🎉 ${BOLD}All done!${RESET}"

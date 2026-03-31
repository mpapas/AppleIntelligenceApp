#!/bin/bash
set -euo pipefail

# Reset the AppleIntelligenceApp project for a fresh demo take.
# Usage: ./scripts/reset-for-take.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

INITIAL_COMMIT=$(git rev-list --max-parents=0 HEAD)

echo "=== Resetting to initial commit: $INITIAL_COMMIT ==="

# Reset to initial commit
git checkout main 2>/dev/null || true
git reset --hard "$INITIAL_COMMIT"

# Remove any Claude configuration
rm -rf .claude/
rm -f CLAUDE.md

# Clean untracked files (but preserve scripts/)
git clean -fd --exclude=scripts/

# Close any open PRs from prior takes
echo "=== Closing stale PRs ==="
gh pr list --state open --json number --jq '.[].number' | while read -r pr; do
    echo "Closing PR #$pr"
    gh pr close "$pr" --delete-branch 2>/dev/null || true
done

# Reopen issue #1 if it was closed
echo "=== Reopening issue #1 ==="
gh issue reopen 1 2>/dev/null || echo "Issue #1 already open"

# Force push to reset remote main
echo "=== Resetting remote main ==="
git push --force origin main

echo ""
echo "=== Ready for a fresh take ==="
echo "Project: $REPO_ROOT"
echo "Branch:  $(git branch --show-current)"
echo "Commit:  $(git log --oneline -1)"
echo "Issue:   $(gh issue view 1 --json state --jq '.state')"

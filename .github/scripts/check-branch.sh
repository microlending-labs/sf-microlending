#!/usr/bin/env bash
# Checks a pull request branch against the rules in CONTRIBUTING.md:
#   1. the name is <type>/<issue>-<slug> and the issue exists and is open;
#   2. the branch does not contain commits that came from `uat` (it was cut from `main`).
# Usage: check-branch.sh <branch-name> <head-sha>
# Needs: GH_TOKEN with issues:read, full git history with origin/main and origin/uat fetched.
set -euo pipefail

branch="$1"
head_sha="$2"
pattern='^(feature|fix|chore|docs)/([0-9]+)-[a-z0-9]+(-[a-z0-9]+)*$'

if [[ ! "$branch" =~ $pattern ]]; then
  echo "::error::Branch '$branch' does not match <type>/<issue>-<slug> (type: feature, fix, chore, docs). See CONTRIBUTING.md."
  exit 1
fi
issue="${BASH_REMATCH[2]}"

if ! state="$(gh issue view "$issue" --repo "$GITHUB_REPOSITORY" --json state --jq .state 2>/dev/null)"; then
  echo "::error::Issue #$issue from the branch name does not exist."
  exit 1
fi
if [[ "$state" != "OPEN" ]]; then
  echo "::error::Issue #$issue is $state. Branches must belong to an open issue."
  exit 1
fi
echo "Branch name OK, issue #$issue is open."

# Commits that `uat` has on its own first-parent line (merge commits of other pull requests) and `main` does not.
# If any of them is an ancestor of the branch, the branch was cut from `uat` or had `uat` merged into it.
bad=0
while read -r commit; do
  [[ -z "$commit" ]] && continue
  if git merge-base --is-ancestor "$commit" "$head_sha"; then
    echo "::error::The branch contains commit $(git log -1 --format='%h %s' "$commit") from 'uat'. Cut ticket branches from 'main' and never merge 'uat' into them."
    bad=1
    break
  fi
done < <(git rev-list --first-parent origin/main..origin/uat)

if [[ "$bad" -ne 0 ]]; then
  exit 1
fi
echo "Branch history OK: no commits from 'uat'."

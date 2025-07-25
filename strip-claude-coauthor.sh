#!/bin/bash

# Script to strip Claude co-author lines from commit messages on current branch
# Usage: ./strip-claude-coauthor.sh [base_branch] [--dry-run]

set -e

# Parse arguments
DRY_RUN=false
BASE_BRANCH_ARG=""

for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            if [ -z "$BASE_BRANCH_ARG" ]; then
                BASE_BRANCH_ARG="$arg"
            fi
            shift
            ;;
    esac
done

# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)

if [ -z "$CURRENT_BRANCH" ]; then
    echo "Error: Not on a branch (detached HEAD state)"
    exit 1
fi

echo "Current branch: $CURRENT_BRANCH"

# Function to get base branch from PR if exists
get_pr_base_branch() {
    local current_branch="$1"
    
    # Check if gh CLI is available
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) not found, skipping PR detection"
        return 1
    fi
    
    # Try to get PR info for current branch
    local pr_info
    if pr_info=$(gh pr view "$current_branch" --json baseRefName 2>/dev/null); then
        local base_ref
        base_ref=$(echo "$pr_info" | jq -r '.baseRefName')
        if [ "$base_ref" != "null" ] && [ -n "$base_ref" ]; then
            echo "origin/$base_ref"
            return 0
        fi
    fi
    
    return 1
}

# Determine base branch
if [ -n "$BASE_BRANCH_ARG" ]; then
    # Use provided base branch
    BASE_BRANCH="$BASE_BRANCH_ARG"
    echo "Using provided base branch: $BASE_BRANCH"
elif PR_BASE=$(get_pr_base_branch "$CURRENT_BRANCH"); then
    # Use base branch from PR
    BASE_BRANCH="$PR_BASE"
    echo "Detected PR base branch: $BASE_BRANCH"
else
    # Fallback to main/master detection
    if git show-ref --verify --quiet refs/remotes/origin/main; then
        BASE_BRANCH="origin/main"
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
        BASE_BRANCH="origin/master"
    else
        echo "Error: Could not find origin/main or origin/master"
        exit 1
    fi
    echo "Using fallback base branch: $BASE_BRANCH"
fi

MERGE_BASE=$(git merge-base $CURRENT_BRANCH $BASE_BRANCH)

if [ -z "$MERGE_BASE" ]; then
    echo "Error: Could not find merge base with $BASE_BRANCH"
    exit 1
fi

echo "Merge base: $MERGE_BASE"
echo "Base branch: $BASE_BRANCH"

# Check if there are any commits to rewrite
COMMIT_COUNT=$(git rev-list --count $MERGE_BASE..$CURRENT_BRANCH)

if [ "$COMMIT_COUNT" -eq 0 ]; then
    echo "No commits to rewrite on current branch"
    exit 0
fi

echo "Found $COMMIT_COUNT commits to process"

# Show detailed commit information
echo ""
echo "=== COMMITS TO BE MODIFIED ==="
git log --oneline --no-merges $MERGE_BASE..$CURRENT_BRANCH

# Check which commits actually contain Claude co-author lines
echo ""
echo "=== COMMITS WITH CLAUDE CO-AUTHOR LINES ==="
CLAUDE_COMMITS=0
while IFS= read -r commit_hash; do
    commit_msg=$(git log --format=%B -n 1 "$commit_hash")
    if echo "$commit_msg" | grep -q -E "(🤖 Generated with \[Claude Code\]|Co-Authored-By: Claude|Co-authored-by: Claude)"; then
        echo "$commit_hash $(git log --format=%s -n 1 "$commit_hash")"
        CLAUDE_COMMITS=$((CLAUDE_COMMITS + 1))
    fi
done < <(git rev-list --no-merges $MERGE_BASE..$CURRENT_BRANCH)

echo ""
echo "=== SUMMARY ==="
echo "Current branch: $CURRENT_BRANCH"
echo "Base branch: $BASE_BRANCH"
echo "Merge base: $MERGE_BASE"
echo "Total commits on branch: $COMMIT_COUNT"
echo "Commits with Claude co-author lines: $CLAUDE_COMMITS"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "🔍 DRY RUN MODE - No changes will be made"
    echo "To actually strip Claude co-author lines, run without --dry-run flag"
    exit 0
fi

# Check for unstaged changes
if ! git diff-index --quiet HEAD --; then
    echo "Stashing unstaged changes..."
    git stash push -m "Auto-stash before stripping Claude co-author"
    STASHED=true
else
    STASHED=false
fi

# Remove any existing filter-branch backup
if git show-ref --verify --quiet refs/original/refs/heads/$CURRENT_BRANCH; then
    echo "Removing existing backup..."
    git update-ref -d refs/original/refs/heads/$CURRENT_BRANCH
fi

# Run filter-branch to strip Claude co-author lines
echo "Rewriting commit messages..."
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter '
    sed "/🤖 Generated with \\[Claude Code\\]/d; /Co-Authored-By: Claude/d; /Co-authored-by: Claude/d"
' $MERGE_BASE..$CURRENT_BRANCH

echo "Successfully stripped Claude co-author lines from $COMMIT_COUNT commits"

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    git stash pop
fi

echo "Done! Use 'git push --force-with-lease origin $CURRENT_BRANCH' to update remote"

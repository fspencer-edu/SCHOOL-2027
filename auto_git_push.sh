#!/bin/bash

# ============================================================
# SCHOOL-2027 automatic GitHub backup
# ============================================================

REPO="/Users/fiona_spencer/Documents/Obsidian/School-2027"
GITHUB_USER="fspencer-edu"
BRANCH="master"

LOG="$REPO/auto_git_push.log"

echo "============================================================" >> "$LOG"
echo "Backup started: $(date)" >> "$LOG"

# Go to repository
cd "$REPO" || {
    echo "ERROR: Could not enter $REPO" >> "$LOG"
    exit 1
}

# Make sure Homebrew / gh / git are available when launchd runs
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# ------------------------------------------------------------
# 1. Switch GitHub CLI account
# ------------------------------------------------------------

echo "Switching GitHub account to $GITHUB_USER..." >> "$LOG"

gh auth switch --user "$GITHUB_USER" >> "$LOG" 2>&1

if [ $? -ne 0 ]; then
    echo "ERROR: Could not switch GitHub account." >> "$LOG"
    exit 1
fi

# Ensure Git uses gh authentication
gh auth setup-git >> "$LOG" 2>&1

# ------------------------------------------------------------
# 2. Run image organization script
# ------------------------------------------------------------

echo "Running move_images.sh..." >> "$LOG"

if [ -f "$REPO/move_images.sh" ]; then
    chmod +x "$REPO/move_images.sh"
    "$REPO/move_images.sh" >> "$LOG" 2>&1
else
    echo "WARNING: move_images.sh not found." >> "$LOG"
fi

# ------------------------------------------------------------
# 3. Make sure we're on master
# ------------------------------------------------------------

CURRENT_BRANCH=$(git branch --show-current)

if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    echo "Currently on $CURRENT_BRANCH; switching to $BRANCH..." >> "$LOG"

    git switch "$BRANCH" >> "$LOG" 2>&1

    if [ $? -ne 0 ]; then
        echo "ERROR: Could not switch to $BRANCH." >> "$LOG"
        exit 1
    fi
fi

# ------------------------------------------------------------
# 4. Pull latest version
# ------------------------------------------------------------

echo "Pulling latest changes..." >> "$LOG"

git pull --rebase origin "$BRANCH" >> "$LOG" 2>&1

if [ $? -ne 0 ]; then
    echo "ERROR: git pull failed. Not pushing." >> "$LOG"
    exit 1
fi

# ------------------------------------------------------------
# 5. Stage changes
# ------------------------------------------------------------

git add -A

# Stop if there is nothing new
if git diff --cached --quiet; then
    echo "No changes to commit." >> "$LOG"
    echo "Finished: $(date)" >> "$LOG"
    exit 0
fi

# ------------------------------------------------------------
# 6. Commit
# ------------------------------------------------------------

COMMIT_MESSAGE="Automatic Obsidian backup $(date '+%Y-%m-%d %H:%M')"

echo "Creating commit: $COMMIT_MESSAGE" >> "$LOG"

git commit -m "$COMMIT_MESSAGE" >> "$LOG" 2>&1

if [ $? -ne 0 ]; then
    echo "ERROR: git commit failed." >> "$LOG"
    exit 1
fi

# ------------------------------------------------------------
# 7. Push
# ------------------------------------------------------------

echo "Pushing to GitHub..." >> "$LOG"

git push origin "$BRANCH" >> "$LOG" 2>&1

if [ $? -eq 0 ]; then
    echo "SUCCESS: Backup pushed." >> "$LOG"
else
    echo "ERROR: Git push failed." >> "$LOG"
    exit 1
fi

echo "Finished: $(date)" >> "$LOG"

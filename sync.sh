#!/bin/bash

cd "$(dirname "$0")"
[ -f ~/.local_envvars.sh ] && source ~/.local_envvars.sh

SRC="$ARCH_REC_VAULT"
DST="$ARCH_REC_REPO"

# Sync only files listed in .published
while IFS= read -r entry; do
    [ -z "$entry" ] && continue
    if [ -d "$SRC/$entry" ]; then
        rsync -a "$SRC/$entry/" "$DST/$entry/"
    elif [ -f "$SRC/$entry" ]; then
        rsync -a "$SRC/$entry" "$DST/$entry"
    fi
done < "$SRC/_published.md"

# Remove tracked files that are no longer in _published.md
KEEP_FILES=$(grep -v '^$' "$SRC/_published.md")
for tracked in $(git ls-files); do
    # Skip special files
    [[ "$tracked" == "sync.sh" || "$tracked" == ".gitignore" ]] && continue
    # Check if tracked file (or its parent dir) is in the published list
    found=false
    while IFS= read -r entry; do
        [ -z "$entry" ] && continue
        if [[ "$tracked" == "$entry" || "$tracked" == "$entry/"* ]]; then
            found=true
            break
        fi
    done <<< "$KEEP_FILES"
    if ! $found; then
        git rm -q "$tracked" 2>/dev/null
    fi
done

# Check for new untracked files
NEW_FILES=$(git ls-files --others --exclude-standard)

if [ -n "$NEW_FILES" ]; then
    if [ "$1" = "--non-interactive" ]; then
        echo "New files detected — run interactive sync to review:"
        echo "$NEW_FILES"
        exit 1
    else
        echo "New untracked files:"
        echo "$NEW_FILES"
        echo ""
        read -p "Add and commit these new files? (y/n) " answer
        [ "$answer" = "y" ] && git add $NEW_FILES
    fi
fi

# Get the list of modified tracked files
MODIFIED_FILES=$(git diff --name-only HEAD)

if [ -z "$MODIFIED_FILES" ] && [ -z "$(git diff --name-only --cached HEAD)" ]; then
    echo "No changes to commit."
    exit 0
fi

git add -A
if [ "$1" = "--non-interactive" ]; then
    echo "Changed: $MODIFIED_FILES"
    git commit -m "update" --quiet
    git push --quiet
    echo "Pushed."
else
    git --no-pager diff --stat HEAD
    echo ""
    read -p "Commit and push? (y/n) " answer
    if [ "$answer" = "y" ]; then
        git commit -m "update"
        git push
    fi
fi

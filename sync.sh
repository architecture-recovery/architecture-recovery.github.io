#!/bin/bash

cd "$(dirname "$0")"
[ -f ~/.local_envvars.sh ] && source ~/.local_envvars.sh

SRC="$ARCH_REC_IN_MEGAVAULT"
DST="$ARCH_REC_IN_GH_FOLDER"

# Sync only files listed in .published
while IFS= read -r entry; do
    [ -z "$entry" ] && continue
    if [ -d "$SRC/$entry" ]; then
        rsync -a "$SRC/$entry/" "$DST/$entry/"
    elif [ -f "$SRC/$entry" ]; then
        rsync -a "$SRC/$entry" "$DST/$entry"
    fi
done < "$SRC/.published"

# Check for new untracked files
NEW_FILES=$(git ls-files --others --exclude-standard)

if [ -n "$NEW_FILES" ]; then
    if [ "$1" = "--yes" ]; then
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

if [ "$1" = "--yes" ]; then
    echo "Changed: $MODIFIED_FILES"
    git commit -am "update" --quiet
    git push --quiet
    echo "Pushed."
else
    echo "Modified files:"
    echo "$MODIFIED_FILES"
    echo ""
    read -p "Commit and push? (y/n) " answer
    if [ "$answer" = "y" ]; then
        git commit -am "update"
        git push
    fi
fi

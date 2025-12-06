#!/bin/bash
# GENESIS v2.0 Session End Hook
# Saves state, performs cleanup

set -e

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
GENESIS_DIR="$PROJECT_DIR/.genesis"

echo "GENESIS v2.0 Session Ending..."
echo "========================================"

# Save session timestamp
if [ -d "$GENESIS_DIR/core" ]; then
    echo "{\"last_session\": \"$(date -Iseconds)\"}" > "$GENESIS_DIR/core/session-info.json" 2>/dev/null || true
fi

# Check for uncommitted work
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$UNCOMMITTED" -gt 0 ]; then
        echo "Warning: $UNCOMMITTED uncommitted files"
    fi
fi

echo "Session ended successfully."
echo "========================================"

exit 0

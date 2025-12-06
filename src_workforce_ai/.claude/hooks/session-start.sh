#!/bin/bash
# GENESIS v2.0 Session Start Hook
# Loads context, validates state, prepares environment

set -e

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
GENESIS_DIR="$PROJECT_DIR/.genesis"
CLAUDE_DIR="$PROJECT_DIR/.claude"

echo "GENESIS v2.0 Session Initializing..."
echo "========================================"

# Validate directory structure
if [ ! -d "$GENESIS_DIR" ]; then
    echo "Warning: .genesis directory not found. Run initialization."
fi

# Load and display project state
if [ -f "$GENESIS_DIR/core/project-state.json" ]; then
    PROJECT_NAME=$(jq -r '.project.name // "Unnamed"' "$GENESIS_DIR/core/project-state.json" 2>/dev/null || echo "Unnamed")
    PROJECT_TYPE=$(jq -r '.project.type // "unknown"' "$GENESIS_DIR/core/project-state.json" 2>/dev/null || echo "unknown")
    SPRINT=$(jq -r '.sprint.number // "N/A"' "$GENESIS_DIR/core/project-state.json" 2>/dev/null || echo "N/A")
    echo "Project: $PROJECT_NAME ($PROJECT_TYPE)"
    echo "Sprint: $SPRINT"
fi

# Check for active blockers
if [ -f "$GENESIS_DIR/core/project-state.json" ]; then
    BLOCKERS=$(jq -r '.features.active[]? | select(.blockers | length > 0) | .name' "$GENESIS_DIR/core/project-state.json" 2>/dev/null || true)
    if [ -n "$BLOCKERS" ]; then
        echo "BLOCKERS DETECTED:"
        echo "$BLOCKERS" | while read -r blocker; do
            [ -n "$blocker" ] && echo "   - $blocker"
        done
    fi
fi

# Learning system reminder
echo ""
echo "LEARNING SYSTEM ACTIVE"
echo "   Before any task, review:"
GENERAL_COUNT=$(grep -c "^### \[" "$CLAUDE_DIR/learning/knowledge-base/general-mistakes.md" 2>/dev/null || echo "0")
PROJECT_COUNT=$(grep -c "^### \[" "$CLAUDE_DIR/learning/knowledge-base/project-mistakes.md" 2>/dev/null || echo "0")
PATTERN_COUNT=$(grep -c "^### " "$CLAUDE_DIR/learning/knowledge-base/patterns.md" 2>/dev/null || echo "0")
echo "   - General learnings: $GENERAL_COUNT entries"
echo "   - Project learnings: $PROJECT_COUNT entries"
echo "   - Patterns: $PATTERN_COUNT entries"

# Git status
echo ""
echo "Repository Status:"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    echo "   Branch: $BRANCH"
    echo "   Uncommitted changes: $CHANGES"
else
    echo "   (Not a git repository)"
fi

# Check pending communications
if [ -f "$GENESIS_DIR/communication/message-queue.json" ]; then
    PENDING=$(jq -r '[.[]? | select(.status == "pending")] | length' "$GENESIS_DIR/communication/message-queue.json" 2>/dev/null || echo "0")
    if [ "$PENDING" -gt 0 ]; then
        echo ""
        echo "Pending communications: $PENDING"
    fi
fi

echo ""
echo "========================================"
echo "Session initialized. Ready for commands."

exit 0

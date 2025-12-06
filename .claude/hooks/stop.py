#!/usr/bin/env python3
"""
GENESIS v2.0 Stop Hook
Final quality gate before session ends
"""

import json
import sys
import os
import subprocess
from pathlib import Path

def load_input():
    try:
        return json.load(sys.stdin)
    except:
        return {}

def check_uncommitted_changes() -> list:
    """Check for uncommitted changes"""
    issues = []

    try:
        result = subprocess.run(
            ["git", "status", "--porcelain"],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.stdout.strip():
            issues.append(f"Uncommitted changes detected ({len(result.stdout.strip().splitlines())} files)")
    except Exception:
        pass

    return issues

def check_test_status() -> list:
    """Check if tests were run"""
    issues = []

    genesis_dir = Path(os.environ.get("CLAUDE_PROJECT_DIR", ".")) / ".genesis"
    metrics_path = genesis_dir / "observability/metrics/test-results.json"

    if metrics_path.exists():
        try:
            with open(metrics_path) as f:
                metrics = json.load(f)
            if metrics.get("last_run"):
                if metrics.get("failed", 0) > 0:
                    issues.append(f"{metrics['failed']} tests failing")
        except Exception:
            pass

    return issues

def check_blockers() -> list:
    """Check for unresolved blockers"""
    issues = []

    genesis_dir = Path(os.environ.get("CLAUDE_PROJECT_DIR", ".")) / ".genesis"
    state_path = genesis_dir / "core/project-state.json"

    if state_path.exists():
        try:
            with open(state_path) as f:
                state = json.load(f)
            for feature in state.get("features", {}).get("active", []):
                if feature.get("blockers"):
                    issues.append(f"Blocker on {feature['name']}: {feature['blockers'][0]}")
        except Exception:
            pass

    return issues

def main():
    input_data = load_input()

    print("Running GENESIS Quality Gates...")
    print("-" * 40)

    all_issues = []

    # Run all checks
    all_issues.extend(check_uncommitted_changes())
    all_issues.extend(check_test_status())
    all_issues.extend(check_blockers())

    if all_issues:
        print("\nIssues detected before session end:")
        for issue in all_issues:
            print(f"   - {issue}")
        print("\nConsider addressing these before ending.")
    else:
        print("All quality gates passed")

    print("-" * 40)

    sys.exit(0)

if __name__ == "__main__":
    main()

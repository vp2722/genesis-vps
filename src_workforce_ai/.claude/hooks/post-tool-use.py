#!/usr/bin/env python3
"""
GENESIS v2.0 Post-Tool Use Hook
Validates outputs, runs quality checks, updates state
"""

import json
import sys
import os
import subprocess
from pathlib import Path

def load_input():
    """Load tool response from stdin"""
    try:
        return json.load(sys.stdin)
    except json.JSONDecodeError:
        return {}

def run_lint_check(file_path: str) -> tuple:
    """Run linting on the modified file"""

    ext = Path(file_path).suffix

    lint_commands = {
        ".py": ["python3", "-m", "py_compile", file_path],
        ".json": ["python3", "-m", "json.tool", file_path],
    }

    if ext in lint_commands:
        try:
            result = subprocess.run(
                lint_commands[ext],
                capture_output=True,
                text=True,
                timeout=30
            )
            if result.returncode != 0:
                return False, result.stderr or result.stdout
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass

    return True, ""

def check_security_patterns(file_path: str, content: str) -> list:
    """Check for security anti-patterns"""

    warnings = []

    security_patterns = [
        ("password =", "Potential hardcoded password"),
        ("api_key =", "Potential hardcoded API key"),
        ("secret =", "Potential hardcoded secret"),
        ("eval(", "Dangerous eval() usage"),
        ("exec(", "Dangerous exec() usage"),
    ]

    content_lower = content.lower()
    for pattern, warning in security_patterns:
        if pattern.lower() in content_lower:
            # Skip if in comments or test files
            if "test" not in file_path.lower():
                warnings.append(f"Warning: {warning} in {file_path}")

    return warnings

def update_metrics(tool_name: str, success: bool):
    """Update tool usage metrics"""

    metrics_path = Path(os.environ.get("CLAUDE_PROJECT_DIR", ".")) / ".genesis/observability/metrics/tool-usage.json"

    try:
        if metrics_path.exists():
            with open(metrics_path) as f:
                metrics = json.load(f)
        else:
            metrics = {"tools": {}}

        if tool_name not in metrics["tools"]:
            metrics["tools"][tool_name] = {"success": 0, "failure": 0}

        if success:
            metrics["tools"][tool_name]["success"] += 1
        else:
            metrics["tools"][tool_name]["failure"] += 1

        metrics_path.parent.mkdir(parents=True, exist_ok=True)
        with open(metrics_path, "w") as f:
            json.dump(metrics, f, indent=2)
    except Exception:
        pass

def main():
    input_data = load_input()
    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})
    tool_response = input_data.get("tool_response", {})

    context_additions = []

    # For file write operations, run quality checks
    if tool_name in ["Write", "Edit", "MultiEdit"]:
        file_path = tool_input.get("file_path", "") or tool_input.get("path", "")

        if file_path and os.path.exists(file_path):
            # Run lint check
            lint_ok, lint_error = run_lint_check(file_path)
            if not lint_ok:
                context_additions.append(f"Lint error in {file_path}: {lint_error[:200]}")

            # Run security check
            try:
                with open(file_path) as f:
                    content = f.read()
                security_warnings = check_security_patterns(file_path, content)
                context_additions.extend(security_warnings)
            except Exception:
                pass

    # Update metrics
    success = tool_response.get("error") is None
    update_metrics(tool_name, success)

    # Output context if any issues found
    if context_additions:
        for warning in context_additions:
            print(warning, file=sys.stderr)

    sys.exit(0)

if __name__ == "__main__":
    main()

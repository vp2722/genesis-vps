#!/usr/bin/env python3
"""
GENESIS v2.0 Pre-Tool Use Hook
Validates tool usage, blocks dangerous operations, injects modifications
"""

import json
import sys
import os
from pathlib import Path

def load_input():
    """Load tool input from stdin"""
    try:
        return json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

def check_dangerous_commands(tool_name: str, tool_input: dict) -> tuple:
    """Check for dangerous commands that should be blocked"""

    dangerous_patterns = [
        # Destructive file operations
        ("rm -rf /", "Blocked: Recursive delete of root"),
        ("rm -rf ~", "Blocked: Recursive delete of home"),
        ("rm -rf /*", "Blocked: Wildcard delete of root"),
        ("> /dev/sda", "Blocked: Direct disk write"),
        ("mkfs", "Blocked: Filesystem formatting"),
        ("dd if=", "Blocked: Direct disk operations"),

        # Sensitive file access
        ("/etc/shadow", "Blocked: Accessing shadow file"),

        # Network risks
        ("curl | bash", "Blocked: Remote code execution"),
        ("wget | sh", "Blocked: Remote code execution"),
    ]

    if tool_name == "Bash":
        command = tool_input.get("command", "")
        for pattern, message in dangerous_patterns:
            if pattern in command:
                if message.startswith("Blocked"):
                    return False, message

    return True, ""

def check_file_permissions(tool_name: str, tool_input: dict) -> tuple:
    """Check file access permissions"""

    protected_paths = [
        ".env",
        ".git/config",
        "secrets/",
        "credentials/",
    ]

    if tool_name in ["Write", "Edit", "Read"]:
        file_path = tool_input.get("file_path", "") or tool_input.get("path", "")
        for protected in protected_paths:
            if protected in file_path and "template" not in file_path.lower():
                return False, f"Protected path: {protected}"

    return True, ""

def main():
    input_data = load_input()
    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})

    # Check for dangerous commands
    allowed, message = check_dangerous_commands(tool_name, tool_input)
    if not allowed:
        output = {
            "decision": "deny",
            "reason": message
        }
        print(json.dumps(output))
        sys.exit(2)

    # Check file permissions
    allowed, message = check_file_permissions(tool_name, tool_input)
    if not allowed:
        output = {
            "decision": "deny",
            "reason": message
        }
        print(json.dumps(output))
        sys.exit(2)

    # Default: allow
    sys.exit(0)

if __name__ == "__main__":
    main()

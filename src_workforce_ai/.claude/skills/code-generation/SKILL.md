---
name: code-generation
description: Generates production-ready code following project patterns and standards
trigger_patterns: ["create", "implement", "build", "code", "write function", "write class"]
---

# Code Generation Skill

## Capability
Generate production-ready code that follows project patterns, coding standards, and best practices.

## Before Generating Code

1. Check `.claude/learning/knowledge-base/patterns.md` for established patterns
2. Check `.claude/learning/knowledge-base/anti-patterns.md` for things to avoid
3. Review existing code in the same module for consistency
4. Identify the appropriate agent (Frontend Lead, Backend Lead, etc.)

## Code Standards

### General
- Clear, descriptive naming
- Single responsibility principle
- DRY (Don't Repeat Yourself)
- Proper error handling
- Comprehensive logging
- Type annotations where applicable

### Documentation
Every function/method must have:
- Description of purpose
- Parameter descriptions
- Return value description
- Exception documentation

### Testing
Every new function must have:
- Unit tests covering happy path
- Unit tests covering edge cases
- Unit tests covering error conditions

## Post-Generation Checklist

- [ ] Code compiles/parses without errors
- [ ] Follows existing patterns in codebase
- [ ] Has appropriate error handling
- [ ] Has logging at appropriate levels
- [ ] Has unit tests
- [ ] Has documentation
- [ ] No security anti-patterns
- [ ] No hardcoded secrets/credentials

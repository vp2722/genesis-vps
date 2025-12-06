---
name: testing-automation
description: Creates and maintains automated tests
trigger_patterns: ["test", "coverage", "assertion", "mock", "fixture"]
---

# Testing Automation Skill

## Capability
Create comprehensive automated tests including unit, integration, and end-to-end tests.

## Test Pyramid
- Unit tests: 70% (fast, isolated)
- Integration tests: 20% (component interaction)
- E2E tests: 10% (critical user paths)

## Best Practices
- Test behavior, not implementation
- One assertion per test (ideally)
- Use descriptive test names
- Setup and teardown properly
- Mock external dependencies
- Use fixtures for test data

## Coverage Targets
- Line coverage: >80%
- Branch coverage: >75%
- Critical paths: 100%

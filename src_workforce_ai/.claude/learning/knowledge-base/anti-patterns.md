# Anti-Patterns to Avoid

This file contains patterns that should be avoided.

---

### Hardcoded Secrets
**Category**: security
**Severity**: critical

**Description**: Never hardcode secrets, API keys, or credentials in code.

**Why It's Bad**: Exposes sensitive data, violates security best practices.

**Alternative**: Use environment variables or secret management systems.

---

### N+1 Query Problem
**Category**: performance
**Severity**: high

**Description**: Making N additional database queries for N related records.

**Why It's Bad**: Causes severe performance degradation at scale.

**Alternative**: Use eager loading, batch queries, or data loaders.

---

### God Objects/Classes
**Category**: architecture
**Severity**: medium

**Description**: Classes that try to do too much and know too much.

**Why It's Bad**: Violates single responsibility, hard to maintain and test.

**Alternative**: Split into focused, single-purpose classes.

---

<!-- New entries will be added above this line -->

---
description: Capture a successful pattern to the learning system
---

# Learn Command

Capture a successful pattern or technique for future reference.

## Usage
```
/learn <description>
```

## Process
1. Describe the successful pattern
2. Document the context and use case
3. Add to patterns.md in knowledge base
4. Index for future retrieval

## Output
Create an entry in `.claude/learning/knowledge-base/patterns.md`:

```markdown
### [DATE] - {Title}
**Category**: {architecture|code|testing|deployment|security|process}
**Confidence**: confirmed
**Usage Count**: 1

**Pattern Description**:
{description}

**When to Use**:
{context}

**Example**:
{concrete example}

---
```

Acknowledge the pattern has been captured and will be applied in future tasks.

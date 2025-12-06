---
description: Log a cross-project learning from a mistake
---

# General Mistake Command

Log a learning from a mistake that applies across all projects.

## Usage
```
/generalmistake <description>
```

## Process
1. Analyze the mistake
2. Identify root cause
3. Define prevention strategy
4. Add to general-mistakes.md

## Output
Create an entry in `.claude/learning/knowledge-base/general-mistakes.md`:

```markdown
### [DATE] - {Title}
**Category**: {architecture|code|testing|deployment|security|process}
**Severity**: {critical|high|medium|low}
**Confidence**: confirmed

**What went wrong**:
{description}

**Root cause**:
{analysis}

**Lesson learned**:
{lesson}

**Prevention strategy**:
- {action1}
- {action2}

**Example**:
{concrete example}

---
```

Confirm the learning has been captured for future prevention.

---
description: Log a project-specific learning from a mistake
---

# Project Mistake Command

Log a learning from a mistake specific to this project.

## Usage
```
/projectmistake <description>
```

## Process
1. Analyze the mistake in project context
2. Identify root cause
3. Define prevention strategy
4. Add to project-mistakes.md

## Output
Create an entry in `.claude/learning/knowledge-base/project-mistakes.md`:

```markdown
### [DATE] - {Title}
**Category**: {architecture|code|testing|deployment|security|process}
**Severity**: {critical|high|medium|low}
**Project-specific**: Yes

**What went wrong**:
{description}

**Root cause**:
{analysis}

**Lesson learned**:
{lesson}

**Prevention strategy**:
- {action1}
- {action2}

---
```

Confirm the learning has been captured.

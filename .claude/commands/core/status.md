---
description: Show current project and sprint status
---

# Status Command

Display comprehensive project and sprint status.

## Usage
```
/status
```

## Output
Display:
1. Project information from `.genesis/core/project-state.json`
2. Current sprint status
3. Active features and progress
4. Blockers
5. Recent decisions
6. Team capacity
7. Quality metrics
8. Upcoming deadlines

## Format
```
PROJECT STATUS
==============
Project: {name} ({type})
Status: {status}

SPRINT {number}
===============
Duration: {start} - {end}
Progress: {completed}/{committed} points ({percent}%)
Goals:
  - {goal1}
  - {goal2}

ACTIVE FEATURES
===============
{feature1}: {progress}% - {status}
{feature2}: {progress}% - {status}

BLOCKERS
========
- {blocker1}

METRICS
=======
Velocity: {velocity}
Bug rate: {bugs}
Coverage: {coverage}%
```

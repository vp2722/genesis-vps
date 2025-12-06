---
description: Run prioritization exercise using RICE scoring
---

# Prioritize Command

Prioritize backlog items using RICE scoring.

## Usage
```
/prioritize
```

## RICE Scoring
For each item calculate:
- **R**each: Users affected (1-10)
- **I**mpact: Behavior change (0.25-3)
- **C**onfidence: How sure (0.5-1.0)
- **E**ffort: Person-months

Score = (R x I x C) / E

## Output
Sorted list with RICE scores and recommended priority order.

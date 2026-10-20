# {{PROJECT_NAME}} — Code Style

Condensed from Clean Code (Robert C. Martin), adapted for this codebase; language-specific sections assume the default TS/React stack and are swapped per project. Reviewers (human and agent) cite this doc by section. It complements [dev-guidelines.md](dev-guidelines.md).

## Naming
- Classes/components/types: nouns with single responsibility. No generic suffixes (*Manager, *Processor, *Utility, MyFunctions).
- Functions: verbs expressing intent. No "And"/"Or"/"If" in a name — it means the function does more than one thing; split it.
- No side effects hidden behind a name (checkPassword must never log out).
- No abbreviations. Booleans read as questions: is/has/should/can. Symmetrical pairs: on/off, min/max, open/close.
- Constants for every magic number and threshold.

## Conditionals
- Compare booleans implicitly: `if (isLoggedIn)`, never `=== true`. Assign directly: `const isAdult = age > 18`.
- No double negatives. Extract complex conditions into named variables or predicates.
- Ternaries for simple either/or only — never nested.
- **String literal unions over enums** (`type Role = 'coach' | 'client'`) — TS adaptation; matches our DB check constraints.
- Prefer declarative (map/filter/reduce) over imperative loops when it reads better.
- Table-driven logic (lookup objects) over long if/else or switch chains.

## Functions
- 0–2 parameters; need more → pass a named options object.
- No flag/boolean arguments — split into two functions.
- Fail fast, return early; extract methods instead of indenting (max 4 nesting levels, house rule).
- Single responsibility; **< 50 lines** (house rule, stricter than the book's 100).
- Initialize variables just-in-time, closest to use.

## Classes / Modules
- High cohesion; related functions adjacent (proximity principle). Collapsed file reads like an outline.
- Avoid primitive obsession: name domain shapes (`Membership`, `CheckIn`) instead of loose strings/numbers.
- Files: 200–400 lines typical, 800 max (house rule). Split by feature, not by type.

## Comments
Allowed: TODO with issue ref, genuine summaries where code cannot express intent, doc/spec references (e.g. "Phase 3 B3").
Forbidden: redundant restating of code, intent comments (express in code), apologies/warnings, zombie (commented-out) code, divider/brace-tracker comments, bloated headers, defect logs.

## General
- DRY — but only for real duplication, not speculative abstraction (YAGNI).
- Self-documenting code over comments; maximize signal-to-noise.
- Immutability by default: return new objects, never mutate inputs.
- No console.log in production code; errors surface via the analytics/error layer.

## Comments & naming addenda

- A workaround comment carries an owner and a review date, or it does not ship.
- Comments explain WHY (a constraint, business rule, or security boundary) - never what the next line does.
- Banned names when a more precise term exists: `data`, `item`, `thing`, `helper`, `manager`, and `utils` as a dumping ground.
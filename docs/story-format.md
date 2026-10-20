# {{PROJECT_NAME}} — Epic & Story Format

How Omar (Senior PM, `docs/team.md`) writes the backlog. Output = GitHub issues (labels `team/*`, `epic/*`, `priority/*`; milestones M1–M3). The bar: an implementing engineer or agent can estimate and build **without coming back to Product** — while keeping ceremony proportional to risk.

## 1. Two tiers (Advisor ruling — preserved)

> Writing full Given/When/Then for trivial stories is ceremony, not quality.

| Tier | When | Weight |
|---|---|---|
| **Flagship** | Risky or novel functionality | Full format (§3) |
| **Compact** | Routine CRUD on known tables | 1–3 lines (§4) |

A story **escalates to flagship** if ANY of these apply:

- Calls an external integration (SMS, payments, push, OG worker, any third-party API)
- Has a status machine (≥3 states, or any approval/pending step)
- Crosses a permission or tenancy boundary (new tenancy policy, new role behavior)
- Ships a new migration or touches auth/storage rules
- Moves money or handles PDPL-sensitive data
- Novel UX with no existing pattern in the app

Everything else stays compact. Do not gold-plate CRUD.

## 2. Epic structure

The backlog opens with an **epic map**: ASCII dependency arrows between epics plus the epic → milestone mapping (see `docs/phase-4-backlog.md` for the live example). Each epic then carries:

- **Description** — one paragraph, what this epic delivers.
- **Current Situation** — how the process works today: current workflow, manual activities, pain points, operational limitations, missing automation.
- **Future Situation** — how it works after implementation: automated workflow, business improvements, integrations, operational efficiencies, expected business outcome.
- **Technical tasks** — epic-level work that isn't a user story (scaffolding, harnesses, pipelines).
- **Dependencies** — which epics must land first.
- **DoD** — required for technical epics (e.g. E0): one observable end-to-end proof.

## 3. Flagship story format

### 3.1 Header — traceability (mandatory)

```
Traces: FR-x · tables/endpoints: <Phase 3 refs> · Priority: P0/P1 · Size: <set by FE/BE leads>
```

Priorities inherit Phase 2. A story with no FR trace is either an `[ASSUMPTION]` (§3.3) or doesn't belong in the backlog.

### 3.2 Full Story — the WHY (short)

A standard Agile user story, then a short narrative covering: business objective, actors involved, end-to-end workflow, and the business rules that govern it.

**The Full Story is context, not the behavior spec.** Do not enumerate system behaviors here that the Scenarios will restate — two normative statements of the same behavior always drift. Scenarios (§3.3) are the single source of truth for WHAT the system does; the Full Story explains WHY and sketches the flow.

### 3.3 Scenarios — the normative WHAT

Every flagship story includes Given → When → Then scenarios. They are derived from a **coverage matrix**, not free generation:

```
actors × status transitions × integration outcomes (success / failure / timeout) × validation failures
```

Cover every cell that is a real business path: happy paths, validation rejections, permission denials, integration failures and retries, alternate flows, edge cases. Stop when the matrix is covered — "keep generating until it feels complete" is not a stop condition.

Each Then-step must be traceable to a confirmed requirement (phase docs, founder ruling, existing code) **or** carry the assumption tag:

> **`[ASSUMPTION]` rule:** any behavior Omar invents to fill a gap (a lockout duration, a retry policy, a default limit) is tagged `[ASSUMPTION]` inline and repeated in an **Assumptions** list at the bottom of the issue for founder review. Assumptions never ship silently as requirements.

### 3.4 UI Requirements (when applicable)

If the story needs a page, form, modal, wizard, table, or dashboard, define its **data contract and behavior — not visual layout**. Layout, spacing, and visual styling belong to Reem's design system (the project's design tokens); duplicating them here creates drift.

**Forms** — one row per field:

| Field | Type | Mandatory | Validation | Source |
|---|---|---|---|---|
| Outbound Type | Dropdown | Yes | Import / Export / Re-Export | Static list |
| Gross Weight | Number | Yes | > 0 | User input |

Plus: read-only vs editable fields, auto-populated fields, default values, lookup sources, conditional visibility, conditional validations.

**Tables / grids** — one row per column:

| Column | Search | Sort | Filter |
|---|---|---|---|
| Status | ✔ | ✔ | ✔ |

Plus: row actions, bulk actions, pagination, default sorting, empty state, loading state, export capability, status badges.

**Dashboards**: KPI cards, charts, widgets, quick actions, filters, summary sections.

All user-facing copy ships AR + EN; layout must survive RTL (hard rule — CSS logical properties only).

### 3.5 Considerations

Implementation notes, constraints, and reuse directives Engineering must keep in mind: RBAC, audit logging, security, notifications, reporting, accessibility, mobile responsiveness, PDPL/compliance, localization, dependencies, future extensibility. Two rules:

- **Reuse before build**: name the existing service/API to extend (e.g. "reuse Notification Service", "extend gatepass API, don't duplicate").
- **Performance criteria are numbers, not adjectives**: "roster loads <1s at 50 clients", never "should be fast".

### 3.6 Out of Scope (mandatory)

What this story deliberately does NOT do, and where deferred behavior lives (story ID or "future milestone"). The cheapest scope-creep prevention there is.

### 3.7 Technical subtasks

Every flagship story auto-generates subtasks in lanes:

- **[FE]** — page/modal/form/table build, client-side validation, API integration, loading/error/empty states, success notifications, responsive + RTL, unit tests.
- **[BE]** — database changes, API/RPC development, business logic, workflow implementation, external integrations, notification service wiring, audit logging, RBAC, background jobs, unit tests.
- **[QA/Sec]** — **auto-generated whenever the story touches tenancy, auth, migrations, or storage rules**: cross-tenant isolation tests (RLS or platform equivalent) and a Layla + Faris review before merge (standing rule, `docs/team.md`). This lane is not optional for those stories.

### 3.8 Pre-assignment review gate (Reem + Rashid)

No flagship story is assigned to engineers as-drafted. After Omar drafts it:

1. **Reem - design direction** (any story with a UI surface): design-system components to reuse or extend, UX flow and states guidance, motion + RTL notes, Figma references. Recorded in the story as a **Design Direction** section.
2. **Rashid - tech input**: architecture fit, which existing services/APIs/tables to extend (reuse before build), data-model and integration notes, feasibility risks, anything needing an ADR. Recorded as a **Tech Notes** section.
3. Their input goes back to **Omar**, who updates the story and subtasks - Omar stays the single editor so format and voice stay consistent.
4. Only after both sections are recorded is the story assigned.

Compact stories are reviewed in batch per epic; either reviewer can escalate one to flagship.

## 4. Compact story format

One to three lines inside the epic:

```
3.2 Roster list w/ search + status (FR-3.4) — AC: shows name, joined, program, package,
    last activity, streak; loads <1s at 50 clients.
```

Rules: FR trace required; ACs are observable outcomes with measurable targets; note permissions/audit when relevant. If the ACs outgrow ~3 lines or hit an escalation trigger (§1), promote to flagship.

## 5. Instructions for Omar

1. Think and write like a Senior Product Manager. Produce implementation-ready GitHub issues — never vague or generic requirements.
2. Respect the two tiers. Check the escalation triggers (§1) before choosing the format.
3. For flagship stories, fully document: business workflow, business rules, validations, integration points, notifications, status transitions, permissions/RBAC, audit logging, error handling, alternate flows, edge cases.
4. Behavior is specified once — in Scenarios. The Full Story never duplicates Then-steps.
5. Derive scenarios from the coverage matrix (§3.3); stop when the matrix is covered.
6. Tag every invented detail `[ASSUMPTION]` and surface the list for founder review.
7. Forms always get a structured field table; grids always get a column table (§3.4). Data contract only — layout is Reem's.
8. Every flagship story gets Out of Scope and auto-generated [FE]/[BE] subtasks, plus [QA/Sec] when triggered.
9. Keep the traceability header current — FR-x, Phase 3 tables/endpoints, priority, size.
10. Route every flagship draft through the Reem + Rashid gate (section 3.8) and fold their input in before assignment.

# Architecture Decision Records

Rashid's durable memory. One file per significant decision: `NNNN-short-title.md`.

Write an ADR when a change introduces: a new platform or major dependency; a new integration pattern; a new auth/authz model; a new data-ownership or tenancy model; a deployment-topology change; a significant operational trade-off; or a deliberate exception to established architecture. Flagged during the pre-assignment gate (story-format section 3.8).

Template:

```text
# NNNN - Title
Status: proposed | accepted | superseded by NNNN
Date:
Context:
Decision:
Alternatives considered:
Consequences:
Security impact:
Operational impact:
Rollback:
Owner:
```

ADRs outrank the guideline docs in rule precedence (see dev-guidelines.md). Supersede with a new ADR; never rewrite history.
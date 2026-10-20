# {{PROJECT_NAME}}

{{ONE_PARAGRAPH_PRODUCT_DESCRIPTION — what it is, who it serves, Saudi-first notes if applicable}}. {{STACK_SUMMARY: monorepo layout, FE/BE stack, package manager}}. {{INFRA_SUMMARY: backend platform + where schema/migrations live}}.

> New project from the saas-starter template? Complete `docs/SETUP.md` first, then delete this line.

## Read before working
1. `docs/dev-guidelines.md` — branching (PRs base into `uat`; `main` = prod), conventional commits, squash-merge, DoD.
2. `docs/code-style.md` — code style; reviewers cite it by section.
3. `docs/team.md` — the AI product org and named review agents (Layla=code, Faris=security, Rashid=architect, Nadia=scout). Every migration/tenancy/auth PR gets Layla + Faris before merge.
4. Backlog = GitHub issues (labels: team/*, epic/*, priority/*; milestones M1–M3). Epic/story writing format in `docs/story-format.md` (issue forms in `.github/ISSUE_TEMPLATE/`).

## Hard rules
- Server-side tenant isolation ({{TENANCY_MECHANISM: e.g. Postgres RLS, IAM policies, row-level authz}}) is the ONLY trusted tenancy boundary; every schema/migration PR ships cross-tenant isolation tests and requires a security-review pass.
- Never hardcode hex values in components; use semantic design tokens.
- Every screen ships AR+EN; use CSS logical properties (ms-/me-/ps-/pe-, start/end) — never left/right.
- Secrets live in `.env.local` (git-ignored) only; server-side/admin credentials must never get a client-exposed prefix (`VITE_`, `NEXT_PUBLIC_`, ...).
- No direct pushes to `uat`/`main` (enforced by ruleset — see `docs/SETUP.md`). CI = quality + Semgrep SAST + Gitleaks + dependency audit, all blocking.

## Commands
- {{COMMANDS: dev / build / test, per stack}}.
- Backend: {{BACKEND_PLATFORM}} - project/account: `{{BACKEND_PROJECT_REF}}` ({{BACKEND_REGION}}).

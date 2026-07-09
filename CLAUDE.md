# {{PROJECT_NAME}}

{{ONE_PARAGRAPH_PRODUCT_DESCRIPTION — what it is, who it serves, Saudi-first notes if applicable}}. {{STACK_SUMMARY: monorepo layout, FE/BE stack, package manager}}. `supabase/` holds migrations + RLS.

> New project from the saas-starter template? Complete `docs/SETUP.md` first, then delete this line.

## Read before working
1. `docs/dev-guidelines.md` — branching (PRs base into `uat`; `main` = prod), conventional commits, squash-merge, DoD.
2. `docs/code-style.md` — code style; reviewers cite it by section.
3. `docs/team.md` — the AI product org and named review agents (Layla=code, Faris=security, Rashid=architect, Nadia=scout). Every migration/RLS/auth PR gets Layla + Faris before merge.
4. Backlog = GitHub issues (labels: team/*, epic/*, priority/*; milestones M1–M3). Epic/story writing format in `docs/story-format.md` (issue forms in `.github/ISSUE_TEMPLATE/`).

## Hard rules
- RLS is the ONLY trusted tenancy boundary; every migration PR ships cross-tenant isolation tests and requires a security-review pass.
- Never hardcode hex values in components; use semantic design tokens.
- Every screen ships AR+EN; use CSS logical properties (ms-/me-/ps-/pe-, start/end) — never left/right.
- Secrets live in `.env.local` (git-ignored) only; `SUPABASE_SERVICE_ROLE_KEY` must never get a client-exposed prefix (`VITE_`, `NEXT_PUBLIC_`, ...).
- No direct pushes to `uat`/`main` (enforced by ruleset — see `docs/SETUP.md`). CI = quality + Semgrep SAST + Gitleaks + dependency audit, all blocking.

## Commands
- {{COMMANDS: dev / build / test, per stack}}.
- Supabase project ref: `{{SUPABASE_PROJECT_REF}}` ({{SUPABASE_REGION}}).

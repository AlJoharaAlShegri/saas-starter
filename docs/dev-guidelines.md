# {{PROJECT_NAME}} — Development Guidelines

Adapted from SILZ engineering practice (2026-07-08). Applies to the single monorepo `{{GITHUB_OWNER}}/{{PROJECT_SLUG}}`.

## 1. Repo & branches

| Branch | Role | Deploys to |
|---|---|---|
| `main` | **Production** — protected | prod (tagged releases) |
| `uat` | Integration / UAT — base branch for ALL PRs | UAT environment (dogfood coaches) |

- **Never commit directly to `main` or `uat`.** Always branch → PR.
- Flow: `feature/*` → PR into `uat` → validated on UAT → PR `uat` → `main` (release).
- Hotfixes: branch `hotfix/*` from `main`, PR back into `main`, then sync `uat`.

## 2. Branch naming

```
feature/<ticket>-<short-kebab-summary>
fix/<ticket>-<short-kebab-summary>
chore/<scope>-<short-kebab-summary>
hotfix/<ticket>-<short-kebab-summary>
```

`<ticket>` = backlog story ID (e.g. `E5-S2`) until Jira is wired, then the Jira key (e.g. `CS-142`).
Keep branches small and focused — aim < 300 lines diff.

## 3. Commits — Conventional Commits

```
feat(checkins): photo privacy toggle defaults to coach-only
fix(auth): correct OTP resend cooldown
chore(ci): add semgrep ruleset for react
docs(guidelines): initial dev guidelines
refactor(theme): extract accent-color derivation
test(rls): cross-tenant isolation for checkins table
```

Scopes mirror epics/folders, defined per project (always: `ci`, `repo`; examples: `auth`, `rls`, `theme`).

## 4. Pull requests

- Base branch: **`uat`** (only release PRs and hotfixes target `main`).
- Title: `[E5-S2] Short meaningful description`.
- Fill the PR template (auto-inserted). UI PRs MUST include before/after screenshots covering empty/loading/error states **and RTL**, plus every theme defined by the project's design system when affected.
- Minimum approval: 1 review. Solo-founder mode: a `/code-review` pass (Claude) + self-review substitutes until a second human joins. Security-sensitive changes (schema migrations, tenancy policies, auth, storage rules) additionally get a security-review pass — no exceptions.
- Address review with follow-up commits; no force-push after review starts.
- Merge strategy: **Squash & merge** only.

## 5. CI pipeline (every PR + pushes to uat/main)

| Job | Tool | Blocking |
|---|---|---|
| Quality | lint · typecheck · unit tests · build | yes |
| **SAST** | Semgrep (`p/ci`, `p/secrets` + per-language rulesets) | yes |
| Secret scan | Gitleaks (full history) | yes |
| Dependency audit | per package manager (fail on high+) | yes |
| Dependency updates | Dependabot (weekly, grouped minor/patch) | PRs |

Planned additions as the codebase grows: tenant-isolation test suite (blocking, per Phase 5 §4), RTL snapshot tests, Lighthouse CI on staging.

## 6. Definition of Done

- PR squash-merged into `uat` with CI fully green (incl. security jobs)
- Tests passing; coverage threshold met for domain logic (Phase 5 §4 policy)
- UI: screenshots incl. RTL + all design-system themes; states covered
- Migrations: committed, applied to dev project, **with tenant-isolation tests**
- Env/config changes documented in `.env.example` + README
- Ticket moved to the correct state

## 7. Git cheat sheet

```bash
# start work (always from uat)
git checkout uat && git pull
git checkout -b feature/E5-S2-checkin-photo-privacy

# ship
git add -A
git commit -m "feat(checkins): photo privacy toggle (E5-S2)"
git push -u origin feature/E5-S2-checkin-photo-privacy
# open PR -> base: uat
```

## 8. Code style

All code follows [code-style.md](code-style.md) (Clean Code condensed, TS-adapted). Reviewers cite it by section; style findings are valid review findings.

## 9. Security ground rules (always on)

- No secrets in the repo — `.env.local` only, `.env.example` documents keys.
- All user input schema-validated at boundaries; server-side tenant isolation is the only trusted tenancy boundary.
- No `console.log` in production code; no PII in logs.
- New endpoints/tables ship with RBAC + audit logging per Phase 3 §B6.

## Rule precedence

When guidance conflicts, apply in this order - no agent may silently override a higher source:

1. Law, regulation, and mandatory policy
2. An explicit human (founder) decision
3. An approved ADR (`docs/adr/`)
4. CLAUDE.md and repository instructions
5. These guidelines and `docs/code-style.md`
6. The established local code pattern
7. Agent preference

Name the conflict when you hit one; never pick a side silently.

## Scope & evidence discipline

Scope:
- Implement only the approved scope. No unrelated file changes, no redesigns of unrelated modules, no unrequested features.
- Cleanup/refactoring never rides along with feature work unless required for correctness - it gets its own PR.
- Record every material deviation from the agreed plan in the PR; stop and escalate when a required change exceeds approved scope.

Evidence:
- Never claim a command, test, or check passed unless it was actually executed; report unexecuted checks as unexecuted, with the reason.
- Never delete or weaken a failing test to go green - fix the implementation, or escalate if the test itself is wrong.
- Skipped checks are never marked passed; snapshot/golden-file changes are inspected, not auto-accepted.
- Performance claims require measured numbers.
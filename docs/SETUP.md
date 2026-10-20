# New Project Setup

Checklist for spinning a project from this template. Everything file-based transfers automatically; GitHub *settings* (labels, milestones, rulesets) and the Supabase connection need the steps below.

## 1. Create the repo

Use **"Use this template"** on GitHub, or:

```powershell
gh repo create <owner>/<project-slug> --template <owner>/saas-starter --private --clone
```

## 2. Fill the placeholders

Search the repo for `{{` and replace:

| Placeholder | Where | Value |
|---|---|---|
| `{{PROJECT_NAME}}` | CLAUDE.md, docs/*, .env.example | Product name (e.g. CoachSpace) |
| `{{PROJECT_SLUG}}` | package.json, docs/dev-guidelines.md | kebab-case repo/package name |
| `{{GITHUB_OWNER}}` | docs/dev-guidelines.md | GitHub account/org |
| `{{ONE_PARAGRAPH_PRODUCT_DESCRIPTION}}` | CLAUDE.md | What you're building |
| `{{BACKEND_PLATFORM}}` / `{{BACKEND_PROJECT_REF}}` / `{{BACKEND_REGION}}` | CLAUDE.md | Infra platform + project/account + region (step 4) |
| `{{INFRA_SUMMARY}}` / `{{TENANCY_MECHANISM}}` | CLAUDE.md | Backend layout + tenant-isolation mechanism (step 4) |
| `{{STACK_SUMMARY}}` / `{{COMMANDS}}` | CLAUDE.md | Stack + dev/build/test commands (step 5) |
| `{{ENV_PREFIX}}` | .env.example | Client env prefix (VITE_, NEXT_PUBLIC_, ...) |

## 3. GitHub settings (labels, milestones, ruleset, uat branch)

```powershell
.\scripts\github-setup.ps1 -Owner <owner> -Repo <project-slug>
```

Creates the `team/*` + `priority/*` labels from `.github/labels.json`, milestones M1–M3, the `uat` branch, and imports the branch-protection ruleset from `.github/rulesets/protect-uat-and-main.json` (blocks direct pushes to `uat`/`main`, requires the four CI checks, squash-merge only). Add `epic/*` labels as epics are defined (docs/story-format.md).

## 4. Backend & infrastructure (per project)

1. Choose the platform PER PROJECT (Supabase, AWS, GCP, Azure, ...) and create its project/account. The shipped `supabase/` folder and `.env.example` keys are the Supabase DEFAULT - replace them if you choose differently. (KSA-adjacent latency: prefer Middle East or Frankfurt regions.)
2. Copy `.env.example` → `.env.local`; fill your platform URL and keys. Client-exposed vars carry your framework prefix ({{ENV_PREFIX}}: VITE_, NEXT_PUBLIC_, EXPO_PUBLIC_, ...).
3. Server-side/admin credentials (e.g. `SUPABASE_SERVICE_ROLE_KEY`, cloud secret keys) stay server-side only (isolation test suite) — NEVER with a client-exposed prefix, never committed.
4. Update the platform + project/account ref + region in CLAUDE.md.
5. The FIRST schema change ships the tenancy model + its enforcement (RLS, IAM policies, or platform equivalent) + the cross-tenant isolation test harness, before any feature tables (hard rule, any platform).

## 5. App scaffold (per-project stack)

The template ships no `app/` — pick the FE/BE stack per project and scaffold it as `app/`. The shipped `ci.yml`, `package.json`, `pnpm-workspace.yaml`, the `supabase/` folder, and the language-specific sections of `code-style.md` are TS/React/pnpm/Supabase DEFAULTS: keep them if the stack matches, otherwise replace the Quality + Dependency-audit steps and Semgrep rulesets for your languages. If CI job names change, update the required status checks in `.github/rulesets/protect-uat-and-main.json` before importing it.

## 6a. Adopting into an EXISTING project (not a fresh repo)

When told to "use the saas-starter template" in a project that already exists, do NOT rely on reading the template repo into conversation memory - COPY the files in, then verify they exist on disk:

1. Copy `docs/story-format.md`, `docs/team.md`, `docs/dev-guidelines.md`, `docs/code-style.md` into the project (renumber to match local doc conventions if needed).
2. Add a CLAUDE.md (or extend the project's session bootstrap doc) with the "Read before working" pointers - especially the story-format rule: flagship stories ship full Given/When/Then, Traces header, UI data contract, Out of Scope, subtask lanes; non-conforming stories are rejected in review.
3. If the project is on GitHub: copy `.github/` (CI, PR template, issue forms) and run `scripts/github-setup.ps1`.
4. VERIFY: list the project's docs and confirm the files landed. A session that only "read" the template will drift within one compaction.

## 6. First backlog

Follow `docs/story-format.md`: epic map first, then flagship/compact stories via the issue forms (`.github/ISSUE_TEMPLATE/`). The delivery org and review agents are defined in `docs/team.md`.

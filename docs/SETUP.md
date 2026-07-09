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
| `{{SUPABASE_PROJECT_REF}}` / `{{SUPABASE_REGION}}` | CLAUDE.md | From step 4 |

## 3. GitHub settings (labels, milestones, ruleset, uat branch)

```powershell
.\scripts\github-setup.ps1 -Owner <owner> -Repo <project-slug>
```

Creates the `team/*` + `priority/*` labels from `.github/labels.json`, milestones M1–M3, the `uat` branch, and imports the branch-protection ruleset from `.github/rulesets/protect-uat-and-main.json` (blocks direct pushes to `uat`/`main`, requires the four CI checks, squash-merge only). Add `epic/*` labels as epics are defined (docs/story-format.md).

## 4. Supabase

1. Create a new project at supabase.com (pick region; Frankfurt for KSA-adjacent latency).
2. Copy `.env.example` → `.env.local`; fill `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_SUPABASE_PUBLISHABLE_KEY`.
3. `SUPABASE_SERVICE_ROLE_KEY` stays server-side only (RLS test suite) — NEVER with a `VITE_` prefix, never committed.
4. Update the project ref + region in CLAUDE.md.
5. Migration 0001 should ship the tenancy tables + RLS helper + the cross-tenant isolation test harness before any feature tables (hard rule).

## 5. App scaffold

The template ships no `app/` — scaffold Vite + React 19 + TS + Tailwind v4 as `app/` in the pnpm workspace, or copy a prior project's E0 scaffold. CI (`.github/workflows/ci.yml`) expects `pnpm --filter app` targets: lint, `tsc -b`, test, build.

## 6. First backlog

Follow `docs/story-format.md`: epic map first, then flagship/compact stories via the issue forms (`.github/ISSUE_TEMPLATE/`). The delivery org and review agents are defined in `docs/team.md`.

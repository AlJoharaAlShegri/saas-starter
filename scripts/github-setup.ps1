<#
.SYNOPSIS
One-time GitHub settings for a repo created from the saas-starter template:
labels, milestones M1-M3, uat branch, and the branch-protection ruleset.
Requires: gh CLI authenticated with repo admin rights.
#>
param(
    [Parameter(Mandatory = $true)][string]$Owner,
    [Parameter(Mandatory = $true)][string]$Repo
)

$ErrorActionPreference = 'Stop'
$full = "$Owner/$Repo"
$root = Split-Path $PSScriptRoot -Parent

Write-Host "== Labels =="
$labels = Get-Content (Join-Path $root '.github/labels.json') -Raw | ConvertFrom-Json
foreach ($l in $labels) {
    $desc = if ($null -eq $l.description) { '' } else { $l.description }
    gh label create $l.name --repo $full --color $l.color --description $desc --force
}

Write-Host "== Milestones M1-M3 =="
$existing = gh api "repos/$full/milestones?state=all" | ConvertFrom-Json | ForEach-Object { $_.title }
foreach ($m in 'M1', 'M2', 'M3') {
    if ($existing -contains $m) { Write-Host "$m exists, skipping" }
    else { gh api "repos/$full/milestones" -f title=$m | Out-Null; Write-Host "$m created" }
}

Write-Host "== uat branch =="
$defaultSha = (gh api "repos/$full/git/ref/heads/main" | ConvertFrom-Json).object.sha
try {
    gh api "repos/$full/git/refs" -f ref='refs/heads/uat' -f sha=$defaultSha | Out-Null
    Write-Host "uat created from main"
} catch { Write-Host "uat already exists, skipping" }

Write-Host "== Branch-protection ruleset =="
$ruleset = Get-Content (Join-Path $root '.github/rulesets/protect-uat-and-main.json') -Raw | ConvertFrom-Json
# Strip server-generated fields; keep only what the create API accepts
$payload = [ordered]@{
    name          = $ruleset.name
    target        = $ruleset.target
    enforcement   = $ruleset.enforcement
    conditions    = $ruleset.conditions
    rules         = $ruleset.rules
    bypass_actors = @($ruleset.bypass_actors)
}
$tmp = Join-Path $env:TEMP "ruleset-$Repo.json"
$payload | ConvertTo-Json -Depth 10 | Set-Content $tmp -Encoding utf8
gh api "repos/$full/rulesets" -X POST --input $tmp | Out-Null
Remove-Item $tmp
Write-Host "Ruleset '$($ruleset.name)' imported"

Write-Host "`nDone. Verify at https://github.com/$full/settings/rules"

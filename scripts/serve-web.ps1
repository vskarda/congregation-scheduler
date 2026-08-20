<#
.SYNOPSIS
Builds the Flutter web app and serves it, for driving with Playwright.

.DESCRIPTION
There is no Android SDK on this machine, so the reliable runtime surface for
end-to-end verification is Flutter web. The app boots to /setup when no
Firebase config is stored, which makes the whole first-run flow drivable with
no Firebase project at all. Anything behind login needs a real backend --
see docs/TESTING-LIVE.md for that, or the golden-shot route in
scripts/shot.ps1 for merely *looking* at a gated screen.

The Playwright recipe that drives this (canvas semantics, wheel-scrolling,
coordinate clicks) lives in .claude/skills/verify/SKILL.md.

Note: this is a plain static file server with no SPA fallback, so a deep link
such as /setup/help returns 404. Navigate from / instead, which is what the
app's own routing does.

.EXAMPLE
scripts\serve-web.ps1

.EXAMPLE
scripts\serve-web.ps1 -SkipBuild -Background
#>
[CmdletBinding()]
param(
    [int]$Port = 8377,
    # Reuse an existing build/web (a release build takes a couple of minutes).
    [switch]$SkipBuild,
    # Start the server detached and print its PID instead of blocking.
    [switch]$Background
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_tools.ps1')

$repo = Get-RepoRoot
$webDir = Join-Path $repo 'build\web'

$inUse = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
if ($inUse) {
    throw "Port $Port is already in use (PID $($inUse[0].OwningProcess)). " +
          'Stop it or pass -Port <n>.'
}

if (-not $SkipBuild) {
    Write-Step 'Building the web app (release)'
    $flutter = Get-FlutterExe
    try {
        Push-Location $repo
        Invoke-Native { & $flutter build web --release } 'flutter build web'
    }
    finally {
        Pop-Location
    }
}

if (-not (Test-Path (Join-Path $webDir 'index.html'))) {
    throw "No build in $webDir. Run without -SkipBuild."
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw 'python not found; it is used as the static file server. Install ' +
          'Python, or serve build\web with any other static server.'
}

Write-Step "Serving $webDir at http://localhost:$Port/"

if ($Background) {
    $proc = Start-Process -FilePath $python.Source `
        -ArgumentList '-m', 'http.server', $Port, '--directory', $webDir `
        -PassThru -WindowStyle Hidden
    Write-Host "    PID $($proc.Id) -- stop with: Stop-Process -Id $($proc.Id)"
}
else {
    Write-Host '    Ctrl-C to stop.'
    & $python.Source -m http.server $Port --directory $webDir
}

<#
.SYNOPSIS
Renders a login-gated screen to a PNG you can look at.

.DESCRIPTION
The served web build (scripts\serve-web.ps1) only reaches /setup without a
real Firebase project, so an admin screen's layout cannot be inspected there.
A shot pumps the screen with fake_cloud_firestore and provider overrides at a
fixed size and writes test\shots\out\<name>.png.

Text renders as Ahem boxes, but column widths, alignment, row tints and icon
states are all legible -- enough to catch a layout defect that no find.text
assertion would notice.

Shots are a visual probe, not a regression golden: Flutter renders
differently here than on Linux CI, so the PNGs are gitignored and the files
are named *.shot.dart so `flutter test` (which discovers only *_test.dart)
never runs them in CI.

Write a new one by copying test\shots\example.shot.dart.

.EXAMPLE
scripts\shot.ps1

.EXAMPLE
scripts\shot.ps1 -Target test\shots\my_screen.shot.dart -Open
#>
[CmdletBinding()]
param(
    [string]$Target = 'test/shots/example.shot.dart',
    # Open the rendered PNGs in the default image viewer.
    [switch]$Open
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_tools.ps1')

$repo = Get-RepoRoot
$outDir = Join-Path $repo 'test\shots\out'

if (-not (Test-Path (Join-Path $repo $Target))) {
    throw "No such shot file: $Target"
}

$flutter = Get-FlutterExe

Write-Step "Rendering $Target"
try {
    Push-Location $repo
    # --update-goldens writes the PNGs instead of comparing against them;
    # there is nothing to compare to, the picture *is* the output.
    Invoke-Native { & $flutter test $Target --update-goldens } 'Shot render'
}
finally {
    Pop-Location
}

$shots = @(Get-ChildItem $outDir -Filter '*.png' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending)
if ($shots.Count -eq 0) {
    throw "The run produced no PNGs in $outDir."
}

Write-Host ''
Write-Host "Rendered into $outDir" -ForegroundColor Green
foreach ($s in $shots) {
    Write-Host ("    {0}  ({1:n0} KB)" -f $s.Name, ($s.Length / 1KB))
}

if ($Open) {
    foreach ($s in $shots) { Invoke-Item $s.FullName }
}

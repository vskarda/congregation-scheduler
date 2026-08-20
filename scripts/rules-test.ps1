<#
.SYNOPSIS
Runs the Firestore security-rules tests against the local emulator.

.DESCRIPTION
The emulator is a Java process and there is no java on PATH on this machine —
only a portable Temurin JRE under ~/java. This script finds it (see
_tools.ps1), points JAVA_HOME at it for the duration of the run, and hands off
to `npm test` in rules-tests/, which starts the emulator and runs
`node --test`.

Takes roughly half a minute, nearly all of it emulator boot, so there is
little to gain from running a subset — expect the whole suite.

Equivalent to the `firestore-rules` job in .github/workflows/ci.yml, but
without waiting for CI.

.EXAMPLE
scripts\rules-test.ps1

.EXAMPLE
scripts\rules-test.ps1 -Install     # first run, or after package.json changes
#>
[CmdletBinding()]
param(
    # Run `npm ci` before the tests (needed once, and after a dependency bump).
    [switch]$Install
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_tools.ps1')

$rulesDir = Join-Path (Get-RepoRoot) 'rules-tests'
if (-not (Test-Path $rulesDir)) { throw "Missing $rulesDir." }

Write-Step 'Locating a JDK for the Firestore emulator'
$javaHome = Use-JavaHome
Write-Host "    JAVA_HOME = $javaHome"

if (-not $Install -and -not (Test-Path (Join-Path $rulesDir 'node_modules'))) {
    throw 'rules-tests/node_modules is missing. Run: scripts\rules-test.ps1 -Install'
}

try {
    Push-Location $rulesDir

    if ($Install) {
        Write-Step 'Installing dependencies (npm ci)'
        Invoke-Native { npm ci } 'npm ci'
    }

    Write-Step 'Running rules tests (starts the Firestore emulator)'
    # A previous run killed mid-test can leave the emulator holding its port;
    # emulators:exec then fails immediately with a port-in-use error.
    Invoke-Native { npm test } 'Rules tests'
}
finally {
    Pop-Location
}

Write-Host ''
Write-Host 'Rules tests passed.' -ForegroundColor Green

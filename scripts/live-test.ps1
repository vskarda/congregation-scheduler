<#
.SYNOPSIS
Runs the live-congregation integration tests against the project in .credits/.

.DESCRIPTION
Reads .credits/.congregation.json (Firebase web config) and .credits/.login
(admin email + password), forwards them to the web build as base64
--dart-defines, and drives the suite in Chrome.

Base64 is used so JSON braces, quotes and password punctuation survive the
shell without escaping. Nothing is written to disk or echoed.

Requires chromedriver on PATH (or -ChromeDriver), matching the installed
Chrome major version. The Firestore emulator and a JDK are NOT needed - these
tests talk to the real project.

.EXAMPLE
scripts\live-test.ps1

.EXAMPLE
scripts\live-test.ps1 -Target integration_test\live_smoke_test.dart
#>
[CmdletBinding()]
param(
    [string]$Target = 'integration_test/live_smoke_test.dart',
    [string]$ChromeDriver = 'chromedriver',
    [int]$Port = 4444
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$creditsDir = Join-Path $repo '.credits'
$configPath = Join-Path $creditsDir '.congregation.json'
$loginPath = Join-Path $creditsDir '.login'

function Read-RequiredFile([string]$path, [string]$hint) {
    if (-not (Test-Path $path)) { throw "Missing $path - $hint" }
    $text = (Get-Content $path -Raw)
    if ([string]::IsNullOrWhiteSpace($text)) { throw "$path is empty - $hint" }
    return $text.Trim()
}

$configText = Read-RequiredFile $configPath 'paste the Firebase web config JSON'
$loginText = Read-RequiredFile $loginPath 'add the admin email and password'

# .login accepts {"email":"..","password":".."} or two bare lines, so the file
# can be maintained by hand without worrying about the format.
$email = $null
$password = $null
try {
    $login = $loginText | ConvertFrom-Json
    $email = $login.email
    $password = $login.password
}
catch {
    $parts = $loginText -split "`r?`n" | Where-Object { $_.Trim() -ne '' }
    if ($parts.Count -ge 2) {
        $email = $parts[0].Trim()
        $password = $parts[1].Trim()
    }
}
if ([string]::IsNullOrWhiteSpace($email) -or [string]::IsNullOrWhiteSpace($password)) {
    throw "Could not read an email and password from $loginPath. Use " +
          '{"email":"..","password":".."} or two lines (email, then password).'
}

# Show which project is about to be written to. These tests create and delete
# documents, so a mistyped config should be caught here, by a human.
try {
    $projectId = ($configText | ConvertFrom-Json).projectId
}
catch {
    $projectId = '<unparsable - Dart will validate it>'
}
Write-Host ''
Write-Host "  Firebase project : $projectId" -ForegroundColor Yellow
Write-Host "  Admin account    : $email" -ForegroundColor Yellow
Write-Host "  Target           : $Target"
Write-Host '  These tests create and delete documents in that project.' -ForegroundColor Yellow
Write-Host ''

function ConvertTo-B64([string]$value) {
    [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($value))
}

$driver = $null
try {
    $driver = Start-Process -FilePath $ChromeDriver `
        -ArgumentList "--port=$Port" -PassThru -WindowStyle Hidden
}
catch {
    throw "Could not start '$ChromeDriver'. Install the chromedriver matching " +
          'your Chrome version and put it on PATH, or pass -ChromeDriver <path>.'
}

try {
    Push-Location $repo
    & flutter drive `
        --driver=test_driver/integration_test.dart `
        --target=$Target `
        -d chrome `
        --dart-define="LIVE_FIREBASE_CONFIG_B64=$(ConvertTo-B64 $configText)" `
        --dart-define="LIVE_ADMIN_EMAIL_B64=$(ConvertTo-B64 $email)" `
        --dart-define="LIVE_ADMIN_PASSWORD_B64=$(ConvertTo-B64 $password)"
    $exit = $LASTEXITCODE
}
finally {
    Pop-Location
    if ($driver -and -not $driver.HasExited) {
        Stop-Process -Id $driver.Id -Force -ErrorAction SilentlyContinue
    }
}

exit $exit

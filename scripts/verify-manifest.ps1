<#
.SYNOPSIS
Checks that no broad media permissions survive into the merged Android
manifest -- without an Android SDK.

.DESCRIPTION
open_filex declares READ_MEDIA_IMAGES/VIDEO/AUDIO in its library manifest.
This app only ever hands it a file it wrote into its own cache directory, so
those permissions are stripped with tools:node="remove" in
android/app/src/main/AndroidManifest.xml, and Google Play's photo and video
permissions policy is satisfied. A dependency bump can quietly reintroduce
them.

.github/workflows/release.yml gates this too, but only on a release run -- by
which point a bad build is already made. There is no Android SDK on this
machine, so instead of Gradle this script drives AGP's manifest-merger
directly: eight jars from Google's Maven and Maven Central, cached per user.
Classes load lazily, so no deeper dependency resolution is needed.

Two things make the result trustworthy:

 * The library manifest comes from the pub cache at the version pinned in
   pubspec.lock, so a dependency bump is picked up automatically. A
   checked-in fixture would silently rot.
 * A CONTROL run repeats the merge with the tools:node="remove" lines
   stripped and requires the permissions to REAPPEAR. Without it a broken
   harness -- wrong flags, wrong classpath, empty output -- reports a
   reassuring pass that means nothing.

.EXAMPLE
scripts\verify-manifest.ps1

.EXAMPLE
scripts\verify-manifest.ps1 -Keep      # keep the merged XML for inspection
#>
[CmdletBinding()]
param(
    # Overrides the AGP version read from android/settings.gradle.kts.
    [string]$AgpVersion,
    [int]$MinSdk = 24,
    [int]$TargetSdk = 36,
    # Skip the control run. Only for debugging -- a pass then proves little.
    [switch]$NoControl,
    # Keep the working directory and print its path.
    [switch]$Keep
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '_tools.ps1')

$repo = Get-RepoRoot
$appManifest = Join-Path $repo 'android/app/src/main/AndroidManifest.xml'
if (-not (Test-Path $appManifest)) { throw "Missing $appManifest." }

# ---------------------------------------------------------------- versions --

if (-not $AgpVersion) {
    $settings = Get-Content (Join-Path $repo 'android/settings.gradle.kts') -Raw
    $m = [regex]::Match($settings,
        'id\("com\.android\.application"\)\s+version\s+"([\d.]+)"')
    if (-not $m.Success) {
        throw 'Could not read the AGP version from android/settings.gradle.kts. ' +
              'Pass -AgpVersion explicitly.'
    }
    $AgpVersion = $m.Groups[1].Value
}

# The build tools ship one major ahead of AGP's, offset by 23:
# AGP 7.x -> 30.x, 8.x -> 31.x, 9.x -> 32.x. Derived rather than pinned so an
# AGP bump does not silently keep testing the old merger.
$agpParts = $AgpVersion.Split('.')
$toolsVersion = "$([int]$agpParts[0] + 23).$($agpParts[1]).$($agpParts[2])"

$appId = 'org.jwscheduler.congregation_scheduler'

Write-Step "AGP $AgpVersion -> manifest-merger $toolsVersion"

# ------------------------------------------------------------------- jars ---

$google = 'https://dl.google.com/dl/android/maven2'
$central = 'https://repo1.maven.org/maven2'

# Only needs to be new enough to load; classes resolve lazily.
$gson = '2.11.0'
$kotlin = '2.0.21'
$guava = '33.3.1-jre'

$artifacts = @(
    @{ Name = "manifest-merger-$toolsVersion.jar"; Url = "$google/com/android/tools/build/manifest-merger/$toolsVersion/manifest-merger-$toolsVersion.jar" }
    @{ Name = "common-$toolsVersion.jar";          Url = "$google/com/android/tools/common/$toolsVersion/common-$toolsVersion.jar" }
    @{ Name = "sdk-common-$toolsVersion.jar";      Url = "$google/com/android/tools/sdk-common/$toolsVersion/sdk-common-$toolsVersion.jar" }
    @{ Name = "sdklib-$toolsVersion.jar";          Url = "$google/com/android/tools/sdklib/$toolsVersion/sdklib-$toolsVersion.jar" }
    @{ Name = "annotations-$toolsVersion.jar";     Url = "$google/com/android/tools/annotations/$toolsVersion/annotations-$toolsVersion.jar" }
    @{ Name = "gson-$gson.jar";                    Url = "$central/com/google/code/gson/gson/$gson/gson-$gson.jar" }
    @{ Name = "kotlin-stdlib-$kotlin.jar";         Url = "$central/org/jetbrains/kotlin/kotlin-stdlib/$kotlin/kotlin-stdlib-$kotlin.jar" }
    @{ Name = "guava-$guava.jar";                  Url = "$central/com/google/guava/guava/$guava/guava-$guava.jar" }
)

$cache = Get-ToolCacheDir "manifest-merger\$toolsVersion"
$jarPaths = @()
$downloaded = 0
foreach ($a in $artifacts) {
    $path = Join-Path $cache $a.Name
    if (-not (Test-Path $path)) {
        if ($downloaded -eq 0) { Write-Step "Fetching tooling into $cache" }
        Write-Host "    $($a.Name)"
        Invoke-WebRequest -Uri $a.Url -OutFile $path -UseBasicParsing
        $downloaded++
    }
    $jarPaths += $path
}
if ($downloaded -eq 0) { Write-Host "    jars cached in $cache" }
# ';' on Windows, ':' elsewhere — this script also runs on the Linux CI runner.
$classpath = $jarPaths -join [IO.Path]::PathSeparator

# -------------------------------------------------------- library manifest --

$lock = Get-Content (Join-Path $repo 'pubspec.lock') -Raw
$m = [regex]::Match($lock, '(?ms)^  open_filex:\r?\n.*?^    version: "([^"]+)"')
if (-not $m.Success) { throw 'Could not read the open_filex version from pubspec.lock.' }
$openFilexVersion = $m.Groups[1].Value

$pubRoots = @()
if ($env:PUB_CACHE) { $pubRoots += $env:PUB_CACHE }
if ($env:LOCALAPPDATA) { $pubRoots += (Join-Path $env:LOCALAPPDATA 'Pub/Cache') }
$pubRoots += (Join-Path (Get-UserHome) '.pub-cache')

$libSource = $null
foreach ($root in $pubRoots) {
    $candidate = Join-Path $root `
        "hosted/pub.dev/open_filex-$openFilexVersion/android/src/main/AndroidManifest.xml"
    if (Test-Path $candidate) { $libSource = $candidate; break }
}
if (-not $libSource) {
    throw "open_filex $openFilexVersion is not in the pub cache. Run `flutter pub get` first."
}
Write-Host "    library manifest: open_filex $openFilexVersion"

# --------------------------------------------------------------- merge run --

$work = Join-Path ([IO.Path]::GetTempPath()) "manifest-check-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Force -Path $work | Out-Null

# The plugin manifest declares no <uses-sdk>. Without one matching the app the
# merger infers legacy defaults and adds phantom WRITE_EXTERNAL_STORAGE /
# READ_PHONE_STATE that a real Gradle build never produces.
$libXml = (Get-Content $libSource -Raw) -replace '</manifest>', @"
    <uses-sdk android:minSdkVersion="$MinSdk" android:targetSdkVersion="$TargetSdk" />
</manifest>
"@
$libPath = Join-Path $work 'open_filex.xml'
Set-Content -Path $libPath -Value $libXml -Encoding utf8

function Invoke-Merge {
    param([string]$MainManifest, [string]$OutFile)

    # --property PACKAGE auto-injects the applicationId placeholder, so passing
    # it again via --placeholder throws "Multiple entries with same key".
    # --remove-tools-declarations is essential: without it the CLI leaves
    # tools:node="remove" markers in the output and a successful removal looks
    # like a failure.
    & java -cp $classpath com.android.manifmerger.Merger `
        --main $MainManifest `
        --libs $libPath `
        --property MIN_SDK_VERSION=$MinSdk `
        --property TARGET_SDK_VERSION=$TargetSdk `
        --property PACKAGE=$appId `
        --placeholder applicationName=android.app.Application `
        --remove-tools-declarations `
        --out $OutFile 2>&1 | Write-Verbose

    if (-not (Test-Path $OutFile)) { throw 'The merger produced no output.' }
    $merged = Get-Content $OutFile -Raw
    if ([string]::IsNullOrWhiteSpace($merged)) {
        throw 'The merged manifest is empty -- refusing to treat that as a pass.'
    }
    return $merged
}

Use-JavaHome | Out-Null

try {
    Write-Step 'Merging the real manifest'
    $mergedPath = Join-Path $work 'merged.xml'
    $merged = Invoke-Merge -MainManifest $appManifest -OutFile $mergedPath

    # @() so an empty result is still an array -- under StrictMode a bare $null
    # has no .Count, which would crash exactly on the passing path.
    $found = @([regex]::Matches($merged, 'android\.permission\.READ_MEDIA_[A-Z]+') |
        ForEach-Object { $_.Value } | Sort-Object -Unique)

    if (-not $NoControl) {
        Write-Step 'Control run (removal directives stripped -- must FAIL)'
        # Strip the three tools:node="remove" declarations so the library's
        # permissions have nothing holding them back.
        $stripped = (Get-Content $appManifest -Raw) -replace `
            '(?ms)\s*<uses-permission android:name="android\.permission\.READ_MEDIA_[A-Z]+"\s*\r?\n?\s*tools:node="remove"\s*/>', ''
        $strippedPath = Join-Path $work 'app-control.xml'
        Set-Content -Path $strippedPath -Value $stripped -Encoding utf8

        $controlMerged = Invoke-Merge -MainManifest $strippedPath `
            -OutFile (Join-Path $work 'merged-control.xml')
        $controlFound = @([regex]::Matches($controlMerged,
            'android\.permission\.READ_MEDIA_[A-Z]+') |
            ForEach-Object { $_.Value } | Sort-Object -Unique)

        if ($controlFound.Count -eq 0) {
            throw 'CONTROL FAILED: with the removal directives stripped the ' +
                  'permissions still did not appear. The harness is not ' +
                  'actually merging the library manifest, so the real run ' +
                  'proves nothing.'
        }
        Write-Host "    control reintroduced: $($controlFound -join ', ')" `
            -ForegroundColor DarkGray
    }

    Write-Host ''
    if ($found.Count -gt 0) {
        Write-Host 'FAIL: broad media permissions in the merged manifest:' `
            -ForegroundColor Red
        $found | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
        Write-Host ('Google Play''s photo and video permissions policy ' +
            'forbids these when system pickers suffice.') -ForegroundColor Red
        exit 1
    }

    Write-Host 'OK: no READ_MEDIA_* permissions in the merged manifest.' `
        -ForegroundColor Green
    if (-not $NoControl) {
        Write-Host '    (control run confirmed the check can fail)' `
            -ForegroundColor DarkGray
    }
}
finally {
    if ($Keep) {
        Write-Host ''
        Write-Host "Working files kept in $work"
    }
    else {
        Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
    }
}

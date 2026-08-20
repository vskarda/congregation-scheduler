<#
.SYNOPSIS
Shared toolchain discovery for the scripts in this folder. Dot-source it:

    . (Join-Path $PSScriptRoot '_tools.ps1')

.DESCRIPTION
This is a Windows dev box without a full Android toolchain: Flutter lives under
the user profile rather than on PATH for existing shells, and there is no Java
on PATH at all — only a portable Temurin JRE unpacked under ~/java. Every
script here needs one or both, so the lookup lives in one place and is done by
*glob*, never by a pinned path: the JRE directory carries its version
(jdk-21.0.11+10-jre), and hardcoding that would mean editing several scripts on
the next upgrade.

PowerShell 5.1: no '&&', no ternary, no null-coalescing. Use Invoke-Native to
fail a native command loudly.
#>

Set-StrictMode -Version Latest

function Get-RepoRoot {
    <#
    .SYNOPSIS
    Absolute path of the repository (the parent of scripts/).
    #>
    return (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function Get-FlutterExe {
    <#
    .SYNOPSIS
    Path to flutter.bat: PATH first, then the standard user-profile install.
    #>
    $onPath = Get-Command flutter -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }

    $profileCopy = Join-Path $env:USERPROFILE 'flutter\bin\flutter.bat'
    if (Test-Path $profileCopy) { return $profileCopy }

    throw 'Flutter not found. Install it, or put flutter.bat on PATH ' +
          "(looked for $profileCopy)."
}

function Get-JavaHome {
    <#
    .SYNOPSIS
    A JDK/JRE home: $env:JAVA_HOME, then java on PATH, then the newest
    portable Temurin build under ~/java.
    #>
    if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) {
        return $env:JAVA_HOME
    }

    $onPath = Get-Command java -ErrorAction SilentlyContinue
    if ($onPath) {
        return (Split-Path -Parent (Split-Path -Parent $onPath.Source))
    }

    # Portable JRE, e.g. ~/java/jdk-21.0.11+10-jre. Newest name wins.
    $portable = Get-ChildItem (Join-Path $env:USERPROFILE 'java') -Directory `
        -Filter 'jdk-*' -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending
    foreach ($dir in $portable) {
        if (Test-Path (Join-Path $dir.FullName 'bin\java.exe')) {
            return $dir.FullName
        }
    }

    throw 'No JDK found. Set JAVA_HOME, put java on PATH, or unpack a ' +
          "portable Temurin build under $env:USERPROFILE\java\jdk-<version>."
}

function Use-JavaHome {
    <#
    .SYNOPSIS
    Points JAVA_HOME at a discovered JDK and prepends its bin to PATH.

    .DESCRIPTION
    Environment changes are process-scoped in PowerShell, so this affects only
    this script run and the children it spawns — nothing leaks to the shell.
    #>
    # Not $home — that is a read-only automatic variable in PowerShell.
    $javaHome = Get-JavaHome
    $env:JAVA_HOME = $javaHome
    $env:PATH = (Join-Path $javaHome 'bin') + ';' + $env:PATH
    return $javaHome
}

function Get-ToolCacheDir {
    <#
    .SYNOPSIS
    A per-user cache directory for downloaded tooling, created on demand.
    Kept out of the repo so it survives a clean checkout and is never
    committed.
    #>
    param([string]$Name)

    $dir = Join-Path $env:LOCALAPPDATA 'congregation-scheduler-tools'
    if ($Name) { $dir = Join-Path $dir $Name }
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    return $dir
}

function Invoke-Native {
    <#
    .SYNOPSIS
    Runs a native command and throws on a non-zero exit code.

    .EXAMPLE
    Invoke-Native { npm test } 'rules tests'
    #>
    param(
        [Parameter(Mandatory)][scriptblock]$Command,
        [string]$What = 'command'
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$What failed (exit code $LASTEXITCODE)."
    }
}

function Write-Step {
    param([string]$Message)
    Write-Host ''
    Write-Host "==> $Message" -ForegroundColor Cyan
}

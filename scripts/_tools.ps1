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

function Get-UserHome {
    <#
    .SYNOPSIS
    The user's home directory, on Windows and on the Linux CI runners alike.
    #>
    if ($env:USERPROFILE) { return $env:USERPROFILE }
    return $HOME
}

function Get-FlutterExe {
    <#
    .SYNOPSIS
    Path to the flutter launcher: PATH first, then the user-profile install.
    #>
    $onPath = Get-Command flutter -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }

    # This dev box has Flutter under the user profile and not on PATH for
    # shells opened before the install. On CI it is always on PATH.
    $profileCopy = Join-Path (Get-UserHome) 'flutter/bin/flutter.bat'
    if (Test-Path $profileCopy) { return $profileCopy }

    throw 'Flutter not found. Install it, or put flutter on PATH.'
}

function Get-JavaHome {
    <#
    .SYNOPSIS
    A JDK/JRE home: $env:JAVA_HOME, then java on PATH, then the newest
    portable Temurin build under ~/java.
    #>
    # $IsWindows exists only in PowerShell 6+; 5.1 is Windows by definition,
    # and StrictMode would throw on the bare reference.
    $onWindows = $true
    if (Test-Path Variable:IsWindows) { $onWindows = $IsWindows }
    $exe = if ($onWindows) { 'java.exe' } else { 'java' }

    if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME "bin/$exe"))) {
        return $env:JAVA_HOME
    }

    $onPath = Get-Command java -ErrorAction SilentlyContinue
    if ($onPath) {
        return (Split-Path -Parent (Split-Path -Parent $onPath.Source))
    }

    # Portable JRE, e.g. ~/java/jdk-21.0.11+10-jre. Globbed, not pinned: the
    # directory carries its version. Newest name wins.
    $portable = Get-ChildItem (Join-Path (Get-UserHome) 'java') -Directory `
        -Filter 'jdk-*' -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending
    foreach ($dir in $portable) {
        if (Test-Path (Join-Path $dir.FullName "bin/$exe")) {
            return $dir.FullName
        }
    }

    throw 'No JDK found. Set JAVA_HOME, put java on PATH, or unpack a ' +
          'portable Temurin build under ~/java/jdk-<version>.'
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

    $base = $env:LOCALAPPDATA
    if (-not $base) { $base = Join-Path (Get-UserHome) '.cache' }
    $dir = Join-Path $base 'congregation-scheduler-tools'
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

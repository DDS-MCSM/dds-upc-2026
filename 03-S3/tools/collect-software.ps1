<#
.SYNOPSIS
    Collects a local software inventory (Windows) and writes it as JSON.

.DESCRIPTION
    Read-only. No dependencies: Windows PowerShell 5.1 or PowerShell 7 is enough.
    No admin rights needed; if Get-AppxPackage -AllUsers is denied, it falls back
    to the current user's packages and records the fact in "Errors".

    Output (UTF-8 without BOM):
      CollectedAt  ISO 8601 timestamp
      Tools        [ {Name, Available, Path, Version} ]  selected CLI tools
      Appx         [ {Name, Version, Publisher, InstallLocation} ]  Microsoft Store packages
      Programs     [ {DisplayName, DisplayVersion, Publisher, InstallDate} ]  registry Uninstall (HKLM, 64+32 bit)
      Errors       [ {Source, Message} ]  empty when everything worked

    The file contains machine-specific data (paths, installed software).
    It stays on the machine that produced it: do not commit, upload or share it.

.PARAMETER OutputPath
    Where to write the JSON. Default: .\outputs\raw-software.json (created if missing).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\collect-software.ps1
#>
[CmdletBinding()]
param([string]$OutputPath = ".\outputs\raw-software.json")
$ErrorActionPreference = 'Stop'

$commands = 'git', 'python', 'node', 'npm', 'az', 'azd', 'docker', 'kubectl', 'rg', 'pwsh'
$errors = New-Object System.Collections.Generic.List[object]

function Add-CollectError([string]$Source, [string]$Message) {
    # Keep the message short: first line only, 200 chars max.
    $short = ($Message -split "`r?`n")[0].Trim()
    if ($short.Length -gt 200) { $short = $short.Substring(0, 200) }
    $errors.Add([pscustomobject]@{ Source = $Source; Message = $short })
}

# Normalised to strings: PackageVersion is an object in PS 7, InstallDate is a DWORD in some keys.
$appxProps = @(
    'Name',
    @{ n = 'Version'; e = { "$($_.Version)" } },
    'Publisher',
    'InstallLocation'
)

# --- Appx (Microsoft Store packages) ---
$appx = @()
try {
    $appx = @(Get-AppxPackage -AllUsers -ErrorAction Stop | Select-Object $appxProps)
}
catch {
    Add-CollectError 'Appx' "Get-AppxPackage -AllUsers failed, fell back to current user: $($_.Exception.Message)"
    try { $appx = @(Get-AppxPackage -ErrorAction Stop | Select-Object $appxProps) }
    catch { Add-CollectError 'Appx' "Get-AppxPackage failed: $($_.Exception.Message)" }
}

# --- Programs (registry Uninstall keys; HKCU per-user installs are not read) ---
$uninstallKeys = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$programs = @()
try {
    $regErrors = $null
    $programs = @(
        Get-ItemProperty -Path $uninstallKeys -ErrorAction SilentlyContinue -ErrorVariable regErrors |
            Where-Object { $_.DisplayName } |
            Select-Object DisplayName, DisplayVersion, Publisher,
                @{ n = 'InstallDate'; e = { if ($null -ne $_.InstallDate) { "$($_.InstallDate)" } else { $null } } }
    )
    if ($regErrors) { Add-CollectError 'Programs' "$($regErrors.Count) registry key(s) unreadable: $($regErrors[0].Exception.Message)" }
}
catch {
    Add-CollectError 'Programs' "Registry query failed: $($_.Exception.Message)"
}

# --- Tools (CLI availability and version) ---
$tools = @(
    foreach ($name in $commands) {
        $c = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
        $version = $null
        if ($c) {
            if ($c.Version -and $c.Version.ToString() -ne '0.0.0.0') { $version = $c.Version.ToString() }
            elseif ($c.Source -and (Test-Path -LiteralPath $c.Source)) {
                $version = (Get-Item -LiteralPath $c.Source).VersionInfo.FileVersion
            }
        }
        [pscustomobject]@{
            Name      = $name
            Available = [bool]$c
            Path      = if ($c -and $c.Source) { $c.Source } else { $null }
            Version   = $version
        }
    }
)

$data = [ordered]@{
    CollectedAt = (Get-Date).ToString('o')
    Tools       = $tools
    Appx        = $appx
    Programs    = $programs
    Errors      = $errors.ToArray()
}

# GetUnresolvedProviderPathFromPSPath resolves against the current PowerShell location
# (GetFullPath would use the process directory, which can differ).
$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
$dir = Split-Path -Parent $fullPath
if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

# UTF-8 without BOM (Set-Content -Encoding UTF8 adds a BOM in Windows PowerShell 5.1).
$json = $data | ConvertTo-Json -Depth 4
[IO.File]::WriteAllText($fullPath, $json, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ("Wrote {0}: {1} programs, {2} appx, {3} tools, {4} error(s)." -f $fullPath, $programs.Count, $appx.Count, $tools.Count, $errors.Count)

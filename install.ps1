#requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('all', 'claude', 'codex')]
    [string]$Agent = 'all',
    # A custom root is useful for inspecting a copy without changing installed skills.
    [ValidateNotNullOrEmpty()]
    [string]$InstallRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$skillName = 'natural-korean'
$sourceDirectory = Join-Path $PSScriptRoot 'skills\natural-korean'
# Install the reference before the entry point that reads it.
$skillFiles = @('references\rules.json', 'SKILL.md')
foreach ($relativeFile in $skillFiles) {
    $sourceFile = Join-Path $sourceDirectory $relativeFile
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
        throw "Missing source file: $sourceFile. Download the whole repository."
    }
}

$customRoot = $PSBoundParameters.ContainsKey('InstallRoot')
if ($customRoot) {
    if ($InstallRoot -notmatch '^(?:[A-Za-z]:[\\/]|\\\\)') {
        throw 'InstallRoot must be an absolute Windows path.'
    }
    $userDirectory = [IO.Path]::GetFullPath($InstallRoot)
}
else {
    $userDirectory = [Environment]::GetFolderPath('UserProfile')
}
if ([string]::IsNullOrWhiteSpace($userDirectory)) {
    throw 'The current user profile directory could not be determined.'
}

function Get-ContentDigest {
    param([string]$Path)
    $algorithm = [Security.Cryptography.SHA256]::Create()
    $stream = $null
    try {
        $stream = [IO.File]::OpenRead($Path)
        return [BitConverter]::ToString($algorithm.ComputeHash($stream))
    }
    finally {
        if ($null -ne $stream) { $stream.Dispose() }
        $algorithm.Dispose()
    }
}

function Assert-SkillTarget {
    param([string]$SkillDirectory)

    foreach ($directory in @($SkillDirectory, (Join-Path $SkillDirectory 'references'))) {
        $item = Get-Item -LiteralPath $directory -Force -ErrorAction SilentlyContinue
        if ($null -ne $item) {
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Resolve the existing symbolic link before installing: $directory"
            }
            if (-not $item.PSIsContainer) { throw "Expected a directory at: $directory" }
        }
    }
    foreach ($relativeFile in $skillFiles) {
        $destination = Join-Path $SkillDirectory $relativeFile
        $item = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
        if ($null -ne $item) {
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Resolve the existing symbolic link before installing: $destination"
            }
            if ($item.PSIsContainer) { throw "Expected a regular file at: $destination" }
        }
    }
}

function Install-SkillFile {
    param(
        [string]$AgentName,
        [string]$SkillDirectory,
        [string]$RelativeFile
    )

    $sourceFile = Join-Path $sourceDirectory $RelativeFile
    $sourceHash = Get-ContentDigest -Path $sourceFile
    $destination = Join-Path $SkillDirectory $RelativeFile
    $existingFile = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
    if ($null -ne $existingFile) {
        if ((Get-ContentDigest -Path $destination) -eq $sourceHash) {
            Write-Output "Already current [$AgentName]: $destination"
            return
        }
    }

    $destinationDirectory = Split-Path -Parent $destination
    $null = [IO.Directory]::CreateDirectory($destinationDirectory)
    $temporaryFile = Join-Path $destinationDirectory ('.natural-korean.' + [Guid]::NewGuid().ToString('N') + '.tmp')
    $backupFile = $null
    try {
        [IO.File]::Copy($sourceFile, $temporaryFile, $false)
        if ($null -ne $existingFile) {
            $backupFile = $destination + '.backup.' + [Guid]::NewGuid().ToString('N')
            [IO.File]::Replace($temporaryFile, $destination, $backupFile)
        }
        else {
            [IO.File]::Move($temporaryFile, $destination)
        }
    }
    finally {
        if (Test-Path -LiteralPath $temporaryFile -PathType Leaf) {
            Remove-Item -LiteralPath $temporaryFile
        }
    }

    if ($null -ne $backupFile) {
        Write-Output "Backup: $backupFile"
    }
    Write-Output "Installed [$AgentName]: $destination"
}

function Install-Skill {
    param([string]$AgentName, [string]$SkillDirectory)
    foreach ($relativeFile in $skillFiles) {
        Install-SkillFile -AgentName $AgentName -SkillDirectory $SkillDirectory -RelativeFile $relativeFile
    }
}

if ($Agent -eq 'all' -or $Agent -eq 'claude') {
    $claudeDirectory = if ($customRoot) { $null } else { $env:CLAUDE_CONFIG_DIR }
    if ([string]::IsNullOrWhiteSpace($claudeDirectory)) {
        $claudeDirectory = Join-Path $userDirectory '.claude'
    }
    if ($claudeDirectory -notmatch '^(?:[A-Za-z]:[\\/]|\\\\)') {
        throw 'CLAUDE_CONFIG_DIR must be an absolute Windows path when set.'
    }
    $claudeSkillDirectory = Join-Path $claudeDirectory "skills\$skillName"
    Assert-SkillTarget -SkillDirectory $claudeSkillDirectory
}

if ($Agent -eq 'all' -or $Agent -eq 'codex') {
    $codexSkillDirectory = Join-Path $userDirectory ".agents\skills\$skillName"
    Assert-SkillTarget -SkillDirectory $codexSkillDirectory
}

if ($Agent -eq 'all' -or $Agent -eq 'claude') {
    Install-Skill -AgentName 'Claude Code' -SkillDirectory $claudeSkillDirectory
}
if ($Agent -eq 'all' -or $Agent -eq 'codex') {
    Install-Skill -AgentName 'Codex' -SkillDirectory $codexSkillDirectory
}
if ($customRoot) {
    Write-Output 'Custom root populated; these directories are not automatically registered.'
    return
}
Write-Output ''
Write-Output 'Open a new session if the skill is not listed.'
Write-Output 'Claude Code: /natural-korean'
Write-Output 'Codex: $natural-korean'

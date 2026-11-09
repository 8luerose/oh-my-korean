#requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('all', 'claude', 'codex')]
    [string]$Agent = 'all'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$skillName = 'natural-korean'
$sourceFile = Join-Path $PSScriptRoot 'skills\natural-korean\SKILL.md'
if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
    throw "Missing source file: $sourceFile. Download the whole repository."
}

$userDirectory = [Environment]::GetFolderPath('UserProfile')
if ([string]::IsNullOrWhiteSpace($userDirectory)) {
    throw 'The current user profile directory could not be determined.'
}
$sourceHash = (Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash

function Install-Skill {
    param(
        [string]$AgentName,
        [string]$SkillDirectory
    )

    $destination = Join-Path $SkillDirectory 'SKILL.md'
    $existingFile = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
    if ($null -ne $existingFile) {
        if ($existingFile.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "Resolve the existing symbolic link before installing: $destination"
        }
        if ($existingFile.PSIsContainer) {
            throw "Expected a regular file at: $destination"
        }
        if ((Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash -eq $sourceHash) {
            Write-Output "Already current [$AgentName]: $destination"
            return
        }
    }

    $null = [IO.Directory]::CreateDirectory($SkillDirectory)
    $temporaryFile = Join-Path $SkillDirectory ('.SKILL.md.' + [Guid]::NewGuid().ToString('N') + '.tmp')
    $backupFile = $null
    try {
        [IO.File]::Copy($sourceFile, $temporaryFile, $false)
        if ($null -ne $existingFile) {
            $backupFile = Join-Path $SkillDirectory ('SKILL.md.backup.' + [Guid]::NewGuid().ToString('N'))
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

if ($Agent -eq 'all' -or $Agent -eq 'claude') {
    $claudeDirectory = $env:CLAUDE_CONFIG_DIR
    if ([string]::IsNullOrWhiteSpace($claudeDirectory)) {
        $claudeDirectory = Join-Path $userDirectory '.claude'
    }
    if ($claudeDirectory -notmatch '^(?:[A-Za-z]:[\\/]|\\\\)') {
        throw 'CLAUDE_CONFIG_DIR must be an absolute Windows path when set.'
    }
    Install-Skill -AgentName 'Claude Code' -SkillDirectory (Join-Path $claudeDirectory "skills\$skillName")
}

if ($Agent -eq 'all' -or $Agent -eq 'codex') {
    Install-Skill -AgentName 'Codex' -SkillDirectory (Join-Path $userDirectory ".agents\skills\$skillName")
}

Write-Output ''
Write-Output 'Open a new session if the skill is not listed.'
Write-Output 'Claude Code: /natural-korean'
Write-Output 'Codex: $natural-korean'

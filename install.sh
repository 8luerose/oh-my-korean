#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: bash install.sh [--agent all|claude|codex]

Install natural-korean for the current user on macOS, WSL, or Linux.
The default is both Claude Code and Codex.
On native Windows, run install.ps1 in PowerShell.
USAGE
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

agent=all
while [ "$#" -gt 0 ]; do
    case "$1" in
        --agent)
            [ "$#" -ge 2 ] || fail '--agent requires all, claude, or codex.'
            agent=$2
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            fail "Unknown option: $1. Use --help for usage."
            ;;
    esac
done

case "$agent" in
    all|claude|codex) ;;
    *) fail "Unknown agent: $agent. Choose all, claude, or codex." ;;
esac

case "$(uname -s)" in
    Darwin|Linux) ;;
    *) fail 'Use install.ps1 in PowerShell on native Windows.' ;;
esac

user_directory=${HOME:-}
case "$user_directory" in
    /*) ;;
    *) fail 'HOME must contain an absolute path to your user directory.' ;;
esac

script_directory=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
skill_name=natural-korean
source_file="$script_directory/skills/$skill_name/SKILL.md"
[ -f "$source_file" ] || fail "Missing source file: $source_file. Download the whole repository."

temporary_file=
cleanup() {
    if [ -n "$temporary_file" ]; then
        rm -f -- "$temporary_file"
    fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

install_skill() {
    local agent_name=$1
    local skill_directory=$2
    local destination="$skill_directory/SKILL.md"
    local backup_file=

    [ ! -L "$destination" ] || fail "Resolve the existing symbolic link before installing: $destination"
    if [ -e "$destination" ] && [ ! -f "$destination" ]; then
        fail "Expected a regular file at: $destination"
    fi
    if [ -f "$destination" ] && cmp -s "$source_file" "$destination"; then
        printf 'Already current [%s]: %s\n' "$agent_name" "$destination"
        return
    fi

    mkdir -p -- "$skill_directory"
    temporary_file=$(mktemp "$skill_directory/.SKILL.md.XXXXXXXX")
    cp -- "$source_file" "$temporary_file"
    chmod 644 "$temporary_file"

    if [ -f "$destination" ]; then
        backup_file=$(mktemp "$skill_directory/SKILL.md.backup.XXXXXXXX")
        if ! cp -- "$destination" "$backup_file"; then
            rm -f -- "$backup_file"
            fail "Could not back up: $destination"
        fi
        printf 'Backup: %s\n' "$backup_file"
    fi

    mv -f -- "$temporary_file" "$destination"
    temporary_file=
    printf 'Installed [%s]: %s\n' "$agent_name" "$destination"
}

if [ "$agent" = all ] || [ "$agent" = claude ]; then
    claude_directory=${CLAUDE_CONFIG_DIR:-"$user_directory/.claude"}
    case "$claude_directory" in
        /*) ;;
        *) fail 'CLAUDE_CONFIG_DIR must be an absolute path when set.' ;;
    esac
    install_skill 'Claude Code' "$claude_directory/skills/$skill_name"
fi

if [ "$agent" = all ] || [ "$agent" = codex ]; then
    install_skill 'Codex' "$user_directory/.agents/skills/$skill_name"
fi

printf '\nOpen a new session if the skill is not listed.\n'
printf '%s\n' 'Claude Code: /natural-korean' 'Codex: $natural-korean'

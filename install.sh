#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: bash install.sh [--agent all|claude|codex] [--install-root /absolute/path]

Install natural-korean for the current user on macOS, WSL, or Linux.
The default is both Claude Code and Codex.
On native Windows, run install.ps1 in PowerShell.
--install-root places .claude and .agents under that directory instead of
your home directory, and ignores CLAUDE_CONFIG_DIR. It does not register
those custom directories with either app.
USAGE
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

agent=all
install_root=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --agent)
            [ "$#" -ge 2 ] || fail '--agent requires all, claude, or codex.'
            agent=$2
            shift 2
            ;;
        --install-root)
            [ "$#" -ge 2 ] || fail '--install-root requires an absolute path.'
            [ -n "$2" ] || fail '--install-root must not be empty.'
            install_root=$2
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

user_directory=${install_root:-${HOME:-}}
case "$user_directory" in
    /*) ;;
    *) fail 'HOME or --install-root must contain an absolute path.' ;;
esac

script_directory=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
skill_name=natural-korean
source_directory="$script_directory/skills/$skill_name"
# Install the reference before the entry point that reads it.
skill_files=('references/rules.json' 'SKILL.md')
for relative_file in "${skill_files[@]}"; do
    [ -f "$source_directory/$relative_file" ] || fail "Missing source file: $source_directory/$relative_file. Download the whole repository."
done

temporary_file=
cleanup() {
    if [ -n "$temporary_file" ]; then
        rm -f -- "$temporary_file"
    fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

check_target() {
    local skill_directory=$1
    local relative_file
    local destination
    [ ! -L "$skill_directory" ] || fail "Resolve the existing symbolic link before installing: $skill_directory"
    if [ -e "$skill_directory" ] && [ ! -d "$skill_directory" ]; then
        fail "Expected a directory at: $skill_directory"
    fi
    [ ! -L "$skill_directory/references" ] || fail "Resolve the existing symbolic link before installing: $skill_directory/references"
    if [ -e "$skill_directory/references" ] && [ ! -d "$skill_directory/references" ]; then
        fail "Expected a directory at: $skill_directory/references"
    fi
    for relative_file in "${skill_files[@]}"; do
        destination="$skill_directory/$relative_file"
        [ ! -L "$destination" ] || fail "Resolve the existing symbolic link before installing: $destination"
        if [ -e "$destination" ] && [ ! -f "$destination" ]; then
            fail "Expected a regular file at: $destination"
        fi
    done
}

install_file() {
    local agent_name=$1
    local skill_directory=$2
    local relative_file=$3
    local source_file="$source_directory/$relative_file"
    local destination="$skill_directory/$relative_file"
    local destination_directory
    local backup_file=
    if [ -f "$destination" ] && cmp -s "$source_file" "$destination"; then
        printf 'Already current [%s]: %s\n' "$agent_name" "$destination"
        return
    fi

    destination_directory=$(dirname -- "$destination")
    mkdir -p -- "$destination_directory"
    temporary_file=$(mktemp "$destination_directory/.natural-korean.XXXXXXXX")
    cp -- "$source_file" "$temporary_file"
    chmod 644 "$temporary_file"

    if [ -f "$destination" ]; then
        backup_file=$(mktemp "$destination.backup.XXXXXXXX")
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

install_skill() {
    local relative_file
    for relative_file in "${skill_files[@]}"; do
        install_file "$1" "$2" "$relative_file"
    done
}

if [ "$agent" = all ] || [ "$agent" = claude ]; then
    if [ -n "$install_root" ]; then
        claude_directory="$user_directory/.claude"
    else
        claude_directory=${CLAUDE_CONFIG_DIR:-"$user_directory/.claude"}
    fi
    case "$claude_directory" in
        /*) ;;
        *) fail 'CLAUDE_CONFIG_DIR must be an absolute path when set.' ;;
    esac
    check_target "$claude_directory/skills/$skill_name"
fi

if [ "$agent" = all ] || [ "$agent" = codex ]; then
    check_target "$user_directory/.agents/skills/$skill_name"
fi

if [ "$agent" = all ] || [ "$agent" = claude ]; then
    install_skill 'Claude Code' "$claude_directory/skills/$skill_name"
fi
if [ "$agent" = all ] || [ "$agent" = codex ]; then
    install_skill 'Codex' "$user_directory/.agents/skills/$skill_name"
fi

if [ -n "$install_root" ]; then
    printf '\nCustom root populated; these directories are not automatically registered.\n'
    exit 0
fi
printf '\nOpen a new session if the skill is not listed.\n'
printf '%s\n' 'Claude Code: /natural-korean' 'Codex: $natural-korean'

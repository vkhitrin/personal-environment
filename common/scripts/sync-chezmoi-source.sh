#!/usr/bin/env bash
set -eo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <before-backup|before-restore|after-backup>" >&2
    exit 1
fi

SYNC_PHASE="$1"
ICLOUD_DIR="${HOME}/.iCloudDrive"

case "${SYNC_PHASE}" in
    before-backup|before-restore|after-backup)
        ;;
    *)
        echo "Usage: $0 <before-backup|before-restore|after-backup>" >&2
        exit 1
        ;;
esac

sync_linux() {
    local filters_file="${HOME}/.config/rclone/icloud-filters.txt"

    if command -v systemctl >/dev/null 2>&1 \
        && systemctl --user cat rclone-icloud-bisync.service >/dev/null 2>&1; then
        systemctl --user start --wait rclone-icloud-bisync.service
        return
    fi

    command -v rclone >/dev/null 2>&1 || {
        echo "Cannot synchronize iCloud: rclone is not installed" >&2
        exit 1
    }

    [ -f "${filters_file}" ] || {
        echo "Cannot synchronize iCloud: ${filters_file} is missing" >&2
        exit 1
    }

    mkdir -p "${ICLOUD_DIR}"

    rclone bisync icloud: "${ICLOUD_DIR}" \
        -MvP \
        --create-empty-src-dirs \
        --compare size,modtime \
        --filters-file "${filters_file}" \
        --checkers 16 \
        --transfers 4 \
        --conflict-resolve newer \
        --conflict-loser delete \
        --conflict-suffix 'sync-conflict-{DateOnly}-' \
        --suffix-keep-extension \
        --resilient \
        --recover \
        --no-slow-hash \
        --fix-case
}

sync_macos() {
    local timeout_seconds="${ICLOUD_SYNC_TIMEOUT_SECONDS:-120}"
    local deadline
    local status

    command -v brctl >/dev/null 2>&1 || {
        echo "Cannot synchronize iCloud: brctl is not installed" >&2
        exit 1
    }

    case "${timeout_seconds}" in
        ""|*[!0-9]*)
            echo "ICLOUD_SYNC_TIMEOUT_SECONDS must be a positive integer" >&2
            exit 1
            ;;
    esac

    [ "${timeout_seconds}" -gt 0 ] || {
        echo "ICLOUD_SYNC_TIMEOUT_SECONDS must be a positive integer" >&2
        exit 1
    }

    brctl accounts --wait >/dev/null
    deadline=$((SECONDS + timeout_seconds))

    while [ "${SECONDS}" -lt "${deadline}" ]; do
        status="$(brctl status 2>&1)" || true
        if printf '%s\n' "${status}" | grep -q 'caught-up'; then
            return
        fi
        sleep 2
    done

    echo "Timed out waiting for iCloud Drive to synchronize" >&2
    exit 1
}

printf 'Synchronizing chezmoi source %s...\n' "${SYNC_PHASE}"

case "$(uname -s)" in
    Darwin)
        sync_macos
        ;;
    Linux)
        sync_linux
        ;;
    *)
        echo "Cannot synchronize iCloud on unsupported operating system: $(uname -s)" >&2
        exit 1
        ;;
esac

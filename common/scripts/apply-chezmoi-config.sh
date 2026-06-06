#!/usr/bin/env bash
set -eo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <repo-root>" >&2
    exit 1
fi

REPO_ROOT="$1"
CONFIG_HELPER="${REPO_ROOT}/common/scripts/ensure-chezmoi-config.sh"
SYNC_HELPER="${REPO_ROOT}/common/scripts/sync-chezmoi-source.sh"
SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-${HOME}/.iCloudDrive/OperatingSystems/Chezmoi}"

command -v chezmoi >/dev/null 2>&1 || {
    echo "chezmoi is not installed" >&2
    exit 1
}

"${SYNC_HELPER}" before-restore

if [ ! -f "${SOURCE_DIR}/.chezmoiroot" ] || [ ! -d "${SOURCE_DIR}/home" ]; then
    echo "chezmoi source state is not available at ${SOURCE_DIR}" >&2
    exit 1
fi

CONFIG_FILE="$("${CONFIG_HELPER}" "${SOURCE_DIR}")"

chezmoi --config "${CONFIG_FILE}" apply --verbose

if [ -n "$(chezmoi --config "${CONFIG_FILE}" status)" ]; then
    echo "chezmoi still reports pending changes after restore" >&2
    exit 1
fi

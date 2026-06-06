#!/usr/bin/env bash
set -eo pipefail

if [ "$#" -ne 0 ]; then
    echo "Usage: $0" >&2
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_HELPER="${REPO_ROOT}/common/scripts/ensure-chezmoi-config.sh"
SYNC_HELPER="${REPO_ROOT}/common/scripts/sync-chezmoi-source.sh"
SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-${HOME}/.iCloudDrive/OperatingSystems/Chezmoi}"
COMMON_BACKUP_PATHS_FILE="${REPO_ROOT}/common/.chezmoi/backup-paths"
PLATFORM_BACKUP_PATHS_FILE=""

case "$(uname -s)" in
    Darwin)
        PLATFORM_BACKUP_PATHS_FILE="${REPO_ROOT}/os/darwin/macOS/.chezmoi/backup-paths"
        ;;
    Linux)
        if [ -r /etc/os-release ]; then
            DISTRO_ID="$(sed -n 's/^ID=//p' /etc/os-release | tr -d "\"'")"
            PLATFORM_BACKUP_PATHS_FILE="${REPO_ROOT}/os/linux/${DISTRO_ID}/.chezmoi/backup-paths"
        fi
        ;;
esac

command -v chezmoi >/dev/null 2>&1 || {
    echo "chezmoi is not installed" >&2
    exit 1
}

"${SYNC_HELPER}" before-backup

if [ ! -f "${SOURCE_DIR}/.chezmoiroot" ] || [ ! -d "${SOURCE_DIR}/home" ]; then
    echo "chezmoi source state is not available at ${SOURCE_DIR}" >&2
    exit 1
fi

CONFIG_FILE="$("${CONFIG_HELPER}" "${SOURCE_DIR}")"
UNMANAGED_PATHS_FILE="$(mktemp)"
trap 'rm -f "${UNMANAGED_PATHS_FILE}"' EXIT

add_unmanaged_files() {
    local backup_paths_file="$1"
    local relative_path
    local target_path
    local unmanaged_path

    [ -f "${backup_paths_file}" ] || return 0

    while IFS= read -r relative_path || [ -n "${relative_path}" ]; do
        case "${relative_path}" in
            ""|\#*)
                continue
                ;;
            /*|../*|*/../*|*/..|..)
                echo "Invalid chezmoi backup path: ${relative_path}" >&2
                return 1
                ;;
        esac

        target_path="${HOME}/${relative_path}"
        if [ ! -e "${target_path}" ] && [ ! -L "${target_path}" ]; then
            continue
        fi

        chezmoi --config "${CONFIG_FILE}" unmanaged \
            --path-style absolute \
            --nul-path-separator \
            "${target_path}" > "${UNMANAGED_PATHS_FILE}"

        while IFS= read -r -d '' unmanaged_path; do
            printf 'Adding unmanaged chezmoi file: %s\n' "${unmanaged_path#"${HOME}/"}"
            chezmoi --config "${CONFIG_FILE}" add "${unmanaged_path}"
        done < "${UNMANAGED_PATHS_FILE}"
    done < "${backup_paths_file}"
}

add_unmanaged_files "${COMMON_BACKUP_PATHS_FILE}"
[ -z "${PLATFORM_BACKUP_PATHS_FILE}" ] || add_unmanaged_files "${PLATFORM_BACKUP_PATHS_FILE}"

chezmoi --config "${CONFIG_FILE}" re-add --verbose

"${SYNC_HELPER}" after-backup

rm -f "${UNMANAGED_PATHS_FILE}"
trap - EXIT

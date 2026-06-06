#!/usr/bin/env bash
set -eo pipefail

if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [source-dir]" >&2
    exit 1
fi

SOURCE_DIR="${1:-${HOME}/.iCloudDrive/OperatingSystems/Chezmoi}"
CONFIG_DIR="${HOME}/.config/chezmoi"
CONFIG_FILE="${CONFIG_DIR}/chezmoi.toml"
REPO_CHEZMOI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.chezmoi" && pwd)"
SOURCE_DIR="$(mkdir -p "$(dirname "${SOURCE_DIR}")" && cd "$(dirname "${SOURCE_DIR}")" && printf '%s/%s\n' "$(pwd)" "$(basename "${SOURCE_DIR}")")"

mkdir -p "${CONFIG_DIR}" "${SOURCE_DIR}/home"

if [ ! -e "${SOURCE_DIR}/.chezmoiroot" ]; then
    printf 'home\n' > "${SOURCE_DIR}/.chezmoiroot"
fi

if [ -e "${REPO_CHEZMOI_DIR}/home/.chezmoiignore.tmpl" ]; then
    cp "${REPO_CHEZMOI_DIR}/home/.chezmoiignore.tmpl" "${SOURCE_DIR}/home/.chezmoiignore.tmpl"
fi

cat > "${CONFIG_FILE}" <<EOF
sourceDir = "${SOURCE_DIR}"
destinationDir = "${HOME}"
EOF

printf '%s\n' "${CONFIG_FILE}"

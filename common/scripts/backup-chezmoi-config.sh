#!/usr/bin/env bash
set -eo pipefail

if [ "$#" -ne 0 ]; then
    echo "Usage: $0" >&2
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_HELPER="${REPO_ROOT}/common/scripts/ensure-chezmoi-config.sh"
CONFIG_FILE="$("${CONFIG_HELPER}")"

chezmoi --config "${CONFIG_FILE}" re-add --verbose

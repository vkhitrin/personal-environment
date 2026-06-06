#!/usr/bin/env bash
set -eo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <repo-root>" >&2
    exit 1
fi

REPO_ROOT="$1"
CONFIG_HELPER="${REPO_ROOT}/common/scripts/ensure-chezmoi-config.sh"
CONFIG_FILE="$("${CONFIG_HELPER}")"

chezmoi --config "${CONFIG_FILE}" apply --verbose

#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

REPO_ROOT="$(cd "$(pwd)/../../.." && pwd)"

print_padded_title "Configuration - restore chezmoi source state"
"${REPO_ROOT}/common/scripts/apply-chezmoi-config.sh" "${REPO_ROOT}"

open raycast://extensions/raycast/raycast/import-settings-data

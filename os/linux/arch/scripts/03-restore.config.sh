#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Ensure iCloud is enabled on system
rclone config show icloud: >/dev/null || error_exit "iCloud is not enabled on the system"

print_padded_title "Configuration - sync chezmoi configuration"
REPO_ROOT="$(cd "$(pwd)/../../.." && pwd)"

print_padded_title "Configuration - restore chezmoi source state"
"${REPO_ROOT}/common/scripts/apply-chezmoi-config.sh" "${REPO_ROOT}"

#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" "${HOME}/Library/Preferences/MobileMeAccounts.plist" | grep 'authMechanism = token' >/dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"

print_padded_title "Configuration - sync chezmoi configuration"
REPO_ROOT="$(cd "$(pwd)/../../.." && pwd)"

print_padded_title "Configuration - restore chezmoi source state"
"${REPO_ROOT}/common/scripts/apply-chezmoi-config.sh" "${REPO_ROOT}"

open raycast://extensions/raycast/raycast/import-settings-data

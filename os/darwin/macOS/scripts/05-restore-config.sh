#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" "${HOME}/Library/Preferences/MobileMeAccounts.plist" | grep 'authMechanism = token' >/dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"

print_padded_title "Configuration - sync mackup configuration"
REPO_ROOT="$(cd "$(pwd)/../../.." && pwd)"
cp -f "${REPO_ROOT}/common/.mackup.cfg" "${HOME}/.mackup-shared.cfg"
cp -f .mackup.cfg "${HOME}/.mackup.cfg"
rm -rf "${HOME}/.mackup"
mkdir -p "${HOME}/.mackup"
if [ -d "${REPO_ROOT}/common/.mackup" ]; then
  cp -rf "${REPO_ROOT}/common/.mackup/." "${HOME}/.mackup/"
fi
if [ -d .mackup ]; then
  cp -rf .mackup/. "${HOME}/.mackup/"
fi
mkdir -p "${HOME}/.iCloudDrive/OperatingSystems/Cross-Platform/Mackup"
mkdir -p "${HOME}/.iCloudDrive/OperatingSystems/macOS/Mackup"
cp -rf "${HOME}/.mackup" "${HOME}/.iCloudDrive/OperatingSystems/Cross-Platform/Mackup/.mackup"
cp -rf "${HOME}/.mackup" "${HOME}/.iCloudDrive/OperatingSystems/macOS/Mackup/.mackup"

print_padded_title "Configuration - migrate shared mackup paths"
COMMON_MACKUP_DIR="${HOME}/.iCloudDrive/OperatingSystems/Cross-Platform/Mackup"
mkdir -p "${COMMON_MACKUP_DIR}/.config"
[ -e "${COMMON_MACKUP_DIR}/Library/Application Support/lspmux" ] && mv -n "${COMMON_MACKUP_DIR}/Library/Application Support/lspmux" "${COMMON_MACKUP_DIR}/.config/lspmux"
[ -e "${COMMON_MACKUP_DIR}/Library/Application Support/k9s" ] && mv -n "${COMMON_MACKUP_DIR}/Library/Application Support/k9s" "${COMMON_MACKUP_DIR}/.config/k9s"
[ -e "${COMMON_MACKUP_DIR}/Library/Application Support/snipkit" ] && mv -n "${COMMON_MACKUP_DIR}/Library/Application Support/snipkit" "${COMMON_MACKUP_DIR}/.config/snipkit"

print_padded_title "Configuration - restore shared mackup backups"
${HOMEBREW_BIN_PATH_PREFIX}/mackup --config-file "${HOME}/.mackup-shared.cfg" restore -vf && ${HOMEBREW_BIN_PATH_PREFIX}/mackup --config-file "${HOME}/.mackup-shared.cfg" link uninstall --force

print_padded_title "Configuration - restore macOS mackup backups"
${HOMEBREW_BIN_PATH_PREFIX}/mackup restore -vf && ${HOMEBREW_BIN_PATH_PREFIX}/mackup link uninstall --force
open raycast://extensions/raycast/raycast/import-settings-data

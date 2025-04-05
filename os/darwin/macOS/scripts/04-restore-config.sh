#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" "${HOME}/Library/Preferences/MobileMeAccounts.plist" | grep 'authMechanism = token' > /dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"a

print_padded_title "Configuration - restore mackup backups"
cp -f .mackup.cfg "${HOME}/"
rm -rf "${HOME}/.mackup"
cp -rf .mackup "$HOME/.mackup"
${HOMEBREW_BIN_PATH_PREFIX}/mackup restore -vf && ${HOMEBREW_BIN_PATH_PREFIX}/mackup uninstall --force
open raycast://extensions/raycast/raycast/import-settings-data

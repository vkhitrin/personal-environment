#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Ensure iCloud is enabled on system
rclone config show icloud: >/dev/null || error_exit "iCloud is not enabled on the system"

print_padded_title "Configuration - restore mackup backups"
cp -f .mackup.cfg "${HOME}/"
rm -rf "${HOME}/.mackup"
cp -rf .mackup "$HOME/.mackup"
mackup restore -vf

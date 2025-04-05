#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "iCloud - Check"
[ -d "${HOME}/.iCloudDrive" ] || error_exit "iCloud symlink doesn't exist"
[ -d "${HOME}/.iCloudDrive/Operating Systems/macOS/Scripts" ] || error_exit "Scripts directory doesn't exist in iCloud"

print_padded_title "iCloud - Execute Private Script"
[ -f "${HOME}/.iCloudDrive/Operating Systems/macOS/Scripts/install-private-customizations.sh" ] || error_exit "Private script doesn't exist"
"${HOME}/.iCloudDrive/Operating Systems/macOS/Scripts/install-private-customizations.sh"

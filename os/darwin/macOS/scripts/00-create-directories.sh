#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" "${HOME}/Library/Preferences/MobileMeAccounts.plist" | grep 'authMechanism = token' > /dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"a

# If Xcode is not installed, we wish to skip Developer related items from Spotlight search
print_padded_title "Workarounds - /Applications/Xcode.app"
[ -d "/Applications/Xcode.app" ] || mkdir /Applications/Xcode.app

# Create symlink to iCloud Drive
print_padded_title "Directories - .iCloud"
[ -d "$HOME/.iCloudDrive" ] || ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/.iCloudDrive"

# Create Directories
print_padded_title "Directories - Projects"
mkdir -p "$HOME/Projects/Automation" "$HOME/Projects/Development" "$HOME/Projects/Containers" "$HOME/Documents/Screenshots"

print_padded_title "Directories - .local"
mkdir -p "$HOME/.local/bin"

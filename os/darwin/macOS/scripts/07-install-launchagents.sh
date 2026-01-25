#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# NOTE: Removing chroma for now, dropping VectorCode
# print_padded_title "LaunchAgent - chromadb"
# [ -f "./launchctl/com.vkhitrin.chromadb.plist" ] || error_exit "plist doesn't exist"
# mkdir -p "${HOME}/.local/state/chroma/log" "${HOME}/.local/state/chroma/data"
# eval "echo \"$(cat ./launchctl/com.vkhitrin.chromadb.plist)\"" > "${HOME}/Library/LaunchAgents/com.vkhitrin.chromadb.plist"
# launchctl unload "${HOME}/Library/LaunchAgents/com.vkhitrin.chromadb.plist"
# launchctl bootstrap "gui/${UID}" "${HOME}/Library/LaunchAgents/com.vkhitrin.chromadb.plist"

# NOTE: 'vdirsyncer metasync' and 'vidrsyncer' sync are not automated, this has to be done manually
print_padded_title "LaunchAgent - vdirsyncer"
[ -f "./launchctl/com.vkhitrin.vdirsyncer.plist" ] || error_exit "plist doesn't exist"
mkdir -p "${HOME}/.local/state/vdirsyncer/log"
eval "echo \"$(cat ./launchctl/com.vkhitrin.vdirsyncer.plist)\"" > "${HOME}/Library/LaunchAgents/com.vkhitrin.vdirsyncer.plist"
launchctl unload "${HOME}/Library/LaunchAgents/com.vkhitrin.vdirsyncer.plist"
launchctl bootstrap "gui/${UID}" "${HOME}/Library/LaunchAgents/com.vkhitrin.vdirsyncer.plist"
#
print_padded_title "LaunchAgent - opencode"
[ -f "./launchctl/com.vkhitrin.opencode.plist" ] || error_exit "plist doesn't exist"
mkdir -p "${HOME}/.local/state/opencode/plist-log"
eval "echo \"$(cat ./launchctl/com.vkhitrin.opencode.plist)\"" > "${HOME}/Library/LaunchAgents/com.vkhitrin.opencode.plist"
launchctl unload "${HOME}/Library/LaunchAgents/com.vkhitrin.opencode.plist"
launchctl bootstrap "gui/${UID}" "${HOME}/Library/LaunchAgents/com.vkhitrin.opencode.plist"

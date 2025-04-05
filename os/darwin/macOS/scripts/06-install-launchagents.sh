#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "LaunchAgent - chromadb"
[ -f "./launchctl/com.vkhitrin.chromadb.plist" ] || error_exit "plist doesn't exist"
mkdir -p "${HOME}/.local/state/chroma/log" "${HOME}/.local/state/chroma/data"
eval "echo \"$(cat ./launchctl/com.vkhitrin.chromadb.plist)\"" > "${HOME}/Library/LaunchAgents/com.vkhitrin.chromadb.plist"
launchctl load "${HOME}/Library/LaunchAgents/com.vkhitrin.chromadb.plist"

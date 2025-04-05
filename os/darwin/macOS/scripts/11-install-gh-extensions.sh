#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "gh - Install GitHub CLI Extensions"
if [ -f /opt/homebrew/bin/gh ]; then
    gh extension install --force yusukebe/gh-markdown-preview || true
    gh extension install --force dlvhdr/gh-dash || true
fi

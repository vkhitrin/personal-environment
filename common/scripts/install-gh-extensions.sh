#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "gh - Install GitHub CLI Extensions"
if [ -f "${BIN_DIR}/gh" ]; then
    "${BIN_DIR}/gh" extension install --force yusukebe/gh-markdown-preview || true
    "${BIN_DIR}/gh" extension install --force dlvhdr/gh-dash || true
fi

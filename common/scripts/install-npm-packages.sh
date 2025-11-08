#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "npm - Install Additional Software"
"${BIN_DIR}/npm" install --global  @mermaid-js/mermaid-cli @rushdigital/confluence-cli

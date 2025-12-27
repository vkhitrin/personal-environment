#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "npm - Install Additional Software"
"${BIN_DIR}/npm" install --global @mermaid-js/mermaid-cli@latest \
	confluence-cli@latest \
	semantic-memory@latest

print_padded_title "bun - Install Additional Software"
"${BIN_DIR}/bun" install --global opencode-swarm-plugin@latest \
	git@github.com:shuv1337/oc-manager

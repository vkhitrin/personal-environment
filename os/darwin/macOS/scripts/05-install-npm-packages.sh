#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "Brew npm - Install Additional Software"
npm install --global --upgrade hostile @mermaid-js/mermaid-cli

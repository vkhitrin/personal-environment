#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "cargo - Install Additional Software"
cargo install mise

print_padded_title "cargo - Install Completions"
mise completion zsh | sudo tee "${ZSH_COMPLETIONS}/_mise"

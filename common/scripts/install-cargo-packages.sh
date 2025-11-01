#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "cargo - Install Additional Software"
# NOTE: latest release of mise has issues inside tmux https://github.com/jdx/mise/discussions/6824
cargo install mise@2025.10.19 usage-cli
cargo install --git https://github.com/daxartio/kdbx

print_padded_title "cargo - Install Completions"
mise completion zsh | ${ZSH_COMPLETIONS_BECOME_COMMAND} tee "${ZSH_COMPLETIONS}/_mise"
kdbx completion --shell zsh | ${ZSH_COMPLETIONS_BECOME_COMMAND} tee "${ZSH_COMPLETIONS}/_kdbx"

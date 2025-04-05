#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

# Install Tmux Plugin Manager
print_padded_title "tmux - Install Plugin Manager 'tpm'"
[ -d "${HOME}/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install tmux plugins
print_padded_title "tmux - Install Plugins"
"${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh"

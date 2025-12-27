#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

# Install Tmux Plugin Manager
print_padded_title "tmux - Install Plugin Manager 'tpm'"
[ -d "${HOME}/.local/share/tmux" ] || git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux

# Install tmux plugins
print_padded_title "tmux - Install Plugins"
export TMUX_PLUGIN_MANAGER_PATH="${HOME}/.local/share/tmux/plugins"
"${HOME}/.local/share/tmux/plugins/tpm/scripts/install_plugins.sh"

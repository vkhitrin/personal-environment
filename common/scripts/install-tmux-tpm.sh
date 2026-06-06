#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

TMUX_BASE_DIR="${HOME}/.local/share/tmux"
TMUX_PLUGIN_MANAGER_PATH="${TMUX_BASE_DIR}/plugins"
TPM_DIR="${TMUX_PLUGIN_MANAGER_PATH}/tpm"
TPM_RUNNER="${TMUX_BASE_DIR}/tpm"

# Install Tmux Plugin Manager
print_padded_title "tmux - Install Plugin Manager 'tpm'"
mkdir -p "${TMUX_PLUGIN_MANAGER_PATH}"
[ -d "${TPM_DIR}" ] || git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"

if [ -L "${TPM_RUNNER}" ]; then
    rm "${TPM_RUNNER}"
fi

cat > "${TPM_RUNNER}" <<EOF
#!/usr/bin/env bash
exec "${TPM_DIR}/tpm" "\$@"
EOF
chmod +x "${TPM_RUNNER}"

# Install tmux plugins
print_padded_title "tmux - Install Plugins"
export TMUX_PLUGIN_MANAGER_PATH
"${TPM_DIR}/scripts/install_plugins.sh"

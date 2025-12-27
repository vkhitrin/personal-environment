set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${NODE_MODULES_DIR}" ] && error_exit "Environment variable 'NODE_MODULES_DIR' is not defined"

print_padded_title "ubs - Install From Script"
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" |
	bash -s -- --easy-mode || true
print_padded_title "cass - Install From Script"
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh |
	bash -s -- --easy-mode --verify
"${HOME}/.local/bin/cass" completions zsh | ${ZSH_COMPLETIONS_BECOME_COMMAND} tee "${ZSH_COMPLETIONS}/_cass"
print_padded_title "bv - Install From Script"
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/beads_viewer/main/install.sh?$(date +%s)" | bash

print_padded_title "opencode swarm - Workaround"
if [ -d "${NODE_MODULES_DIR}/opencode-swarm-plugin" ]; then
	cd "${NODE_MODULES_DIR}/opencode-swarm-plugin"
	bun install
fi

print_padded_title "olama - fetch models"
if [[ $(which ollama) ]] 2>/dev/null; then
	ollama pull nomic-embed-text
fi

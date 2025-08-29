#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

print_padded_title "Directories - Projects"
mkdir -p "${HOME}/.zshrc.d/fzf/"
print_padded_title "fzf - Downloading Scripts"
curl -s 'https://raw.githubusercontent.com/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh' -o "${HOME}/.zshrc.d/fzf/fzf-git.sh"

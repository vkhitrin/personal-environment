#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "Directories - Create catppuccin based dir"
mkdir -p "${HOME}/Projects/Personal/Themes/catppuccin"

print_padded_title "catppuccin - bat"
[ -f "${HOME}/.config/bat/themes/Catppuccin Mocha.tmTheme" ] && "${BIN_DIR}/bat" cache --build

print_padded_title "catppuccin - kubecolor"
[ -d "${HOME}/Projects/Personal/Themes/catppuccin/kubecolor-catppuccin" ] || git clone https://github.com/vkhitrin/kubecolor-catppuccin "${HOME}/Projects/Personal/Themes/catppuccin/kubecolor-catppuccin"
cp "${HOME}/Projects/Personal/Themes/catppuccin/kubecolor-catppuccin/catppuccin-mocha.yaml" "${HOME}/.kube/color.yaml"

print_padded_title "catppuccin - snippetslab"
[[ $(uname) == "Darwin" ]] || exit 0
[ -d "${HOME}/Projects/Personal/Themes/catppuccin/snippetslab-catpuccin" ] || git clone https://github.com/vkhitrin/snippetslab-catpuccin "${HOME}/Projects/Personal/Themes/catppuccin/snippetslab-catpuccin"

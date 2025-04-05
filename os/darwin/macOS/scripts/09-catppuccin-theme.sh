#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# print_padded_title "catppuccin - Jupyter"
# ${HOMEBREW_CELLAR_PATH_PREFIX}/jupyterlab/4.2.1/libexec/bin/python -m pip install catppuccin-jupyterlab
# /usr/bin/python3 -m pip install --break-system-packages --upgrade catppuccin-jupyterlab
print_padded_title "catppuccin - bat"
[ -f "${HOME}/.config/bat/themes/Catppuccin-mocha.tmTheme" ] && bat cache --build
print_padded_title "catppuccin - zsh fast-syntax-highlighting"
[ -f "${HOME}/.config/fsh/catppuccin-mocha.ini" ] && echo "Run the following from a zsh shell: fast-theme XDG:catppuccin-mocha"

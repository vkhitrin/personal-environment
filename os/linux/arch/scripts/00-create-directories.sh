#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Create Directories
print_padded_title "Directories - Projects"
mkdir -p "$HOME/Projects/Automation" "$HOME/Projects/Development" "$HOME/Projects/Containers" "$HOME/Documents/Screenshots"

print_padded_title "Directories - .local"
mkdir -p "$HOME/.local/bin"

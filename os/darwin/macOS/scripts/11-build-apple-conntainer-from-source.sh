#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "git - Clone https://github.com/apple/container"
if [ ! -d "${HOME}/Projects/Personal/Applications/Apple/container" ]; then
    git clone https://github.com/apple/container
fi
cd "${HOME}/Projects/Personal/Applications/Apple/container"
git pull

print_padded_title "container - Compile and Install"
BUILD_CONFIGURATION=release make build install

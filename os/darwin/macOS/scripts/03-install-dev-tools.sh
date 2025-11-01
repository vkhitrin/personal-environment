#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "rustup - Link brew rust"
rustup toolchain link system "$(brew --prefix rust)"

print_padded_title "rustup - Bootstrap"
rustup-init -y -q --no-modify-path

print_padded_title "rustup - Update"
rustup update

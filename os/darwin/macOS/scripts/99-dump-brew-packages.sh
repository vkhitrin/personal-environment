#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

brew bundle dump --all --force
# NOTE: Workaround to delete empty Brewfile generated in root working directory of the repository
cd "$(git rev-parse --show-toplevel)" && rm Brewfile

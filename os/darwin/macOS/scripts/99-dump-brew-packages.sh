#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

brew bundle dump --no-go --no-cargo --no-uv --no-krew --force
# sed '/mas.*/d' Brewfile
# NOTE: Workaround to delete empty Brewfile generated in root working directory of the repository
cd "$(git rev-parse --show-toplevel)" && rm Brewfile

#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

brew bundle dump --all --force

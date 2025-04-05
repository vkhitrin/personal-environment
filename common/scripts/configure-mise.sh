#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[[ -z "${MISE_SHELL}" ]] && error_exit "MISE_SHELL is not set. Assuming mise is not initialized."

mise plugins install opentofu poetry --force

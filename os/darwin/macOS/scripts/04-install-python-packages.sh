#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

print_padded_title "Brew uv - Install Additional Software"
declare -a UV_PACKAGES
declare -a UV_HARLEQUIN_EXTRA_ARGS
UV_PACKAGES=("passhole")
UV_HARLEQUIN_EXTRA_ARGS=("--with boto3" "--with harlequin-postgres" "--with harlequin-mysql" "--with harlequin-odbc")
for UV_PACKAGE in "${UV_PACKAGES[@]}"; do
    "${HOMEBREW_BIN_PATH_PREFIX}/uv" tool install -U "${UV_PACKAGE}"
done
"${HOMEBREW_BIN_PATH_PREFIX}/uv" tool install -U harlequin ${UV_HARLEQUIN_EXTRA_ARGS[@]}

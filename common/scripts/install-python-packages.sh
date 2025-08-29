#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

print_padded_title "uv - Install Additional Software"
declare -a UV_PACKAGES
declare -a UV_HARLEQUIN_EXTRA_ARGS
UV_PACKAGES=("chromadb==0.6.3" "vectorcode[lsp,mcp]" "posting" "git+https://github.com/whyisdifficult/jiratui")
UV_HARLEQUIN_EXTRA_ARGS=("--with boto3" "--with harlequin-postgres" "--with harlequin-mysql" "--with harlequin-odbc" "--with harlequin-adbc" "--with adbc-driver-postgresql")
for UV_PACKAGE in "${UV_PACKAGES[@]}"; do
	"${BIN_DIR}/uv" tool install -U "${UV_PACKAGE}"
done
"${BIN_DIR}/uv" tool install -U harlequin ${UV_HARLEQUIN_EXTRA_ARGS[@]}

print_padded_title "python - Install Additional Shell Completions"
vectorcode --print-completion zsh | ${ZSH_COMPLETIONS_BECOME_COMMAND} tee "${ZSH_COMPLETIONS}/_vectorcode"

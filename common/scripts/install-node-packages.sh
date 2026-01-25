#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

npm install -g firecrawl-cli@latest

if [[ "$(uname -s)" == "Darwin" ]]; then
    print_padded_title "macOS - Workaround"
    FIRECRAWL_CONFIG_DIR="${HOME}/.config/firecrawl-cli"
    FIRECRAWL_MACOS_CONFIG_DIR="${HOME}/Library/Application Support/firecrawl-cli"

    mkdir -p "${FIRECRAWL_CONFIG_DIR}"

    if [[ -e "${FIRECRAWL_MACOS_CONFIG_DIR}" && ! -L "${FIRECRAWL_MACOS_CONFIG_DIR}" ]]; then
        cp -a "${FIRECRAWL_MACOS_CONFIG_DIR}/." "${FIRECRAWL_CONFIG_DIR}/"
        rm -rf "${FIRECRAWL_MACOS_CONFIG_DIR}"
    fi

    ln -sfn "${FIRECRAWL_CONFIG_DIR}" "${FIRECRAWL_MACOS_CONFIG_DIR}"
fi

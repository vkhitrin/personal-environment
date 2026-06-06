#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

if [[ "$(uname -s)" != "Darwin" ]]; then
    export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-${HOME}/.local}"
    mkdir -p "${NPM_CONFIG_PREFIX}/bin"
fi

"${BIN_DIR}/npm" install -g firecrawl-cli@latest @earendil-works/pi-coding-agent@latest

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

#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh
source ./scripts/zsh-completions.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

HELM_PLUGIN_VERIFY="${HELM_PLUGIN_VERIFY:-false}"

function helm_plugin_installed {
    "${BIN_DIR}/helm" plugin list | grep "^$1[[:space:]]" >/dev/null 2>/dev/null
}

function helm_plugin_install_or_update {
    local name="$1"
    local url="$2"

    if helm_plugin_installed "${name}"; then
        if ! "${BIN_DIR}/helm" plugin update "${name}"; then
            echo "Failed to update Helm plugin '${name}', reinstalling..." >&2
            "${BIN_DIR}/helm" plugin uninstall "${name}"
            "${BIN_DIR}/helm" plugin install "${url}" --verify="${HELM_PLUGIN_VERIFY}"
        fi
    else
        "${BIN_DIR}/helm" plugin install "${url}" --verify="${HELM_PLUGIN_VERIFY}"
    fi
}

# Kubernetes krew plugins
print_padded_title "krew - Install/Upgrade Kubernetes CLI Extensions Using krew"
if [[ $(which kubectl-krew) ]] 2>/dev/null; then
    "${BIN_DIR}/kubectl-krew" update
    "${BIN_DIR}/kubectl-krew" install browse-pvc cert-manager ctr deprecations dup get-all graph history images node-admin node-logs node-restart node-shell nodepools resource-capacity restart sick-pods unlimited view-secret viewnode tree blame df-pv
    "${BIN_DIR}/kubectl-krew" upgrade
fi

# helm plugins
print_padded_title "helm - Install/Upgrade Helm Plugins"
if [[ $(which helm) ]] 2>/dev/null; then
    helm_plugin_install_or_update diff https://github.com/databus23/helm-diff
    install_zsh_completion helm_diff "${BIN_DIR}/helm" diff completion zsh

    helm_plugin_install_or_update cm-push https://github.com/chartmuseum/helm-push

    helm_plugin_install_or_update drift https://github.com/nikhilsbhat/helm-drift
    install_zsh_completion helm_drift "${BIN_DIR}/helm" drift completion zsh

    helm_plugin_install_or_update schema https://github.com/losisin/helm-values-schema-json.git
    helm_plugin_install_or_update unittest https://github.com/helm-unittest/helm-unittest
fi

#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

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
            "${BIN_DIR}/helm" plugin install "${url}"
        fi
    else
        "${BIN_DIR}/helm" plugin install "${url}"
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
    "${BIN_DIR}/helm" diff completion zsh | ${ZSH_COMPLETIONS_BECOME_COMMAND} tee "${ZSH_COMPLETIONS}/_helm_diff"

    helm_plugin_install_or_update cm-push https://github.com/chartmuseum/helm-push

    helm_plugin_install_or_update drift https://github.com/nikhilsbhat/helm-drift
    "${BIN_DIR}/helm" drift completion zsh | ${ZSH_COMPLETIONS_BECOME_COMMAND} tee "${ZSH_COMPLETIONS}/_helm_drift"

    helm_plugin_install_or_update schema https://github.com/losisin/helm-values-schema-json.git
    helm_plugin_install_or_update unittest https://github.com/helm-unittest/helm-unittest
fi

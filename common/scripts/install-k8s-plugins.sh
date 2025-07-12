#!/usr/bin/env bash
set -eo pipefail

[ -n "${COMMON_BASE_DIR}" ] && cd "${COMMON_BASE_DIR}"

source ./scripts/common.sh

[ -z "${BIN_DIR}" ] && error_exit "Environment variable 'BIN_DIR' is not defined"

# Kubernetes krew plugins
print_padded_title "krew - Install Kubernetes CLI Extensions Using krew"
if [[ $(which kubectl-krew) ]] 2>/dev/null; then
    "${BIN_DIR}/kubectl-krew" install browse-pvc cert-manager ctr deprecations dup get-all graph history images node-admin node-logs node-restart node-shell nodepools resource-capacity restart sick-pods unlimited view-secret viewnode tree blame df-pv
fi

# helm plugins
print_padded_title "helm - Install Helm Plugins"
if [[ $(which helm) ]] 2>/dev/null; then
    "${BIN_DIR}/helm" plugin list | grep diff >/dev/null 2>/dev/null || "${BIN_DIR}/helm" plugin install https://github.com/databus23/helm-diff
    "${BIN_DIR}/helm" diff completion zsh | sudo tee "${ZSH_COMPLETIONS}/_helm_diff"
    "${BIN_DIR}/helm" plugin list | grep cm-push >/dev/null 2>/dev/null || "${BIN_DIR}/helm" plugin install https://github.com/chartmuseum/helm-push
    "${BIN_DIR}/helm" plugin list | grep drift >/dev/null 2>/dev/null || "${BIN_DIR}/helm" plugin install https://github.com/nikhilsbhat/helm-drift
    "${BIN_DIR}/helm" drift completion zsh | sudo tee "${ZSH_COMPLETIONS}/_helm_drift"
    "${BIN_DIR}/helm" plugin list | grep schema >/dev/null 2>/dev/null || "${BIN_DIR}/helm" plugin install https://github.com/losisin/helm-values-schema-json.git
    "${BIN_DIR}/helm" plugin list | grep unittest >/dev/null 2>/dev/null || "${BIN_DIR}/helm" plugin install https://github.com/helm-unittest/helm-unittest
    "${BIN_DIR}/helm" plugin update diff
    "${BIN_DIR}/helm" plugin update cm-push
    "${BIN_DIR}/helm" plugin update drift
    "${BIN_DIR}/helm" plugin update schema
    "${BIN_DIR}/helm" plugin update unittest
fi

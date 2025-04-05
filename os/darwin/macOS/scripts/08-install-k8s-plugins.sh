#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Kubernetes krew plugins
print_padded_title "krew - Install Kubernetes CLI Extensions Using krew"
if [ -f /opt/homebrew/bin/kubectl-krew ]; then
    kubectl krew install browse-pvc cert-manager ctr deprecations dup get-all graph history images node-admin node-logs node-restart node-shell nodepools resource-capacity restart sick-pods unlimited view-secret viewnode tree blame df-pv
fi

# helm plugins
print_padded_title "helm - Install Helm Plugins"
if [ -f /opt/homebrew/bin/helm ]; then
    helm plugin list | grep diff >/dev/null 2>/dev/null || helm plugin install https://github.com/databus23/helm-diff
    helm diff completion zsh > /opt/homebrew/share/zsh-completions/_helm_diff
    helm plugin list | grep cm-push >/dev/null 2>/dev/null || helm plugin install https://github.com/chartmuseum/helm-push
    helm plugin list | grep drift >/dev/null 2>/dev/null || helm plugin install https://github.com/nikhilsbhat/helm-drift
    helm drift completion zsh > /opt/homebrew/share/zsh-completions/_helm_drift
    helm plugin list | grep schema >/dev/null 2>/dev/null || helm plugin install https://github.com/losisin/helm-values-schema-json.git
    helm plugin list | grep secrets >/dev/null 2>/dev/null || helm plugin install https://github.com/jkroepke/helm-secrets
fi

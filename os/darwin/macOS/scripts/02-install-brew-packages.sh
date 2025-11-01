#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Verify brew is installed
which brew >/dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"
# Verify podman is installed
# which podman >/dev/null 2>/dev/null || error_exit "podman is not installed, please install from brew."

# We use podman to build SF Mono patched fonts
# print_padded_title "macos - Ensure Podman Machine Is Running (Only If Needed)"
# if [[ ! -d "/opt/homebrew/Caskroom/font-sf-mono-nerd-font" && -z "${SKIP_PODMAN_CHECK}" ]]; then
#     if [[ $(podman machine info --format '{{ .Host.MachineState }}') != "Running" ]]; then
#         error_exit "Please ensure local podman machine is running, or skip check using SKIP_PODMAN_CHECK environment variable."
#     fi
# fi

# Disable brew analytics
print_padded_title "Brew - Disable Analytics"
brew analytics off

# Update brew
print_padded_title "Brew - Update"
brew update

print_padded_title "Brew - Install Packages"
[ -f Brewfile ] || error_exit "No Brewfile is found"
brew bundle --quiet --file=Brewfile

# NOTE: With brew release 4.6.18-50-g0d9b9b4, it attempts to reinstall the packages all the time, and it fails to overwrite.
#       Revisit this in the future.
print_padded_title "Brew - Upgrade HEAD Formulae"
# brew upgrade --fetch-HEAD
# WARN: Workaround until brew is fixed
brew outdated --fetch-HEAD | awk '{print $1}' | xargs -n1 brew upgrade --fetch-HEAD || true

# print_padded_title "Brew - Start Services"
# brew services start borders

# Soft links
print_padded_title "Brew - Soft Links"
ln -sf /opt/homebrew/bin/yt-dlp /opt/homebrew/bin/youtube-dl
ln -sf /opt/homebrew/bin/tofu "$HOME/.local/bin/terraform"

# Cleanup brew
print_padded_title "Brew - Cleanup"
brew cleanup --prune=all
brew autoremove

print_padded_title "Brew - Manpages"
which jira >/dev/null 2>/dev/null && jira man --generate --output /opt/homebrew/share/man/man7/

# Brew completions
print_padded_title "Brew - Completions"
brew generate-man-completions || true
# Link shipped brew completions
brew completions link
# Add completions to tools that are not shipped by zsh-completions or brew
snipkit completion zsh >/opt/homebrew/share/zsh-completions/_snipkit
gitlab-ci-local --completion >/opt/homebrew/share/zsh-completions/_gitlab-ci-local
which istioctl >/dev/null 2>/dev/null && istioctl completion zsh >/opt/homebrew/share/zsh-completions/_istioctl
jira completion zsh >/opt/homebrew/share/zsh-completions/_jira
op completion zsh >/opt/homebrew/share/zsh-completions/_op
acli completion zsh >/opt/homebrew/share/zsh-completions/_acli
# [ -f "/opt/homebrew/share/zsh-completions/_virtctl" ] || virtctl completion zsh > /opt/homebrew/share/zsh-completions/_virtctl
print_padded_title "Brew - Notes"
echo "Please run the following to enable completions:"
echo "compaudit | xargs chmod g-w"

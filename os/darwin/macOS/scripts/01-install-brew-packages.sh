#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh
source ../../../common/scripts/zsh-completions.sh

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

# Migrate from the deprecated beads tap shim to the Homebrew core formula.
if brew list --formula steveyegge/beads/bd >/dev/null 2>&1; then
    print_padded_title "Brew - Migrate Beads Formula"
    brew uninstall --formula steveyegge/beads/bd
fi
for legacy_beads_tap in gastownhall/beads steveyegge/beads; do
    if brew tap | grep -qx "${legacy_beads_tap}"; then
        brew untap "${legacy_beads_tap}"
    fi
done

print_padded_title "Brew - Install Packages"
[ -f Brewfile ] || error_exit "No Brewfile is found"
brew bundle --quiet --file=Brewfile --upgrade --force

# brew bundle upgrades Brewfile entries, but not every outdated transitive
# formula. Upgrade those before asking cleanup to remove their older kegs.
print_padded_title "Brew - Upgrade Formula Dependencies"
brew upgrade --formula --no-ask
# print_padded_title "Brew - Upgrade HEAD Formulae"
# brew upgrade --fetch-HEAD

# Soft links
print_padded_title "Brew - Soft Links"
ln -sf /opt/homebrew/bin/yt-dlp /opt/homebrew/bin/youtube-dl
ln -sf /opt/homebrew/bin/tofu "${HOME}/.local/bin/terraform"
ln -sf "$(brew --prefix llvm)/bin/clang-format" "${HOME}/.local/bin/clang-format"
ln -sf "$(brew --prefix llvm)/bin/clang-tidy" "${HOME}/.local/bin/clang-tidy"
ln -sf "$(brew --prefix llvm)/bin/clang-apply-replacements" "${HOME}/.local/bin/clang-apply-replacements"

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
brew completions link || true

function install_brew_zsh_completion {
    local completion_name="$1"
    shift
    local formula_completion="${HOMEBREW_PATH_PREFIX}/share/zsh/site-functions/_${completion_name}"

    if [[ -e "${formula_completion}" ]]; then
        printf 'Using formula-provided zsh completion: %s\n' "${formula_completion}"
        return
    fi
    install_zsh_completion "${completion_name}" "$@"
}

# Generate only completions that are not already supplied by their formula.
# Custom definitions live under ~/.local and take precedence over the generic
# zsh-completions package without overwriting Homebrew-managed files.
install_brew_zsh_completion snipkit snipkit completion zsh
install_brew_zsh_completion gitlab-ci-local gitlab-ci-local --completion
command -v istioctl >/dev/null 2>&1 \
    && install_brew_zsh_completion istioctl istioctl completion zsh
install_brew_zsh_completion jira jira completion zsh
install_brew_zsh_completion acli acli completion zsh
install_brew_zsh_completion ast-grep ast-grep completions zsh
install_brew_zsh_completion codex codex completion zsh
install_brew_zsh_completion deck deck completion zsh

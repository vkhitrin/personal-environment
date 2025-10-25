.PHONY: common-catppuccin-theme common-configure-mise common-fzf-scripts common-install-cargo-packages common-install-gh-extensions common-install-k8s-plugins common-install-npm-packages common-install-python-packages common-install-tmux-tpm

MAKEFILE_COMMON_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export COMMON_BASE_DIR = $(MAKEFILE_COMMON_DIR)

common-install-python-packages: ##Installs python packages
	@$(MAKEFILE_COMMON_DIR)/scripts/install-python-packages.sh

common-install-npm-packages: ##Installs npm packages
	@$(MAKEFILE_COMMON_DIR)/scripts/install-npm-packages.sh

common-install-cargo-packages: ##Installs cargo packages
	@$(MAKEFILE_COMMON_DIR)/scripts/install-cargo-packages.sh

common-install-tmux-tpm: ##Installs tmux plugin manager
	@$(MAKEFILE_COMMON_DIR)/scripts/install-tmux-tpm.sh

common-install-k8s-plugins: ##Installs k8s krew plugins
	@$(MAKEFILE_COMMON_DIR)/scripts/install-k8s-plugins.sh

common-install-gh-extensions: ##Installs gh extensions
	@$(MAKEFILE_COMMON_DIR)/scripts/install-gh-extensions.sh

common-configure-mise: ##Configures mise
	@$(MAKEFILE_COMMON_DIR)/scripts/configure-mise.sh

common-catppuccin-theme: ##Apply cattppuccin theme
	@$(MAKEFILE_COMMON_DIR)/scripts/catppuccin-theme.sh

common-fzf-scripts: ##Install fzf community scripts
	@$(MAKEFILE_COMMON_DIR)/scripts/install-fzf-scripts.sh

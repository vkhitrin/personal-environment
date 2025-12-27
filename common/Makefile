MAKEFILE_COMMON_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export COMMON_BASE_DIR = $(MAKEFILE_COMMON_DIR)

.PHONY: common-install-python-packages
common-install-python-packages: ##Installs python packages
	@$(MAKEFILE_COMMON_DIR)/scripts/install-python-packages.sh

.PHONY: common-install-node-packages
common-install-node-packages: ##Installs NodeJS packages
	@$(MAKEFILE_COMMON_DIR)/scripts/install-node-packages.sh

.PHONY: common-install-cargo-packages
common-install-cargo-packages: ##Installs cargo packages
	@$(MAKEFILE_COMMON_DIR)/scripts/install-cargo-packages.sh

.PHONY: common-install-tmux-tpm
common-install-tmux-tpm: ##Installs tmux plugin manager
	@$(MAKEFILE_COMMON_DIR)/scripts/install-tmux-tpm.sh

.PHONY: common-install-k8s-plugins
common-install-k8s-plugins: ##Installs k8s krew plugins
	@$(MAKEFILE_COMMON_DIR)/scripts/install-k8s-plugins.sh

.PHONY: common-install-gh-extensions
common-install-gh-extensions: ##Installs gh extensions
	@$(MAKEFILE_COMMON_DIR)/scripts/install-gh-extensions.sh

.PHONY: common-configure-mise
common-configure-mise: ##Configures mise
	@$(MAKEFILE_COMMON_DIR)/scripts/configure-mise.sh

.PHONY: common-catppuccin-theme
common-catppuccin-theme: ##Apply cattppuccin theme
	@$(MAKEFILE_COMMON_DIR)/scripts/catppuccin-theme.sh

.PHONY: common-fzf-scripts
common-fzf-scripts: ##Install fzf community scripts
	@$(MAKEFILE_COMMON_DIR)/scripts/install-fzf-scripts.sh

.PHONY: common-setup-ai-tools
common-setup-ai-tools: ##Setup AI Tools
	@$(MAKEFILE_COMMON_DIR)/scripts/setup-ai-tools.sh

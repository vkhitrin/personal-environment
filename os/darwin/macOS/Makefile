.PHONY: .DEFAULT
.DEFAULT: help

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export BASE_DIR = $(MAKEFILE_DIR)
export BIN_DIR = $(shell brew --prefix)/bin
export NODE_MODULES_DIR = $(shell brew --prefix)/lib/node_modules
export ZSH_COMPLETIONS = $(shell brew --prefix)/share/zsh-completions

.PHONY: help
help:
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: create-directories
create-directories: ##Installs directories
	@$(MAKEFILE_DIR)/scripts/00-create-directories.sh

.PHONY: set-defaults
set-defaults: ##Sets macOS defaults
	@$(MAKEFILE_DIR)/scripts/01-set-defaults.sh

.PHONY: install-brew-packages
install-brew-packages: ##Installs brew packages
	@$(MAKEFILE_DIR)/scripts/02-install-brew-packages.sh

.PHONY: install-dev-tools
install-dev-tools: ##Installs dev tools
	@$(MAKEFILE_DIR)/scripts/03-install-dev-tools.sh

.PHONY: fetch-dotfiles
fetch-dotfiles: ##Fetch dotfiles
	@$(MAKEFILE_DIR)/scripts/04-fetch-dotfiles.sh

.PHONY: restore-config
restore-config: ##Restores config
	@$(MAKEFILE_DIR)/scripts/05-restore-config.sh

.PHONY: private-customizations
private-customizations: ##Private customizations
	@$(MAKEFILE_DIR)/scripts/06-private-customizations.sh

.PHONY: install-launchagents
install-launchagents: ##Install custom LaunchAgents
	@$(MAKEFILE_DIR)/scripts/07-install-launchagents.sh

.PHONY: customize-jupyter-env
customize-jupyter-env: ##Customizes Jupyter environment
	@$(MAKEFILE_DIR)/scripts/08-customize-jupyter-env.sh

.PHONY: customize-apple-virtualization-configuration
customize-apple-virtualization-configuration: ##Configures Apple Virtualization network configuration
	@$(MAKEFILE_DIR)/scripts/09-customize-apple-virtualization-configuration.sh

.PHONY: populate-utm-virtualmachines-in-hosts
populate-utm-virtualmachines-in-hosts: ##Populate UTM virtual machines in /etc/hosts
	@$(MAKEFILE_DIR)/scripts/10-populate-utm-virtualmachines-in-hosts.sh

create-utm-arch-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@$(MAKEFILE_DIR)/scripts/30-create-utm-arch-linux-vm.sh

create-utm-ubuntu-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@$(MAKEFILE_DIR)/scripts/30-create-utm-ubuntu-linux-vm.sh

.PHONY: dump-brew-packages
dump-brew-packages: ##Dumps brew/mas packages into Brewfile
	@$(MAKEFILE_DIR)/scripts/99-dump-brew-packages.sh > ./Brewfile

.PHONY: bootstrap-macos-environment
bootstrap-macos-environment: create-directories install-brew-packages install-dev-tools set-defaults common-install-python-packages common-install-npm-packages common-install-cargo-packages common-install-tmux-tpm common-install-k8s-plugins common-install-gh-extensions common-configure-mise common-catppuccin-theme fetch-dotfiles restore-config private-customizations install-launchagents customize-jupyter-env customize-apple-virtualization-configuration ##Bootstraps the macOS environment

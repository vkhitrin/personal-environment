.DEFAULT: help
.PHONY: create-directories set-defaults install-brew-packages fetch-dotfiles restore-config private-customizations customize-jupyter-env customize-apple-virtualization-configuration populate-utm-virtualmachines-in-hosts create-utm-arch-linux-vm create-utm-ubuntu-linux-vm dump-brew-packages boostrap-macos-environment

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export BASE_DIR = $(MAKEFILE_DIR)
export BIN_DIR = $(shell brew --prefix)/bin
export ZSH_COMPLETIONS = $(shell brew --prefix)/share/zsh-completions

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

create-directories: ##Installs directories
	@$(MAKEFILE_DIR)/scripts/00-create-directories.sh

set-defaults: ##Sets macOS defaults
	@$(MAKEFILE_DIR)/scripts/01-set-defaults.sh

install-brew-packages: ##Installs brew packages
	@$(MAKEFILE_DIR)/scripts/02-install-brew-packages.sh

fetch-dotfiles: ##Fetch dotfiles
	@$(MAKEFILE_DIR)/scripts/03-fetch-dotfiles.sh

restore-config: ##Restores config
	@$(MAKEFILE_DIR)/scripts/04-restore-config.sh

private-customizations: ##Private customizations
	@$(MAKEFILE_DIR)/scripts/05-private-customizations.sh

customize-jupyter-env: ##Customizes Jupyter environment
	@$(MAKEFILE_DIR)/scripts/06-customize-jupyter-env.sh

customize-apple-virtualization-configuration: ##Configures Apple Virtualization network configuration
	@$(MAKEFILE_DIR)/scripts/07-customize-apple-virtualization-configuration.sh

populate-utm-virtualmachines-in-hosts: ##Populate UTM virtual machines in /etc/hosts
	@$(MAKEFILE_DIR)/scripts/08-populate-utm-virtualmachines-in-hosts.sh

create-utm-arch-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@$(MAKEFILE_DIR)/scripts/30-create-utm-arch-linux-vm.sh

create-utm-ubuntu-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@$(MAKEFILE_DIR)/scripts/30-create-utm-ubuntu-linux-vm.sh

dump-brew-packages: ##Dumps brew/mas packages into Brewfile
	@$(MAKEFILE_DIR)/scripts/99-dump-brew-packages.sh > ./Brewfile

boostrap-macos-environment: create-directories install-brew-packages common-install-python-packages common-install-npm-packages common-install-tmux-tpm common-install-k8s-plugins common-install-gh-extensions common-configure-mise common-catppuccin-theme fetch-dotfiles restore-config private-customizations customize-jupyter-env customize-apple-virtualization-configuration ##Bootstraps the macOS environment 

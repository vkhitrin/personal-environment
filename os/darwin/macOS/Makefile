.DEFAULT: help
.PHONY: create-directories set-defaults install-brew-packages fetch-dotfiles install-python-packages install-npm-packages install-tmux-tpm restore-config install-k8s-plugins catppuccin-theme private-customizations install-gh-extensions customize-jupyter-env customize-apple-virtualization-configuration populate-utm-virtualmachines-in-hosts create-utm-arch-linux-vm create-utm-ubuntu-linux-vm configure-mise dump-brew-packages boostrap-macos-environment

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export BASE_DIR = $(MAKEFILE_DIR)

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

install-python-packages: ##Installs python packages
	@$(MAKEFILE_DIR)/scripts/04-install-python-packages.sh

install-npm-packages: ##Installs python packages
	@$(MAKEFILE_DIR)/scripts/05-install-npm-packages.sh

install-tmux-tpm: ##Restores configuration
	@$(MAKEFILE_DIR)/scripts/06-install-tmux-tpm.sh

restore-config: ##Restores config
	@$(MAKEFILE_DIR)/scripts/07-restore-config.sh

install-k8s-plugins: ##Installs Kubernetes related plugins
	@$(MAKEFILE_DIR)/scripts/08-install-k8s-plugins.sh

catppuccin-theme: ##Catppuccin theming
	@$(MAKEFILE_DIR)/scripts/09-catppuccin-theme.sh

private-customizations: ##Private customizations
	@$(MAKEFILE_DIR)/scripts/10-private-customizations.sh

install-gh-extensions: ##Private customizations
	@$(MAKEFILE_DIR)/scripts/11-install-gh-extensions.sh

customize-jupyter-env: ##Customizes Jupyter environment
	@$(MAKEFILE_DIR)/scripts/12-customize-jupyter-env.sh

customize-apple-virtualization-configuration: ##Configures Apple Virtualization network configuration
	@$(MAKEFILE_DIR)/scripts/13-customize-apple-virtualization-configuration.sh

populate-utm-virtualmachines-in-hosts: ##Populate UTM virtual machines in /etc/hosts
	@$(MAKEFILE_DIR)/scripts/14-populate-utm-virtualmachines-in-hosts.sh

configure-mise:  #Configures mise
	@$(MAKEFILE_DIR)/scripts/15-configure-mise.sh

create-utm-arch-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@$(MAKEFILE_DIR)/scripts/30-create-utm-arch-linux-vm.sh

create-utm-ubuntu-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@$(MAKEFILE_DIR)/scripts/30-create-utm-ubuntu-linux-vm.sh

dump-brew-packages: ##Dumps brew/mas packages into Brewfile
	@$(MAKEFILE_DIR)/scripts/99-dump-brew-packages.sh > ./Brewfile

boostrap-macos-environment: create-directories install-brew-packages  fetch-dotfiles install-python-packages install-npm-packages install-tmux-tpm restore-config install-k8s-plugins catppuccin-theme private-customizations install-gh-extensions customize-jupyter-env customize-apple-virtualization-configuration ##Bootstraps the macOS environment 

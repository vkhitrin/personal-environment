.DEFAULT: help
.PHONY: install-directories fetch-dotfiles dump-packages private-customizations

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export BASE_DIR = $(MAKEFILE_DIR)
export BIN_DIR = /usr/bin
export ZSH_COMPLETIONS = /usr/share/zsh/site-functions/

help:
	@grep -F -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | grep -F -v grep -F | sed -e 's/\\$$//' | sed -e 's/##//'

create-directories: ##Installs directories
	@$(MAKEFILE_DIR)/scripts/00-create-directories.sh

install-packages: ##Installs pacman packages
	@$(MAKEFILE_DIR)/scripts/01-install-packages.sh

fetch-dotfiles: ##Fetch dotfiles
	@$(MAKEFILE_DIR)/scripts/02-fetch-dotfiles.sh

restore-config: #Restores config
	@$(MAKEFILE_DIR)/scripts/03-restore.config.sh

private-customizations: ##Private customizations
	@$(MAKEFILE_DIR)/scripts/04-private-customizations.sh

dump-packages: ##Dumps pacman packages into a file
	@$(MAKEFILE_DIR)/scripts/99-dump-packages.sh

bootstrap-arch-linux-environment: create-directories install-packages common-install-python-packages common-install-npm-packages common-install-tmux-tpm common-install-k8s-plugins common-install-gh-extensions common-configure-mise common-catppuccin-theme fetch-dotfiles restore-config private-customizations ##Bootstraps the arch linux environment

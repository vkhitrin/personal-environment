.DEFAULT: help
.PHONY: install-directories fetch-dotfiles dump-packages

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export BASE_DIR = $(MAKEFILE_DIR)
export BIN_DIR = /usr/bin

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

dump-packages: ##Dumps pacman packages into a file
	@$(MAKEFILE_DIR)/scripts/99-dump-packages.sh

bootstrap-arch-linux-environment: create-directories install-packages fetch-dotfiles restore-config ##Bootstraps the arch linux environment

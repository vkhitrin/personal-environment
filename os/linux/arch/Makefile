.DEFAULT: help
.PHONY: install-directories fetch-dotfiles install-python-packages install-tmux-tpm install-k8s-plugins install-gh-extensions configure-mise dump-pacman-packages dump-yay-aur-packages bootstrap-arch-linux-environment

MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
export BASE_DIR = $(MAKEFILE_DIR)

help:
	@grep -F -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | grep -F -v grep -F | sed -e 's/\\$$//' | sed -e 's/##//'

create-directories: ##Installs directories
	@$(MAKEFILE_DIR)/scripts/00-create-directories.sh

install-packages: ##Installs pacman packages
	@$(MAKEFILE_DIR)/scripts/01-install-packages.sh

fetch-dotfiles: ##Fetch dotfiles
	@$(MAKEFILE_DIR)/scripts/02-fetch-dotfiles.sh

install-python-packages: ##Installs python packages
	@$(MAKEFILE_DIR)/scripts/03-install-python-packages.sh

install-tmux-tpm: ##Installs tmux plugin using tpm
	@$(MAKEFILE_DIR)/scripts/04-install-tmux-tpm.sh

install-k8s-plugins: ##Installs Kubernetes related plugins
	@$(MAKEFILE_DIR)/scripts/05-install-k8s-plugins.sh

install-gh-extensions: ##Private customizations
	@$(MAKEFILE_DIR)/scripts/06-install-gh-extensions.sh

configure-mise:  #Configures mise
	@$(MAKEFILE_DIR)/scripts/07-configure-mise.sh

restore-config: #Restores config
	@$(MAKEFILE_DIR)/scripts/08-restore.config.sh

catppuccin-theme: ##Catppuccin theming
	@$(MAKEFILE_DIR)/scripts/09-catppuccin-theme.sh

dump-pacman-packages: ##Dumps pacman packages into a file
	@$(MAKEFILE_DIR)/scripts/99-dump-pacman-packages.sh > $(MAKEFILE_DIR)/./pkglist.txt

dump-yay-aur-packages: ##Dumps yay AUR packages into a file
	@$(MAKEFILE_DIR)/scripts/99-dump-yay-aur-packages.sh > $(MAKEFILE_DIR)/./pkglist_aur.txt

dump-flatpak-packages: ##Dumps yay AUR packages into a file
	@$(MAKEFILE_DIR)/scripts/99-dump-flatpak-packages.sh > $(MAKEFILE_DIR)/./pkglist_flatpak.txt

bootstrap-arch-linux-environment: create-directories install-packages  fetch-dotfiles install-python-packages install-tmux-tpm restore-config install-k8s-plugins  install-gh-extensions  ##Bootstraps the arch linux environment

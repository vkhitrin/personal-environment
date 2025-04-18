#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

pacman -Qqm | grep -vE '\-debug$|cider' >./pkglist_aur.txt
flatpak list --app --columns=application | grep -vE 'com.system76.Cosmic.BaseApp|vkhitrin' >./pkglist_flatpak.txt
pacman -Qqe | grep -v "$(pacman -Qqm)" >./pkglist.txt

#!/usr/bin/env bash
set -eo pipefail

pacman -Qqm | grep -vE '\-debug$|cider'

#!/usr/bin/env bash
set -eo pipefail

pacman -Qqe | grep -v "$(pacman -Qqm)"

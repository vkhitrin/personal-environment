#!/usr/bin/env bash
set -eo pipefail

flatpak list --app --columns=application

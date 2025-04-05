#!/usr/bin/env bash
set -eo pipefail

export HOMEBREW_PATH_PREFIX="/opt/homebrew"
export HOMEBREW_BIN_PATH_PREFIX="${HOMEBREW_PATH_PREFIX}/bin"
export HOMEBREW_CELLAR_PATH_PREFIX="${HOMEBREW_PATH_PREFIX}/cellar"

# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2
    exit "${2:-1}"
}

# Print padded title based on terminal column size
function print_padded_title {
    termwidth="$(tput cols)"
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}
 
# Make sure script isn't executed on non macOS systems
print_padded_title "macOS Check"
if [[ $(uname) != "Darwin" ]];then
    error_exit "Please make sure you're running on macOS"
fi

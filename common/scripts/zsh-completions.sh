#!/usr/bin/env bash

# Generate a completion locally, validate it, then atomically replace the
# destination. Renaming the destination updates its directory mtime, which is
# the invalidation signal consumed by the zsh completion wordcode cache hook.
function install_zsh_completion {
    local completion_name="${1:-}"
    shift || true

    if [[ -z "${completion_name}" || ! "${completion_name}" =~ ^[A-Za-z0-9._-]+$ ]]; then
        echo "Invalid zsh completion name: '${completion_name}'" >&2
        return 1
    fi
    if [[ -z "${ZSH_COMPLETIONS:-}" ]]; then
        echo "Environment variable 'ZSH_COMPLETIONS' is not defined" >&2
        return 1
    fi
    if (( $# == 0 )); then
        echo "No completion generator supplied for '${completion_name}'" >&2
        return 1
    fi

    local completion_dir="${ZSH_COMPLETIONS%/}"
    local completion_target="${completion_dir}/_${completion_name}"
    local generated_completion
    local destination_temporary="${completion_dir}/.completion-${completion_name}.$$.$RANDOM"
    local -a become_command=()

    if [[ -n "${ZSH_COMPLETIONS_BECOME_COMMAND:-}" ]]; then
        read -r -a become_command <<<"${ZSH_COMPLETIONS_BECOME_COMMAND}"
    fi

    generated_completion="$(mktemp "${TMPDIR:-/tmp}/zsh-completion-${completion_name}.XXXXXX")" || return
    if ! "$@" >"${generated_completion}"; then
        command rm -f -- "${generated_completion}"
        echo "Failed to generate zsh completion '${completion_name}'" >&2
        return 1
    fi
    if [[ ! -s "${generated_completion}" ]]; then
        command rm -f -- "${generated_completion}"
        echo "Generated zsh completion '${completion_name}' is empty" >&2
        return 1
    fi

    "${become_command[@]}" mkdir -p -- "${completion_dir}"
    if ! "${become_command[@]}" install -m 0644 -- \
        "${generated_completion}" "${destination_temporary}"; then
        command rm -f -- "${generated_completion}"
        echo "Failed to stage zsh completion '${completion_name}'" >&2
        return 1
    fi
    if ! "${become_command[@]}" mv -f -- \
        "${destination_temporary}" "${completion_target}"; then
        "${become_command[@]}" rm -f -- "${destination_temporary}"
        command rm -f -- "${generated_completion}"
        echo "Failed to install zsh completion '${completion_name}'" >&2
        return 1
    fi

    command rm -f -- "${generated_completion}"
    printf 'Installed zsh completion: %s\n' "${completion_target}"
}

# macOS chezmoi source state

macOS uses the shared source directory documented in `common/.chezmoi/README.md`.
Put macOS-only entries under `home/Library/` in that source. The shared
`.chezmoiignore.tmpl` prevents chezmoi from applying them on Linux.

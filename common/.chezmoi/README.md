# chezmoi source state

This directory contains seed files for the chezmoi source state in
`~/.iCloudDrive/OperatingSystems/Chezmoi`.

The restore scripts create `~/.config/chezmoi/chezmoi.toml`, seed
`.chezmoiroot`, `.chezmoiignore.tmpl`, and `backup-manifest.txt`, then run
`chezmoi apply`.

Put managed home-directory files under `home/` using chezmoi source-state names,
for example:

- `home/dot_gitconfig` -> `~/.gitconfig`
- `home/dot_config/nvim/init.lua` -> `~/.config/nvim/init.lua`
- `home/Library/...` in the macOS-specific source directory for macOS-only files

The shared `.chezmoiignore.tmpl` excludes volatile local state such as kube
caches and agent sessions, and uses chezmoi template data to ignore macOS-only
paths on Linux and Linux-only paths on macOS.

Back up all managed files for the current platform with:

```sh
_backup_my_macos
_backup_my_linux
```

The backup aliases call `common/scripts/backup-chezmoi-config.sh`, which runs
`chezmoi re-add --verbose` against the configured source directory. This refreshes
files that chezmoi already manages.

Add a new managed file with regular chezmoi commands:

```sh
chezmoi add ~/.kube/config
chezmoi add ~/Library/Application\ Support/example/config.json
chezmoi add ~/.config/example/config.toml
```

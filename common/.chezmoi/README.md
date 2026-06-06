# chezmoi source state

This directory contains the shared seed files for the chezmoi source state.
Both macOS and Linux use `~/.iCloudDrive/OperatingSystems/Chezmoi` by default.
Set `CHEZMOI_SOURCE_DIR` to use another synchronized directory.

Synchronize the source directory before running a restore. The restore refuses
to run unless the directory already contains `.chezmoiroot` and `home/`. It
then writes `~/.config/chezmoi/chezmoi.toml`, refreshes `.chezmoiignore.tmpl`,
and runs `chezmoi apply`.

Put managed home-directory files under `home/` using chezmoi source-state names,
for example:

- `home/dot_gitconfig` -> `~/.gitconfig`
- `home/dot_config/nvim/init.lua` -> `~/.config/nvim/init.lua`
- `home/Library/...` for macOS-only files

The shared `.chezmoiignore.tmpl` excludes volatile local state such as kube
caches and agent sessions, and uses chezmoi template data to ignore macOS-only
paths on Linux and Linux-only paths on macOS.

Back up all managed files for the current platform with:

```sh
_backup_my_macos
_backup_my_linux
```

The backup aliases call `common/scripts/backup-chezmoi-config.sh`. The script
first synchronizes the shared source, adds unmanaged files found below the
shared and platform-specific paths listed in `.chezmoi/backup-paths`, then runs
`chezmoi re-add --verbose` to refresh files that chezmoi already manages.
Chezmoi ignore rules still exclude volatile files such as Kubernetes caches.
The command synchronizes again before it returns.

Restore synchronizes the shared source before running `chezmoi apply`, then
checks that chezmoi has no pending changes. Shared paths such as `.kube` flow in
both directions. Platform-only paths remain excluded by `.chezmoiignore.tmpl`.

Add a file or directory to the relevant `backup-paths` file when it should be
discovered automatically during backup. Keep directory scopes narrow so the
backup does not collect unrelated home-directory files.

You can also add a single managed file with regular chezmoi commands:

```sh
chezmoi add ~/.kube/config
chezmoi add ~/Library/Application\ Support/example/config.json
chezmoi add ~/.config/example/config.toml
```

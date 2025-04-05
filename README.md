# Personal Environment

> [!NOTE]
> This repository is suited for my personal workflow, and may not suit your needs.

- Each distribution imports a unique Makefile.
- Common scripts import a shared Makefile.
- Dotfiles are stored externally in a separate repository [vkhitrin/dotfiles](https://github.com/vkhitrin/dotfiles).
  Inspired by [@anandpiyer](https://github.com/anandpiyer)'s [blog post](https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles/).

## Distributions

### macOS

#### Worarounds

- <https://github.com/mas-cli/mas/issues/724>
  To install applications from the App Store, set `BREW_WORKAROUND_INSTALL_MAS` environment variable.

#### Installation

```bash
make boostrap-macos-environment
```

### Arch Linux

#### Installation

```bash
make boostrap-arch-linux-environment
```

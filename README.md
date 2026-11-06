# My Configurations (Dotfiles)

This repository contains my personal configuration files for various command-line tools and applications. It serves as a centralized place to manage and synchronize my development environment across multiple machines.

## What's Included?

This collection currently includes settings for:

- **Zsh (`zshrc`):** My main shell configuration, including aliases, functions, and Oh My Zsh plugin settings.
- **Kitty (`kitty/kitty.conf`):** Configuration for the Kitty terminal emulator, including theme and font settings.
- **Starship (`starship.toml`):** The configuration for my custom cross-shell prompt.
- **Git (`.gitconfig`):** My global Git configuration.
- **Ulauncher (`ulauncher/settings.json`, `ulauncher/extensions.json`):** Settings for the Ulauncher application launcher, including hotkeys, theme, and installed extensions.
- **Tmux (`tmux/.tmux.conf`):** Configuration for the Tmux terminal multiplexer, including mouse support, pane navigation (Ctrl+Arrows), and split shortcuts (Alt+Arrows).
- **Cheat Sheets (`cheat-sheets/`):** Quick reference guides (HTML) for the Git aliases and Tmux.
- **Scripts (`bin/`):** Personal commands, linked into `~/.local/bin`. Currently `mood`, which switches the look below.
- **Looks (`looks/`):** Matching visual styles across Claude Code (custom themes), the glowup mod (packs), Kitty (themes) and, optionally, VS Code (color themes), switched together with `mood <look>`. Installed by `./install.sh` (or on their own with `./looks/install.sh`); see [`looks/README.md`](looks/README.md) for how the pieces relate and how to add a look.
- **Installer (`install.sh`):** Links everything above into place; see [Usage](#usage).
- **`CLAUDE.md`:** Notes for Claude Code when working in this repo.

## Usage

Clone this repository and run the installer. It symlinks every config into place, then installs the looks and the `mood` command (`looks/install.sh`):

```bash
git clone https://github.com/hoisel/hoisel-configs.git ~/Dev/Personal/Github/hoisel-configs
~/Dev/Personal/Github/hoisel-configs/install.sh
```

It's safe to re-run. Links that are already correct are left alone, and any other file in the way (such as a default `~/.zshrc`) is moved to `<name>.pre-install.<timestamp>`. At the end it reports anything still missing: `~/.hoisel-secrets` (see [Secrets](#secrets)) and kitty's `current-theme.conf` (create it with `mood <look>`).

Because these are symlinks, the clone stays live. Editing a file here changes the machine, and switching branches swaps the config in use.

| Repo path | Linked at |
|---|---|
| `zshrc` | `~/.zshrc` |
| `.gitconfig` | `~/.gitconfig` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `starship.toml` | `~/.config/starship.toml` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `ulauncher/settings.json`, `ulauncher/extensions.json` | `~/.config/ulauncher/` |
| `cheat-sheets/` | `~/.hoisel/cheat-sheets` |
| `bin/mood`, `looks/…` | see [`looks/README.md`](looks/README.md) |

## Secrets

The Zsh configuration sources a `~/.hoisel-secrets` file for sensitive environment variables (API tokens, keys, etc.). This file is **not** tracked by git.

To set it up, create the file with restricted permissions:

```bash
touch ~/.hoisel-secrets
chmod 600 ~/.hoisel-secrets
```

Then add your exports:

```bash
export GITHUB_MCP_PAT=your_token_here
export ATLASSIAN_TOKEN=your_token_here
```
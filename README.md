# My Configurations (Dotfiles)

This repository contains my personal configuration files for various command-line tools and applications. It serves as a centralized place to manage and synchronize my development environment across multiple machines.

## What's Included?

This collection currently includes settings for:

- **Zsh (`zshrc`):** My main shell configuration, including aliases, functions, and Oh My Zsh plugin settings.
- **Kitty (`kitty/kitty.conf`):** Configuration for the Kitty terminal emulator, including theme and font settings.
- **Starship (`starship.toml`):** The configuration for my custom cross-shell prompt.
- **Git (`gitconfig`):** My global Git configuration.
- **Ulauncher (`ulauncher/settings.json`):** Settings for the Ulauncher application launcher, including hotkeys and theme.

## Usage

To use these configurations, clone this repository and create symbolic links from the files to the corresponding locations in your home directory.

**Example:**
```bash
# For Zsh
ln -s /path/to/hoisel-configs/zshrc ~/.zshrc

# For Kitty
ln -s /path/to/hoisel-configs/kitty/kitty.conf ~/.config/kitty/kitty.conf

# For Starship
ln -s /path/to/hoisel-configs/starship.toml ~/.config/starship.toml

# For Ulauncher
ln -s /path/to/hoisel-configs/ulauncher/settings.json ~/.config/ulauncher/settings.json
```
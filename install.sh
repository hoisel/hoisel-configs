#!/usr/bin/env bash
# Link every config in this repo into $HOME, then install the looks.
# Safe to re-run: correct links are left alone, anything else in the way is
# moved aside to <name>.pre-install.<timestamp>.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$REPO/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    echo "  ok      $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.pre-install.$STAMP"
    echo "  backup  $dst -> $dst.pre-install.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "  link    $dst -> $src"
}

echo "Configs"
link zshrc                     "$HOME/.zshrc"
link .gitconfig                "$HOME/.gitconfig"
link tmux/.tmux.conf           "$HOME/.tmux.conf"
link starship.toml             "$CONFIG/starship.toml"
link kitty/kitty.conf          "$CONFIG/kitty/kitty.conf"
link ulauncher/settings.json   "$CONFIG/ulauncher/settings.json"
link ulauncher/extensions.json "$CONFIG/ulauncher/extensions.json"
link cheat-sheets              "$HOME/.hoisel/cheat-sheets"

echo
"$REPO/looks/install.sh"

echo
if [ ! -f "$HOME/.hoisel-secrets" ]; then
  echo "note: ~/.hoisel-secrets is missing; zshrc sources it. See README > Secrets."
fi
if [ ! -f "$CONFIG/kitty/current-theme.conf" ]; then
  echo "note: kitty.conf includes current-theme.conf, which doesn't exist yet. Run \`mood <look>\` to create it."
fi

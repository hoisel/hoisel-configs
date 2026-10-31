#!/usr/bin/env bash
# Link the looks (Claude Code themes, glowup packs, kitty themes) and the `mood`
# command from this repo into $HOME. Safe to re-run: correct links are left alone,
# anything else in the way is moved aside to <name>.pre-looks.<timestamp>.
set -euo pipefail

LOOKS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$LOOKS")"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
KITTY_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    echo "  ok      $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.pre-looks.$STAMP"
    echo "  backup  $dst -> $dst.pre-looks.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "  link    $dst -> $src"
}

echo "mood command"
link "$REPO/bin/mood" "$HOME/.local/bin/mood"

# Whole directories, not files: Claude Code and glowup rewrite these files by
# writing a temp file and renaming it, which would replace a per-file symlink.
echo "Claude Code themes"
link "$LOOKS/claude-themes" "$CLAUDE_DIR/themes"

echo "glowup packs"
link "$LOOKS/glowup-packs" "$CLAUDE_DIR/glowup/packs"

# kitty only reads these, so per-file links are fine and leave the rest of
# ~/.config/kitty (kitty.conf, current-theme.conf) alone.
echo "kitty themes"
for f in "$LOOKS"/kitty/*.conf; do
  link "$f" "$KITTY_DIR/$(basename "$f")"
done

# glowup status line field order. A personal glowup setting, shared by every look.
# Written as glowup's /plugin option in settings.json; glowup applies a changed
# value at the next Claude Code session start (same as `/glowup statusline fields`).
STATUSLINE="cwd,branch,activity,effort,model,plan,agents,changes,week"
echo "glowup status line"
python3 - "$CLAUDE_DIR/settings.json" "$STATUSLINE" <<'EOF'
import json, os, shutil, sys
path, fields = sys.argv[1], sys.argv[2]
settings = {}
if os.path.exists(path):
    with open(path, encoding="utf-8") as f:
        settings = json.load(f)
opts = settings.setdefault("pluginConfigs", {}).setdefault("glowup@glowup", {}).setdefault("options", {})
if opts.get("statusline") == fields:
    print(f"  ok      statusline {fields}")
    sys.exit(0)
if os.path.exists(path):
    shutil.copy2(path, path + ".pre-looks.statusline")
opts["statusline"] = fields
os.makedirs(os.path.dirname(path), exist_ok=True)
tmp = path + ".looks.tmp"
with open(tmp, "w", encoding="utf-8") as f:
    f.write(json.dumps(settings, indent=2, ensure_ascii=False) + "\n")
os.replace(tmp, path)
print(f"  set     statusline {fields}  (applied at next Claude Code start)")
EOF

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) echo "warning: ~/.local/bin is not on PATH; add it so \`mood\` is found" ;;
esac

echo
echo "Done. Run \`mood\` to see the looks, \`mood <look>\` to apply one."

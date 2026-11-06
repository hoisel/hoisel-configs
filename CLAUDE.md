# CLAUDE.md

Personal dotfiles, used to set up new machines and keep machines in sync. The owner talks in Portuguese; files in this repo are written in English.

## This checkout is live

Every tracked config in `$HOME` is a symlink into this working tree (no plain copies), so editing a file here changes the running machine, and **switching branches swaps the live config**. Before `git switch`/`checkout`/`stash`, check what the target branch removes or changes.

| Live path | How |
|---|---|
| `~/.zshrc`, `~/.gitconfig`, `~/.tmux.conf`, `~/.config/starship.toml`, `~/.config/ulauncher/{settings,extensions}.json` | symlink to the file here |
| `~/.local/bin/mood`, `~/.config/kitty/kitty.conf`, `~/.config/kitty/*.conf` from `looks/kitty/` | symlink to the file here |
| `~/.claude/themes`, `~/.claude/glowup/packs`, `~/.hoisel/cheat-sheets`, `~/.vscode/extensions/hoisel.campfire-theme` | symlink to the **whole directory** here (`looks/claude-themes`, `looks/glowup-packs`, `cheat-sheets`, `looks/vscode/campfire`) |

`install.sh` (configs, then it calls `looks/install.sh`) is the source of truth for these links. When adding a config, add its `link` line there and update this table and the README's table together.

Claude Code and glowup save themes and packs by writing a temp file and renaming it, so they write straight into `looks/` and those changes show up in `git status`. That's expected. Never replace the directory links with per-file links; a rename would silently turn them back into plain files.

The same risk applies to file links: kitty's theme picker (`kitty +kitten themes`) rewrites the theme block in `kitty.conf`, and a tool that saves via temp file plus rename would replace the link with a plain file. After using the picker, check that `ls -la ~/.config/kitty/kitty.conf` still shows a link. The looks setup doesn't need the picker: `mood` only overwrites `current-theme.conf`.

## Git

- Work on a branch and merge through a GitHub PR (`hoisel/hoisel-configs`), as past history does; don't commit to `main`. Commit only when asked.
- Conventional commits with a scope, e.g. `feat(zshrc): …`, `docs: …`.
- The tree often has unrelated uncommitted edits (`zshrc`, `.gitconfig`, `ulauncher/extensions.json` change as the machine is used). Stage only the paths of the task at hand.
- Never commit secrets. The shell sources `~/.hoisel-secrets`, which stays out of the repo; `.claude/settings.local.json` is ignored globally.

## Looks and `mood`

`looks/README.md` is the reference (pieces, adding a look, theme keys, gotchas); keep it in sync when changing `bin/mood`, `looks/install.sh` or a look. Things that bite:

- Claude Code loads custom theme colors only at startup. After editing `looks/claude-themes/*.json`, the owner has to `/exit` and run `claude --continue`; re-picking in `/theme` doesn't reload.
- Do not edit glowup's code in `~/.claude/plugins/cache/glowup/`. Change only packs, `/glowup` settings and themes. If something can only be done in glowup's code, say so and stop.
- `/glowup color <role> <hex>` overrides survive pack switches and hide a pack's own colors.
- Scripts in `~/.local/bin` that came from pip or app installers (`srt*`, `dul-*`, `wasp`, `zen`…) don't belong in `bin/`. The `cinnamon-*.sh` scripts there were deliberately left out.

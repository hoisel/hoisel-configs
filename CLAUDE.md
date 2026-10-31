# CLAUDE.md

Personal dotfiles, used to set up new machines and keep machines in sync. The owner talks in Portuguese; files in this repo are written in English.

## This checkout is live

Most of `$HOME` points into this working tree, so editing a file here changes the running machine, and **switching branches swaps the live config**. Before `git switch`/`checkout`/`stash`, check what the target branch removes or changes.

| Live path | How |
|---|---|
| `~/.gitconfig`, `~/.tmux.conf`, `~/.config/starship.toml`, `~/.config/ulauncher/{settings,extensions}.json` | symlink to the file here |
| `~/.local/bin/mood`, `~/.config/kitty/{Sunset,Rosé Pine}.conf` | symlink to the file here |
| `~/.claude/themes`, `~/.claude/glowup/packs` | symlink to the **whole directory** here (`looks/claude-themes`, `looks/glowup-packs`) |
| `~/.zshrc`, `~/.config/kitty/kitty.conf` | **copies**, not links. They drift: compare both ways before changing either, and ask which side wins |

Claude Code and glowup save themes and packs by writing a temp file and renaming it, so they write straight into `looks/` and those changes show up in `git status`. That's expected. Never replace the directory links with per-file links; a rename would silently turn them back into plain files.

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

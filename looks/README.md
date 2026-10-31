# Looks

A **look** is one matching visual style across three tools that don't know about each other:

| Piece | What it colors | Source in this repo | Where it lives |
|---|---|---|---|
| Claude Code custom theme | Claude Code's own UI: side pane background, your message background, inline code, text, success/error | `claude-themes/<look>.json` | `~/.claude/themes/` (whole dir is a symlink here) |
| glowup pack | What the [glowup](https://glowup.khimani.dev/) mod draws: row style (`slab`, `cards`…), accent, borders, spinner, pane contents | `glowup-packs/<look>.json` | `~/.claude/glowup/packs/` (whole dir is a symlink here) |
| kitty theme | The terminal itself: background, foreground, the 16 ANSI colors | `kitty/<Name>.conf` | `~/.config/kitty/` (per-file symlinks) |

The [`mood`](../bin/mood) command switches all three at once.

## Looks today

| Look | Background | Accent | Claude Code theme | glowup pack | kitty theme |
|---|---|---|---|---|---|
| `rose-pine` | `#191724` | `#9983b6` | "Rose Pine" | `rose-pine` (slab) | `Rosé Pine.conf` (upstream Rosé Pine) |
| `sunset` | `#181119` | `#bd674e` | "Sunset" | `sunset` (slab) | `Sunset.conf` |

`glowup-packs/my-cozy.json` is a pack without a matching theme, so `mood` doesn't list it; use it with `/glowup pack my-cozy`.

## Install on a new machine

Prerequisites: Claude Code, the glowup plugin (`/plugin`), kitty, python3, and `~/.local/bin` on `PATH`.

```bash
./looks/install.sh   # links mood, the themes dir, the packs dir and the kitty themes
mood                 # help, with every look and whether it's complete
mood sunset          # apply one
```

The repo's top-level `./install.sh` runs this too, after linking the other configs, so on a new machine that one command is enough. `looks/install.sh` is safe to re-run. Anything already at a target path that isn't the right link is moved to `<name>.pre-looks.<timestamp>`.

kitty must include `current-theme.conf` (this repo's `kitty/kitty.conf` already does, between the `BEGIN_KITTY_THEME` markers). `mood` overwrites `current-theme.conf` with the chosen look.

## How `mood` works

`mood` lists looks from the **Claude Code themes**: every `~/.claude/themes/<slug>.json` is a look named `<slug>`. For each one it pairs:

- the glowup pack `~/.claude/glowup/packs/<slug>.json` (same file name)
- the kitty theme in `~/.config/kitty/*.conf` whose `## name:` line matches the Claude Code theme's `"name"`, ignoring case and accents (`Rose Pine` matches `Rosé Pine`)

`mood <look>` then:

1. copies the kitty theme over `~/.config/kitty/current-theme.conf`, sends `SIGUSR1` to every kitty (kitty re-reads its config on that signal) and resets any live background override in the current window
2. in `~/.claude/settings.json` sets:
   - `"theme": "custom:<look>"`
   - glowup's plugin options (`pluginConfigs."glowup@glowup".options`): `pack` = `<look>`, `theme` = `classic`, `spinner` = `pack`. The last two clear glowup's saved theme and spinner choices so the pack's own palette and spinner show.
3. tells you to restart Claude Code (`/exit`, then `claude --continue`)

Before writing, it copies each file to `<file>.mood.bak` (one rolling backup each).

Other commands: `mood list` (details and what's active), `mood current`, `mood help`. Colors turn off when output isn't a terminal or `NO_COLOR` is set.

## Create a new look

Say the look is `forest`, named "Forest".

1. **Claude Code theme.** In Claude Code run `/theme` → *New custom theme…*, name it `Forest`, pick a base (e.g. *Dark mode*). It's saved as `claude-themes/forest.json` (through the symlinked dir). Then fill `overrides` in that file; see the key list below.
2. **glowup pack.** Write `glowup-packs/forest.json` by hand (reference: glowup's `skills/glowup-pack/reference.md` in the plugin), or set up the look with `/glowup` commands and run `/glowup pack save forest`. Set `"bg"` to the kitty background.
3. **kitty theme.** Copy `kitty/Sunset.conf` to `kitty/Forest.conf`, change `## name: Forest` and the colors, then run `./looks/install.sh` to link it.
4. `mood` should list `forest` as `ready`. Apply it with `mood forest` and restart Claude Code.

Keep the same background in all three: kitty `background`, pack `"bg"`, and the theme's `composerSidebarBackground`.

## Claude Code theme keys worth knowing

Theme files are `{ "name", "base", "overrides" }`. `base` is a built-in (`dark`, `light`, `dark-daltonized`, `light-daltonized`, `dark-ansi`, `light-ansi`); `overrides` maps keys to `rgb(r,g,b)` or `#rrggbb`. Unknown keys are ignored silently.

| Key | Colors |
|---|---|
| `composerSidebarBackground` | background of docked side panes, including glowup's pane (dark default `#262626`) |
| `userMessageBackground`, `userMessageBackgroundHover` | your messages in the transcript |
| `text`, `subtle`, `inactive` | main and secondary text |
| `permission`, `suggestion` | inline code and file paths (blue by default), permission prompts |
| `success`, `error` | the tool-call dot and success/error notices. The `*-daltonized` bases make success blue |
| `promptBorder`, `selectionBg`, `bashMessageBackgroundColor`, `memoryBackgroundColor` | input border, selection, `!` shell and memory blocks |

These names were read from the Claude Code 2.1.314 binary, not from docs; a later release may rename them.

## Gotchas

- **Claude Code reads theme colors only at startup.** Editing a theme file, or re-picking it in `/theme`, does nothing until you `/exit` and start again. Creating a theme in `/theme` writes it with empty `overrides`; fill them, then restart.
- **`/glowup color <role> <hex>` sits on top of every pack** and survives `/glowup pack` and `mood`. Clear it with `/glowup color reset [role]` or the pack's colors won't show. `/glowup pack save` bakes it into the saved file.
- **glowup never paints backgrounds.** The terminal background is kitty's; the side pane background is Claude Code's (`composerSidebarBackground`). The pack's `"bg"` only tells glowup what to blend toward, and it's also the text color of the `slab` prompt bar.
- **Don't edit glowup's code** (in `~/.claude/plugins/cache/glowup/`). Things only code can change: the `PROMPT NN` label and the padding of the `slab` bar, and tool glyphs in `slab`. A plugin update would wipe any edit anyway.
- **Directories, not files, are symlinked** for themes and packs. Claude Code and glowup save by writing a temp file and renaming it, which would turn a per-file symlink back into a plain file and silently stop syncing to this repo.
- **One-off background, no saving:** `printf '\033]11;#181119\033\\'` sets the current kitty window's background; `printf '\033]111\033\\'` resets it.

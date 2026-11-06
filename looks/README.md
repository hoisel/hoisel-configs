# Looks

A **look** is one matching visual style across tools that don't know about each other:

| Piece | What it colors | Source in this repo | Where it lives |
|---|---|---|---|
| Claude Code custom theme | Claude Code's own UI: side pane background, your message background, inline code, text, success/error | `claude-themes/<look>.json` | `~/.claude/themes/` (whole dir is a symlink here) |
| glowup pack | What the [glowup](https://glowup.khimani.dev/) mod draws: row style (`slab`, `cards`…), accent, borders, spinner, pane contents | `glowup-packs/<look>.json` | `~/.claude/glowup/packs/` (whole dir is a symlink here) |
| kitty theme | The terminal itself: background, foreground, the 16 ANSI colors | `kitty/<Name>.conf` | `~/.config/kitty/` (per-file symlinks) |
| VS Code theme (optional) | The VS Code editor and workbench | `vscode/<look>/` (a theme-only extension) | `~/.vscode/extensions/<publisher>.<name>` (folder symlink) |

The [`mood`](../bin/mood) command switches them all at once.

## Looks today

| Look | Background | Accent | Claude Code theme | glowup pack | kitty theme | VS Code theme |
|---|---|---|---|---|---|---|
| `rose-pine` | `#191724` | `#9983b6` | "Rose Pine" | `rose-pine` (slab) | `Rosé Pine.conf` (upstream Rosé Pine) | "Rosé Pine" (marketplace extension `mvllow.rose-pine`, installed by `looks/install.sh`) |
| `sunset` | `#181119` | `#bd674e` | "Sunset" | `sunset` (slab) | `Sunset.conf` | none |
| `cocoa` | `#14110f` | `#f4a6b8` | "Cocoa" | `cocoa` (slab, dithered pane field) | `Cocoa.conf` | none |
| `campfire` | `#23272d` | `#f26b21` | "Campfire" | `campfire` (slab, dithered warp pane field, Portuguese spinner words) | `Campfire.conf` | "Campfire" (`vscode/campfire/`) |

## Install on a new machine

Prerequisites: Claude Code, the glowup plugin (`/plugin`), kitty, python3, and `~/.local/bin` on `PATH`.

```bash
./looks/install.sh   # links mood, the themes dir, the packs dir, the kitty and VS Code themes; installs marketplace VS Code themes; sets the status line
mood                 # help, with every look and whether it's complete
mood sunset          # apply one
```

The repo's top-level `./install.sh` runs this too, after linking the other configs, so on a new machine that one command is enough. `looks/install.sh` is safe to re-run. Anything already at a target path that isn't the right link is moved to `<name>.pre-looks.<timestamp>`.

kitty must include `current-theme.conf` (this repo's `kitty/kitty.conf` already does, between the `BEGIN_KITTY_THEME` markers). `mood` overwrites `current-theme.conf` with the chosen look.

## How `mood` works

`mood` lists looks from the **Claude Code themes**: every `~/.claude/themes/<slug>.json` is a look named `<slug>`. For each one it pairs:

- the glowup pack `~/.claude/glowup/packs/<slug>.json` (same file name)
- the kitty theme in `~/.config/kitty/*.conf` whose `## name:` line matches the Claude Code theme's `"name"`, ignoring case and accents (`Rose Pine` matches `Rosé Pine`)
- optionally, the VS Code color theme whose label matches that same name the same way, from any extension installed in `~/.vscode/extensions` (this repo's or the marketplace's)

`mood <look>` then:

1. copies the kitty theme over `~/.config/kitty/current-theme.conf`, sends `SIGUSR1` to every kitty (kitty re-reads its config on that signal) and resets any live background override (OSC 111) in every kitty window
2. in `~/.claude/settings.json` sets:
   - `"theme": "custom:<look>"`
   - glowup's plugin options (`pluginConfigs."glowup@glowup".options`): `pack` = `<look>`, `theme` = `classic`, `spinner` = `pack`. The last two clear glowup's saved theme and spinner choices so the pack's own palette and spinner show.
3. sets `"workbench.colorTheme"` in VS Code's `~/.config/Code/User/settings.json` to the matching VS Code theme. VS Code picks it up on its own. With `--no-vscode` (`mood campfire --no-vscode`) this step is skipped, and a look with no matching VS Code theme skips it with a note. That file is JSONC with comments, so `mood` rewrites only the value on the `"workbench.colorTheme"` line and never re-serializes the file; if the line is missing it says so and changes nothing.
4. tells you to restart Claude Code (`/exit`, then `claude --continue`)

Before writing, it copies each file to `<file>.mood.bak` (one rolling backup each).

Other commands: `mood list` (details and what's active), `mood current`, `mood help`. Colors turn off when output isn't a terminal or `NO_COLOR` is set.

## Status line

The order of glowup's status line fields is a personal glowup setting, not part of a pack, so every look shares it. The order is: folder, branch, activity, then the rest:

```
cwd,branch,activity,effort,model,plan,agents,changes,week
```

`looks/install.sh` writes this list to `settings.json` as glowup's `/plugin` option `statusline` (`pluginConfigs."glowup@glowup".options.statusline`), backing up the previous file to `settings.json.pre-looks.statusline` when it changes. glowup applies a changed option at the next Claude Code start. To change the order, edit `STATUSLINE` in `looks/install.sh` and re-run it, or run `/glowup statusline fields cwd branch activity …` inside Claude Code and then update `looks/install.sh` to match. Fields with nothing to show are hidden; `branch`, for example, only appears inside a git repo.

## Create a new look

Say the look is `forest`, named "Forest".

1. **Claude Code theme.** In Claude Code run `/theme` → *New custom theme…*, name it `Forest`, pick a base (e.g. *Dark mode*). It's saved as `claude-themes/forest.json` (through the symlinked dir). Then fill `overrides` in that file; see the key list below.
2. **glowup pack.** Write `glowup-packs/forest.json` by hand (reference: glowup's `skills/glowup-pack/reference.md` in the plugin), or set up the look with `/glowup` commands and run `/glowup pack save forest`. Set `"bg"` to the kitty background.
3. **kitty theme.** Copy `kitty/Sunset.conf` to `kitty/Forest.conf`, change `## name: Forest` and the colors, then run `./looks/install.sh` to link it.
4. `mood` should list `forest` as `ready`. Apply it with `mood forest` and restart Claude Code.
5. **VS Code theme (optional).** Copy `vscode/campfire/` to `vscode/forest/`, set `name` (`forest-theme`) and the theme `label` (`Forest`, the Claude Code theme's name) in `package.json`, edit the colors in `themes/`, then run `./looks/install.sh` to link it. See [VS Code theme](#vs-code-theme).

Keep the same background in all three: kitty `background`, pack `"bg"`, and the theme's `composerSidebarBackground`.

## VS Code theme

A look's VS Code theme is a local, theme-only extension (no code, no build step) in `vscode/<look>/`:

| Path | What it is |
|---|---|
| `package.json` | the extension manifest. `publisher` + `name` give the folder name in `~/.vscode/extensions` (`hoisel.campfire-theme`); the theme `label` is what `mood` matches and what `"workbench.colorTheme"` holds |
| `themes/<look>-color-theme.json` | the theme VS Code loads: `colors` (workbench), `tokenColors` (TextMate scopes) and `semanticTokenColors` |
| `versions/<look>-vN.json` | earlier iterations, kept for reference. VS Code never reads them; the one in use is whatever `themes/` holds |
| `preview/` | a sample file and side-by-side screenshots of the versions |

`looks/install.sh` links the whole folder to `~/.vscode/extensions/<publisher>.<name>`. VS Code finds the link at its next start and registers it in `~/.vscode/extensions/extensions.json` on its own; `code --list-extensions` shows it. Because it's a link, editing `themes/*.json` here changes the installed theme: run *Developer: Reload Window* to see it.

A look can also use a theme from the VS Code marketplace instead of one in this repo, as `rose-pine` does with `mvllow.rose-pine`. List the extension id in `VSCODE_MARKETPLACE` in `looks/install.sh`, which installs it with `code --install-extension` when it's missing (the only step of the installer that needs the network). `mood` pairs it by the theme label like any other.

To try a change without touching your real VS Code, open it in a throwaway profile:

```bash
tmp=$(mktemp -d)
mkdir -p "$tmp/User"
echo '{ "security.workspace.trust.enabled": false, "workbench.colorTheme": "Campfire" }' > "$tmp/User/settings.json"
code --user-data-dir "$tmp" --extensionDevelopmentPath="$PWD/looks/vscode/campfire" looks/vscode/campfire/preview
```

Turning workspace trust off matters: in Restricted Mode VS Code turns semantic highlighting off, so `semanticTokenColors` (bold declarations, `readonly` variables) don't show and the theme looks wrong.

## Claude Code theme keys worth knowing

Theme files are `{ "name", "base", "overrides" }`. `base` is a built-in (`dark`, `light`, `dark-daltonized`, `light-daltonized`, `dark-ansi`, `light-ansi`); `overrides` maps keys to `rgb(r,g,b)` or `#rrggbb`. Unknown keys are ignored silently.

| Key | Colors |
|---|---|
| `composerSidebarBackground` | background of docked side panes, including glowup's pane (dark default `#262626`) |
| `userMessageBackground`, `userMessageBackgroundHover` | your messages in the transcript |
| `text`, `subtle`, `inactive` | main and secondary text |
| `permission`, `suggestion` | permission prompts and other accents. **Not** inline code: see Gotchas |
| `diffAdded`, `diffRemoved`, `diffAddedDimmed`, `diffRemovedDimmed`, `diffAddedWord`, `diffRemovedWord` | diff line and changed-word backgrounds. Without them, diffs use colors hardcoded per base, not the base's own `diff*` values. On an `*-ansi` base the diff renders in 16-color mode with no line backgrounds by default, and RGB `diff*` overrides get reduced to the nearest ANSI color (both lines end up the same gray), so `cocoa` leaves them out |
| `success`, `error` | the tool-call dot and success/error notices. The `*-daltonized` bases make success blue |
| `promptBorder`, `selectionBg`, `bashMessageBackgroundColor`, `memoryBackgroundColor` | input border, selection, `!` shell and memory blocks |

These names were read from the Claude Code 2.1.314 binary, not from docs; a later release may rename them.

## Gotchas

- **Claude Code reads theme colors only at startup.** Editing a theme file, or re-picking it in `/theme`, does nothing until you `/exit` and start again. Creating a theme in `/theme` writes it with empty `overrides`; fill them, then restart.
- **`/glowup color <role> <hex>` sits on top of every pack** and survives `/glowup pack` and `mood`. Clear it with `/glowup color reset [role]` or the pack's colors won't show. `/glowup pack save` bakes it into the saved file.
- **glowup never paints backgrounds.** The terminal background is kitty's; the side pane background is Claude Code's (`composerSidebarBackground`). The pack's `"bg"` only tells glowup what to blend toward, and it's also the text color of the `slab` prompt bar.
- **Pack spinner words need a glowup theme other than `classic`.** glowup ignores `colors.words` and shows Claude Code's own rotating words whenever the pack's `colors.theme` is `classic` (also the default when it's left out). `campfire` sets `"theme": "glowup"` for this. Every built-in glowup theme other than `classic` changes only colors and words, and the pack sets all 14 palette colors, so only the words differ from a `classic` start. This is the pack's `colors.theme`, not the glowup `/plugin` option `theme` that `mood` sets to `classic`; that value only clears a saved `/glowup theme` override. Reduced motion also keeps Claude Code's words.
- **Don't edit glowup's code** (in `~/.claude/plugins/cache/glowup/`). Things only code can change: the `PROMPT NN` label and the padding of the `slab` bar, and tool glyphs in `slab`. A plugin update would wipe any edit anyway.
- **Directories, not files, are symlinked** for themes and packs. Claude Code and glowup save by writing a temp file and renaming it, which would turn a per-file symlink back into a plain file and silently stop syncing to this repo.
- **Inline code and file paths ignore overrides.** In 2.1.314 the markdown renderer colors code spans with the *base* theme's `permission`, never the override (it resolves colors from the base name, not the resolved theme). The only lever is `base`: `dark` gives lavender `#b1b9f9`, `dark-daltonized` gives light blue `#99ccff`, and `dark-ansi` uses the terminal's `ansi:blueBright` (kitty `color12`). `rose-pine` uses `dark` for this reason; `cocoa` uses `dark-ansi` so inline code matches the blue of directories in `ls` under the Cocoa kitty theme. With an `*-ansi` base, every token the theme doesn't override also comes from the kitty palette.
- **A global `workbench.colorCustomizations` beats every VS Code theme.** Keys set there apply on top of whichever theme is active. Scope theme-specific tweaks to that theme: `"workbench.colorCustomizations": { "[Rosé Pine]": { … } }`. The real settings keep the Rosé Pine pinks scoped this way, so they don't show up under Campfire.
- **One-off background, no saving:** `printf '\033]11;#181119\033\\'` sets the current kitty window's background; `printf '\033]111\033\\'` resets it. A background set this way survives kitty config reloads, so it would hide the look's background; `mood` sends the reset to every kitty window for that reason.

# nvim-config

A Neovim setup that feels like **Visual Studio**: F5 to debug, F12 to go to definition, F2 to rename,
Ctrl+. for quick fixes. Built on [LazyVim](https://lazyvim.github.io) for C#/.NET and
TypeScript/React. Installs with **one command** on macOS, Linux and Windows.

Never used Vim before? Start with [Your first 10 minutes](#your-first-10-minutes). It assumes nothing.

---

## Contents

- [Install](#install)
- [Your first 10 minutes](#your-first-10-minutes)
- [Visual Studio → here](#visual-studio--here)
- [Vim basics: moving and editing](#vim-basics-moving-and-editing)
- [Every Space command](#every-space-command)
- [How to find any command](#how-to-find-any-command)
- [Per-project settings](#per-project-settings-lazylua)
- [Troubleshooting](#troubleshooting)

---

## Install

One command, pick your OS. The script installs everything: Neovim, git, search tools, Node,
the .NET 10 SDK, an icon font, and all plugins.

### macOS

Open **Terminal** (or Warp) and paste:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mrviduus/nvim-config/main/install.sh)
```

It may ask for your Mac password. That's Homebrew installing software, it's expected.

### Linux (Ubuntu / Debian)

```bash
sudo apt update && sudo apt install -y build-essential curl git file procps libicu-dev
bash <(curl -fsSL https://raw.githubusercontent.com/mrviduus/nvim-config/main/install.sh)
```

The first line installs what Homebrew and .NET need to run.

### Windows 10 / 11

Open **PowerShell** (a normal one, not as Administrator) and paste:

```powershell
irm https://raw.githubusercontent.com/mrviduus/nvim-config/main/install.ps1 | iex
```

### After installing (all systems)

1. **Close the terminal and open a new one** so it picks up the new programs.
2. **Set the font** to `JetBrainsMono Nerd Font` in your terminal settings, otherwise icons show up as boxes:
   - Warp: Settings → Appearance → Font
   - Terminal (Mac): Settings → Profiles → Text → Font
   - Windows Terminal: Settings → Profiles → Defaults → Appearance → Font face
3. Go to your project folder and start the editor:
   ```bash
   cd ~/projects/my-app
   nvim .
   ```
4. **Wait 1–2 minutes on the first launch** while language servers (IntelliSense) download at the bottom.
   To check: type `:Mason` and press Enter. `omnisharp` (C#) and `vtsls` (TypeScript) should have a ✓.
   Close that window with `q`.

### F1–F12 keys on a Mac

By default, Mac F-keys control brightness and volume. Either press **Fn+F5**, **Fn+F12**, and so on,
or change it once:
System Settings → Keyboard → Keyboard Shortcuts → Function Keys →
**Use F1, F2, etc. keys as standard function keys**.

### What the scripts do

<details>
<summary>install.sh (macOS / Linux)</summary>

1. Installs [Homebrew](https://brew.sh) if it's missing.
2. Installs `neovim git ripgrep fd lazygit fzf node tree-sitter-cli`, plus the font on a Mac.
3. Installs the .NET 10 SDK into `~/.dotnet` (no sudo) if `dotnet` isn't already there, and adds it to PATH.
4. If `~/.config/nvim` already holds a different config, renames it to `*.bak.<date>`
   (**nothing is deleted**) and clones this repo.
5. Downloads plugins at exactly the versions pinned in `lazy-lock.json`.

</details>

<details>
<summary>install.ps1 (Windows)</summary>

Installs via `winget`: Neovim, Git, ripgrep, fd, lazygit, fzf, Node, zig (a compiler for syntax
highlighting parsers), the font, the .NET 10 SDK. Puts the config in `%LOCALAPPDATA%\nvim` and renames any
existing one to `*.bak.<date>`.

</details>

Both scripts are safe to re-run: installed tools are skipped and the config is updated.

### Updating

```bash
git -C ~/.config/nvim pull                 # macOS / Linux
git -C $env:LOCALAPPDATA\nvim pull         # Windows
```

Then inside nvim: `:Lazy restore`.

---

## Your first 10 minutes

### The big difference from Visual Studio: modes

In VS your keyboard always types text. In Vim the keyboard has **modes**, and that's the point:

| Mode | What it's for | How to get there | Bottom-left shows |
|---|---|---|---|
| **Normal** | moving around, commands, delete, copy | `Esc` (from anywhere) | `NORMAL` |
| **Insert** | typing text, like in VS | `i` | `INSERT` |
| **Visual** | selecting text | `v` (characters), `V` (lines) | `VISUAL` |
| **Command** | commands like `:w`, `:q` | `:` | `:` at the bottom |

> **Lost? Press `Esc`.** It always takes you back to Normal mode, and everything works from there.

### Survival kit: 8 things

| I want to | Press |
|---|---|
| start typing | `i` |
| stop typing | `Esc` |
| save | `Ctrl+S` (or `:w` Enter) |
| undo | `u` (in Normal mode) |
| redo | `Ctrl+R` |
| quit | `Space q q` (or `:q` Enter) |
| quit without saving | `:q!` Enter |
| see every command | press `Space` and **wait a second** |

### The Space menu

`Space` is the main key here (docs call it `<leader>`). Press it and wait: a menu with labels pops up
at the bottom. Keep pressing letters and the menu shows the next step. For example:
`Space` → `f` (files) → `f` (find) = find a file.

You don't have to memorize anything up front. It's all in the menu.

### Autocomplete (IntelliSense)

Shows up on its own while you type.

| Action | Key |
|---|---|
| accept suggestion | `Enter` |
| next / previous | `Ctrl+N` / `Ctrl+P` or arrow keys |
| open the list manually | `Ctrl+Space` |
| close the list | `Esc` |
| docs for the symbol under the cursor | `K` (in Normal mode) |

### The file tree

`Space e` opens it on the left. Inside it:

| Key | Action |
|---|---|
| `Enter` | open file / expand folder |
| `a` | new file (end the name with `/` for a folder) |
| `r` | rename |
| `d` | delete |
| `c` / `m` | copy / move |
| `H` | show hidden files |
| `?` | all tree keys |
| `q` | close the tree |

---

## Visual Studio → here

Keys marked ★ were added by this config specifically to match VS.
All keys are pressed in **Normal** mode (press `Esc` first) unless stated otherwise.

### Files and navigation

| Action | Visual Studio | Here |
|---|---|---|
| Solution Explorer (file tree) | Ctrl+Alt+L | `Space e` |
| Open file by name | Ctrl+, / Ctrl+T | `Ctrl+P` ★ or `Space Space` |
| Recent files | File → Recent | `Space f r` |
| New file | Ctrl+N | `Space f n` |
| Save | Ctrl+S | `Ctrl+S` |
| Save all | Ctrl+Shift+S | `:wa` Enter |
| Next / previous tab | Ctrl+Tab | `Shift+L` / `Shift+H` |
| List open tabs | Ctrl+Alt+↓ | `Space ,` |
| Close tab | Ctrl+F4 | `Space b d` |
| Close all but this | Close All But This | `Space b o` |
| Pin tab | Pin Tab | `Space b p` |
| Navigate back / forward | Ctrl+- / Ctrl+Shift+- | `Ctrl+O` / `Ctrl+I` |
| Go to line | Ctrl+G | `:42` Enter (line 42) |
| Top / bottom of file | Ctrl+Home / Ctrl+End | `gg` / `G` |

### Code (IntelliSense, refactoring)

| Action | Visual Studio | Here |
|---|---|---|
| Go to definition | F12 | `F12` ★ or `gd` |
| Find all references | Shift+F12 | `Shift+F12` ★ or `gr` |
| Go to implementation | Ctrl+F12 | `gI` |
| Go to type definition | — | `gy` |
| Quick Info | mouse hover | `K` |
| Parameter info | Ctrl+Shift+Space | `gK` (or `Ctrl+K` in Insert mode) |
| Quick actions / fixes | Ctrl+. | `Ctrl+.` ★ or `Space c a` |
| Rename | Ctrl+R, R / F2 | `F2` ★ or `Space c r` |
| Rename file | in Solution Explorer | `Space c R` |
| Format document | Ctrl+K, D | `Space c f` |
| Comment line | Ctrl+K, C / Ctrl+/ | `gcc` |
| Comment selection | Ctrl+K, C | select (`V`) → `gc` |
| Symbols in file (Go to Member) | Alt+\ | `Space s s` |
| Symbols in solution (Go to Symbol) | Ctrl+T | `Space s S` |
| Collapse / expand block | Ctrl+M, M | `za` |
| Collapse all / expand all | Ctrl+M, O / Ctrl+M, L | `zM` / `zR` |

### Errors (Error List)

| Action | Visual Studio | Here |
|---|---|---|
| Project-wide error list | Ctrl+\, E | `Space x x` |
| Errors in current file | — | `Space x X` |
| Next / previous problem | F8 / Shift+F8 | `]d` / `[d` |
| Errors only (skip warnings) | filter | `]e` / `[e` |
| Show error under cursor | hover | `Space c d` |
| TODO comments | Task List | `Space s t` |

### Search and replace

| Action | Visual Studio | Here |
|---|---|---|
| Find in file | Ctrl+F | `/text` Enter, then `n` / `N` |
| Find in files | Ctrl+Shift+F | `Ctrl+Shift+F` ★ or `Space /` |
| Find word under cursor in project | — | `Space s w` |
| Replace in file | Ctrl+H | `:%s/old/new/g` Enter |
| Replace in files | Ctrl+Shift+H | `Space s r` |
| Clear search highlight | — | `Esc` |
| Command palette | Ctrl+Q | `Space s C` |

### Debugging

| Action | Visual Studio | Here |
|---|---|---|
| Start / continue | F5 | `F5` ★ or `Space d c` |
| Stop | Shift+F5 | `Shift+F5` ★ or `Space d t` |
| Toggle breakpoint | F9 | `F9` ★ or `Space d b` |
| Conditional breakpoint | Alt+F9, C | `Space d B` |
| Step over | F10 | `F10` ★ or `Space d O` |
| Step into | F11 | `F11` ★ or `Space d i` |
| Step out | Shift+F11 | `Shift+F11` ★ or `Space d o` |
| Run to cursor | Ctrl+F10 | `Space d C` |
| Debug windows (Locals, Watch, Stack) | Debug → Windows | `Space d u` |
| Evaluate expression (QuickWatch) | Shift+F9 | `Space d e` |

### Build, run, terminal

| Action | Visual Studio | Here |
|---|---|---|
| Terminal | Ctrl+` | `Ctrl+/` (press again to hide) |
| Build | Ctrl+Shift+B | in the terminal: `dotnet build` |
| Run without debugging | Ctrl+F5 | in the terminal: `dotnet run --project <path>` |
| Tests | Test Explorer | in the terminal: `dotnet test` |

### Git

| Action | Visual Studio | Here |
|---|---|---|
| Git Changes (commit, push, pull) | Ctrl+0, Ctrl+G | `Space g g` (lazygit) |
| Who wrote this line (Blame) | Annotate | `Space g b` |
| File history | View History | `Space g f` |
| Changed files | Git Changes | `Space g s` |
| Open file on GitHub | — | `Space g B` |

Inside lazygit: `Space` stage a file, `c` commit, `P` push, `p` pull, `?` help, `q` quit.

### Windows (splits)

| Action | Visual Studio | Here |
|---|---|---|
| Split vertically | Window → New Vertical Tab Group | `Space \|` |
| Split horizontally | Window → New Horizontal Tab Group | `Space -` |
| Move to the next split | Ctrl+Tab | `Ctrl+H` / `J` / `K` / `L` (left/down/up/right) |
| Close split | — | `Space w d` |
| Maximize split | Shift+Alt+Enter | `Space w m` |
| Resize | mouse | `Ctrl+arrow keys` |

The mouse works too: click, scroll, drag split borders.

---

## Vim basics: moving and editing

This is what VS doesn't have, and why people love Vim: editing without the mouse. Don't learn it all
at once. The first two tables are enough to start.

### Moving (Normal mode)

| Key | Goes to |
|---|---|
| `h` `j` `k` `l` | ← ↓ ↑ → (arrow keys work too) |
| `w` / `b` | next / previous word |
| `e` | end of word |
| `0` / `$` | start / end of line |
| `^` | first non-blank character of the line |
| `gg` / `G` | top / bottom of file |
| `Ctrl+D` / `Ctrl+U` | half a page down / up |
| `%` | matching bracket |
| `s` + 2 letters | jump anywhere on screen (it labels the targets) |
| `f` + letter | that letter on the current line (`;` for the next one) |

### Start typing (enter Insert mode)

| Key | Where you start typing |
|---|---|
| `i` | before the cursor |
| `a` | after the cursor |
| `I` / `A` | start / end of the line |
| `o` / `O` | on a new line below / above |

### Editing (Normal mode)

| Key | What it does | VS equivalent |
|---|---|---|
| `x` | delete character | Delete |
| `dd` | delete (cut) line | Ctrl+X on a line |
| `yy` | copy line | Ctrl+C on a line |
| `p` / `P` | paste after / before | Ctrl+V |
| `yyp` | duplicate line | Ctrl+D |
| `u` / `Ctrl+R` | undo / redo | Ctrl+Z / Ctrl+Y |
| `.` | repeat last change | — |
| `>>` / `<<` | indent / unindent | Tab / Shift+Tab |
| `Alt+J` / `Alt+K` | move line down / up | Alt+↓ / Alt+↑ |
| `J` | join with the next line | — |
| `~` | toggle case of a letter | — |
| `ggVG` | select all | Ctrl+A |

> On a Mac, **Alt** is the **Option** key. In Warp turn on Settings → Keyboard →
> "Left Option key is Meta", otherwise `Alt+J`/`Alt+K` won't work.

### Vim grammar: verb + object

Commands combine like words: a **verb** plus **what/where**.

| Verb | | Object | |
|---|---|---|---|
| `d` | delete | `w` | word |
| `c` | change (delete and start typing) | `iw` | whole word (inside word) |
| `y` | yank (copy) | `i"` / `i(` / `i{` | inside quotes / brackets |
| `v` | select | `a"` / `a(` | including the quotes / brackets |
| | | `$` | to end of line |
| | | `if` / `af` | function body / whole function |

Examples:

| Press | Result |
|---|---|
| `ciw` | replace the word under the cursor |
| `ci"` | replace the text inside quotes |
| `di(` | delete everything inside the parentheses |
| `yif` | copy the function body |
| `d$` | delete to end of line |
| `vaf` | select the whole function |
| `3dd` | delete 3 lines (a number repeats the command) |

### Selecting (Visual mode)

| Key | What it does |
|---|---|
| `v` | select by character |
| `V` | select by line |
| `Ctrl+V` | block (column) selection |
| `Ctrl+Space` | smart select: word → expression → block (press again to grow) |
| then `d` / `y` / `c` / `>` / `gc` | delete / copy / change / indent / comment |

---

## Every Space command

The full list of what opens under `Space`. A capital letter means `Shift` + letter.

### Top level (Space + one key)

| Key | Action |
|---|---|
| `Space Space` | find file |
| `Space /` | search text in project |
| `Space ,` | switch between open files |
| `Space e` / `Space E` | file tree (project root / current folder) |
| `Space :` | command history |
| `Space -` / `Space \|` | split window below / right |
| `` Space ` `` | previous file |
| `Space .` | scratch buffer |
| `Space ?` | keys for the current file |
| `Space l` | plugin manager (Lazy) |
| `Space n` | notification history |

### `Space b`: tabs (buffers)

| Key | Action |
|---|---|
| `Space b d` | close current |
| `Space b D` | close it and its window |
| `Space b o` | close all others |
| `Space b l` / `Space b r` | close all to the left / right |
| `Space b p` | pin |
| `Space b P` | close all unpinned |
| `Space b b` | previous tab |
| `Space b j` | pick a tab by letter |
| `Space b e` | tab list in the tree |

### `Space c`: code

| Key | Action |
|---|---|
| `Space c a` | quick actions (code action) |
| `Space c r` | rename symbol |
| `Space c R` | rename file |
| `Space c f` | format |
| `Space c d` | error under cursor |
| `Space c s` | file outline (symbols) |
| `Space c S` | references / definitions in a panel |
| `Space c m` | Mason (language servers) |

### `Space d`: debug

| Key | Action |
|---|---|
| `Space d c` | start / continue |
| `Space d a` | run with arguments |
| `Space d l` | re-run last |
| `Space d b` | toggle breakpoint |
| `Space d B` | conditional breakpoint |
| `Space d C` | run to cursor |
| `Space d O` / `Space d i` / `Space d o` | step over / into / out |
| `Space d P` | pause |
| `Space d t` | stop |
| `Space d u` | debug windows |
| `Space d e` | evaluate expression |
| `Space d r` | console (REPL) |
| `Space d w` | widgets |
| `Space d j` / `Space d k` | down / up the call stack |

### `Space f`: files

| Key | Action |
|---|---|
| `Space f f` | find file |
| `Space f r` | recent files |
| `Space f g` | git files |
| `Space f b` | open tabs |
| `Space f n` | new file |
| `Space f c` | nvim config files |
| `Space f t` | terminal |
| `Space f e` | file tree |

### `Space g`: git

| Key | Action |
|---|---|
| `Space g g` | lazygit (everything git) |
| `Space g s` | status |
| `Space g d` | diff |
| `Space g b` | who wrote this line (blame) |
| `Space g f` | file history |
| `Space g l` / `Space g c` | commits |
| `Space g S` | stash |
| `Space g B` / `Space g Y` | open on GitHub / copy link |

### `Space s`: search

| Key | Action |
|---|---|
| `Space s g` | text in project |
| `Space s w` | word under cursor in project |
| `Space s r` | search and replace in project |
| `Space s b` | lines in current file |
| `Space s s` / `Space s S` | symbol in file / in project |
| `Space s d` / `Space s D` | errors in project / in file |
| `Space s t` / `Space s T` | TODO / TODO+FIX+FIXME |
| `Space s k` | **all keybindings** |
| `Space s C` | all commands |
| `Space s h` | help |
| `Space s R` | resume last search |
| `Space s j` | jump history |
| `Space s m` | marks |
| `Space s "` | clipboard (registers) |
| `Space s q` | quickfix list |

### `Space u`: toggles (UI)

| Key | Action |
|---|---|
| `Space u f` / `Space u F` | format on save (everywhere / this file) |
| `Space u w` | line wrap |
| `Space u l` / `Space u L` | line numbers / relative numbers |
| `Space u d` | show errors |
| `Space u h` | inlay hints (inline type hints) |
| `Space u s` | spell check |
| `Space u C` | change color theme |
| `Space u b` | light / dark background |
| `Space u z` / `Space u Z` | zen mode / zoom split |
| `Space u g` | indent guides |
| `Space u n` | dismiss notifications |

### `Space w`: windows

| Key | Action |
|---|---|
| `Space w d` | close split |
| `Space w m` | maximize / restore split |
| `Ctrl+W` then `Space` | window control mode |

### `Space x`: errors and lists (Trouble)

| Key | Action |
|---|---|
| `Space x x` | errors in project |
| `Space x X` | errors in file |
| `Space x t` / `Space x T` | TODO |
| `Space x q` / `Space x Q` | quickfix list |
| `Space x l` / `Space x L` | location list |

### `Space Tab`: workspace tabs

(A separate window layout, like multiple desktops. Beginners rarely need it.)

| Key | Action |
|---|---|
| `Space Tab Tab` | new |
| `Space Tab ]` / `Space Tab [` | next / previous |
| `Space Tab d` | close |
| `Space Tab o` | close others |

### `Space q`: quit and sessions

| Key | Action |
|---|---|
| `Space q q` | quit |
| `Space q s` | restore this folder's session (open files) |
| `Space q l` | restore last session |
| `Space q S` | pick a session |

### Jumping with `[` and `]`

`]` = next, `[` = previous.

| Key | Jumps to |
|---|---|
| `]d` / `[d` | problem (error or warning) |
| `]e` / `[e` | error |
| `]w` / `[w` | warning |
| `]t` / `[t` | TODO comment |
| `]b` / `[b` | tab |
| `]q` / `[q` | list item (quickfix / Trouble) |
| `]f` / `[f` | function |
| `]c` / `[c` | class |

---

## How to find any command

The tables cover nearly everything, but forgetting is normal:

| I want | Press |
|---|---|
| a hint for what I can press next | `Space` and wait (works for any prefix: `g`, `]`, `Space c`) |
| to find a key by what it does | `Space s k`, then type, e.g. `rename` |
| to find a command by name | `Space s C` |
| help on anything | `Space s h` |
| LazyVim docs | https://lazyvim.github.io/keymaps |
| an interactive Vim lesson (30 min) | run `vimtutor` in a terminal |

---

## Per-project settings (`.lazy.lua`)

Put a `.lazy.lua` file in a project's root and LazyVim loads it for that project only.
The first time, nvim asks whether to trust it: press `a` (allow).

The [`projects/`](projects/) folder holds these files for my projects. For example, textstack:

```bash
cp ~/.config/nvim/projects/textstack.lazy.lua ~/projects/textstack/textstack/.lazy.lua
echo ".lazy.lua" >> ~/projects/textstack/textstack/.git/info/exclude   # keep it out of the project's git
```

What it does:
- C# is formatted by OmniSharp, matching `dotnet format` in CI, instead of csharpier;
- format-on-save is off for frontend files: that code isn't prettier-formatted, so saving would
  rewrite whole files.

## What's included

Languages and tools (`lazyvim.json`, change with `:LazyExtras`):
C#/.NET, TypeScript/React, JSON, YAML, Docker, ESLint, Prettier, debugger.

VS-style keys: [`lua/config/keymaps.lua`](lua/config/keymaps.lua).

C# debugging on Apple Silicon uses a native arm64 `netcoredbg` from
[Cliffback/netcoredbg-macOS-arm64.nvim](https://github.com/Cliffback/netcoredbg-macOS-arm64.nvim)
([`lua/plugins/netcoredbg.lua`](lua/plugins/netcoredbg.lua)): the one Mason installs is x86_64 and hangs.
Other systems use Mason's.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Icons show up as boxes | set the font to `JetBrainsMono Nerd Font` in your terminal |
| F5 / F12 change brightness (Mac) | hold `Fn`, or switch F-keys on (see [install](#f1f12-keys-on-a-mac)) |
| F12 does nothing in C# | OmniSharp takes 30–60 s to load the solution after you open a file; check `:LspInfo` |
| No autocomplete | `:Mason`: the language needs a ✓; if not, select it and press `i` |
| `Ctrl+.` or `Ctrl+Shift+F` don't work | your terminal grabs them: use `Space c a` and `Space /` |
| `Alt+J` / `Alt+K` don't work (Mac) | set Option as Meta in your terminal settings |
| F5 asks for `ASPNETCORE_ENVIRONMENT` / `URL` | put them in a `.env` file in the folder you opened nvim in, or just press Enter to accept the defaults |
| Something broke after an update | `:Lazy restore` rolls plugins back to `lazy-lock.json` |
| General health check | `:checkhealth` |
| Stuck and confused | `Esc`, then `:q!` Enter (quit without saving) |

#!/usr/bin/env bash
# Bootstrap this Neovim config on a clean macOS or Linux machine:
#   bash <(curl -fsSL https://raw.githubusercontent.com/mrviduus/nvim-config/main/install.sh)
# Safe to re-run: installed tools are skipped, an existing clone is pulled.
set -euo pipefail

REPO="https://github.com/mrviduus/nvim-config.git"
DEST="$HOME/.config/nvim"
case "${SHELL:-}" in *zsh) RC="$HOME/.zshrc" ;; *) RC="$HOME/.bashrc" ;; esac

say() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
add_to_rc() { grep -qxF "$1" "$RC" 2>/dev/null || echo "$1" >>"$RC"; }

say "Homebrew"
if ! command -v brew >/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$b" ]; then
    eval "$("$b" shellenv)"
    add_to_rc "eval \"\$($b shellenv)\""
    break
  fi
done

say "Tools"
brew install neovim git ripgrep fd lazygit fzf node tree-sitter-cli
if [ "$(uname)" = Darwin ]; then
  brew install --cask font-jetbrains-mono-nerd-font
fi

say ".NET SDK"
if command -v dotnet >/dev/null; then
  echo "already installed: $(dotnet --version)"
else
  curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0
  export DOTNET_ROOT="$HOME/.dotnet" PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"
  add_to_rc 'export DOTNET_ROOT="$HOME/.dotnet"'
  add_to_rc 'export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"'
fi

say "Config"
if git -C "$DEST" remote get-url origin 2>/dev/null | grep -q "nvim-config"; then
  git -C "$DEST" pull --ff-only
else
  # Someone else's config (or plugin state from it) would clash: move it aside, never delete.
  stamp=$(date +%Y%m%d-%H%M%S)
  for d in "$DEST" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
    if [ -e "$d" ]; then
      mv "$d" "$d.bak.$stamp"
      echo "moved $d -> $d.bak.$stamp"
    fi
  done
  git clone "$REPO" "$DEST"
fi

say "Plugins (first run takes a minute)"
# On a fresh clone lazy.nvim installs missing plugins at startup at their latest commit and rewrites
# lazy-lock.json before `restore` runs, so restore has nothing to do. Put the lockfile back and restore again.
nvim --headless "+Lazy! restore" +qa || true
git -C "$DEST" checkout -- lazy-lock.json
nvim --headless "+Lazy! restore" +qa || true
echo "(Messages about mason/treesitter installs being aborted are fine: they finish on first launch.)"

say "Done"
echo "Open a new terminal (or: source $RC), then run: nvim"
echo "Language servers finish installing on the first launch; check with :Mason"

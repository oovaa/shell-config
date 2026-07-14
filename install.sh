#!/usr/bin/env bash
set -euo pipefail

# Install and set up this zsh configuration (zsh4humans + powerlevel10k)
# on a fresh system. Safe to re-run.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES=(.zshrc .zshenv .p10k.zsh)

SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

log()  { printf '\033[0;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

install_zsh() {
  if command -v zsh >/dev/null 2>&1; then
    log "zsh already installed: $(command -v zsh)"
    return
  fi
  log "Installing zsh..."
  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y zsh git curl ca-certificates
  elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y zsh git curl
  elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -S --noconfirm zsh git curl
  elif command -v brew >/dev/null 2>&1; then
    brew install zsh
  else
    warn "No supported package manager. Install zsh, git and curl, then re-run."
    exit 1
  fi
}

link_dotfiles() {
  for f in "${DOTFILES[@]}"; do
    src="$REPO_DIR/$f"
    [ -f "$src" ] || { warn "Missing $src, skipping"; continue; }
    dest="$HOME/$f"
    if [ -L "$dest" ]; then
      rm -f "$dest"
    elif [ -e "$dest" ]; then
      bak="$dest.bak.$(date +%s)"
      mv -f "$dest" "$bak"
      log "Backed up $dest -> $bak"
    fi
    ln -s "$src" "$dest"
    log "Linked $dest -> $src"
  done
}

install_fonts() {
  if command -v fc-list >/dev/null 2>&1 && fc-list 2>/dev/null | grep -qi "Meslo"; then
    log "Meslo Nerd Font already present"
    return
  fi
  log "Installing Meslo Nerd Font (for Powerlevel10k glyphs)..."
  font_dir="$HOME/.local/share/fonts"
  mkdir -p "$font_dir"
  ok=1
  for style in Regular Bold Italic "Bold Italic"; do
    name="MesloLGS NF ${style}"
    url="https://github.com/romkatv/powerlevel10k-media/raw/master/${name// /%20}.ttf"
    if ! curl -fsSL -o "$font_dir/${name}.ttf" -- "$url"; then ok=0; fi
  done
  if [ "$ok" -eq 1 ]; then
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$font_dir" >/dev/null 2>&1 || true
    log "Meslo Nerd Font installed"
  else
    warn "Font download failed (offline?). Powerlevel10k may show missing glyphs."
  fi
}

set_default_shell() {
  zsh_path="$(command -v zsh)"
  [ "$SHELL" = "$zsh_path" ] && { log "zsh already the default shell"; return; }
  grep -qx "$zsh_path" /etc/shells 2>/dev/null || \
    $SUDO sh -c "echo '$zsh_path' >> /etc/shells" 2>/dev/null || \
    warn "Could not add $zsh_path to /etc/shells"
  if command -v chsh >/dev/null 2>&1; then
    $SUDO chsh -s "$zsh_path" "${USER:-$(id -un)}" 2>/dev/null && \
      log "Default shell set to $zsh_path" || \
      warn "chsh failed; run 'chsh -s $zsh_path' yourself."
  fi
}

install_zsh
link_dotfiles
install_fonts
set_default_shell

log "Done. Start a new shell: zsh"
log "First launch finishes zsh4humans + powerlevel10k setup."

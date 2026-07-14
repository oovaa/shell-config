# Shell Configuration

My Zsh configuration using [zsh4humans](https://github.com/romkatv/zsh4humans) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k).

## Files

| File | Description |
|------|-------------|
| `.zshrc` | Main shell config (aliases, functions, key bindings) |
| `.zshenv` | Environment variables (loaded first) |
| `.p10k.zsh` | Powerlevel10k prompt theme config |

## Install

Run the install script from a clone of this repo. It installs `zsh` (via
`apt`, `dnf`, `pacman` or `brew`), symlinks the dotfiles (backing up any
existing ones), installs the Meslo Nerd Font for Powerlevel10k glyphs, and
sets `zsh` as your default shell.

```bash
git clone https://github.com/oovaa/shell-config.git ~/shell-config
cd ~/shell-config
./install.sh
```

Then start a new shell (`zsh`). On first launch zsh4humans + Powerlevel10k
finish their own setup.

### Manual install

```bash
# Backup your existing config
mv ~/.zshrc ~/.zshrc.bak
mv ~/.zshenv ~/.zshenv.bak
mv ~/.p10k.zsh ~/.p10k.zsh.bak

# Create symlinks
ln -s ~/shell-config/.zshrc ~/.zshrc
ln -s ~/shell-config/.zshenv ~/.zshenv
ln -s ~/shell-config/.p10k.zsh ~/.p10k.zsh
```

## Features

- **zsh4humans** — turnkey Zsh configuration
- **Powerlevel10k** — fast, customizable prompt
- **Lazy-loaded NVM** — faster shell startup
- **Docker completions** — tab completion for docker commands
- **fzf-complete** — recursive directory completion
- Custom aliases for git, system, and SSH

## Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+Backspace` | Delete word backward |
| `Ctrl+Alt+Backspace` | Delete word forward |
| `Alt+Left/Right` | Navigate directories |
| `Alt+Up/Down` | Navigate parent/child dirs |
| `Ctrl+/` | Undo |
| `Alt+/` | Redo |

## Customization

Edit the files directly or run:

```bash
p10k configure  # reconfigure prompt
```

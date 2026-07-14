# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
zstyle ':z4h:' auto-update      'no'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Right-arrow key accepts autosuggestion.
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Disable features we don't use.
zstyle ':z4h:direnv'         enable 'no'
zstyle ':z4h:ssh:*'          enable 'no'

# Clone additional Git repositories from GitHub.
z4h install ohmyzsh/ohmyzsh || return

# Add custom completions
fpath=($HOME/.zsh-completions $fpath)

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# eza - modern ls replacement
alias ls='eza -a --group-directories-first'

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Homebrew (cache check)
if [[ -z "${HOMEBREW_PREFIX}" ]]; then
  for brew_prefix in /home/linuxbrew/.linuxbrew /opt/homebrew /usr/local; do
    if [ -x "$brew_prefix/bin/brew" ]; then
      eval "$("$brew_prefix/bin/brew" shellenv zsh)"
      break
    fi
  done
fi

# bun completions (lazy-load)
_bun_completion() {
  unset -f _bun_completion
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
}
compinit -C  # skip security check for speed

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.opencode/bin:$HOME/.omar-bin:$BUN_INSTALL/bin:$HOME/.local/bin:$HOME/bin:$PATH"




#ma aliases
alias ud='sudo apt update && apt list --upgradable'
alias ug='sudo apt upgrade'
alias list='apt list --upgradable'
alias fuck='thefuck'
alias lsd='eza -d */'
alias v='vim'
alias stz='exec zsh'
alias bcat='bat'
alias pcs='find . -type f -name "*.py" -exec pycodestyle {} +'
alias shc='shellcheck'

# Aliases for commonly used commands (eza-based)
alias ll='eza -la --group-directories-first --git'
alias la='eza -a'
alias l='eza -CF'
alias lt='eza --tree --level=2'
alias lmt='eza -la --sort=modified'
alias lsize='eza -la --sort=size --reverse'
alias ..='cd ..'
alias grep='grep --color=auto'
alias rsaloc='~/.ssh/id_rsa'
alias web1='ssh -i ~/.ssh/id_rsa  ubuntu@54.165.78.43'
alias web2='ssh -i ~/.ssh/id_rsa  ubuntu@54.84.65.46'
alias lb='ssh -i ~/.ssh/id_rsa  ubuntu@54.160.99.228'
alias penv="source venv/bin/activate"
alias wifi="wifi toggle"
alias install="sudo apt install"

# git status - Show the current status of the repository
alias gitstat='git status'
# git add - Add changes to the staging area
alias ga='git add'
# git commit - Commit changes to the repository
alias gc='git commit'
# git push - Push committed changes to a remote repository
alias gp='git push'
# git pull - Fetch and merge changes from a remote repository
alias gpl='git pull --rebase'
# git branch - List, create, or delete branches
alias gb='git branch'
# git checkout - Switch branches or restore working tree files
alias gco='git checkout'
# git checkout -b - Create and switch to a new branch
alias gcb='git checkout -b'
# git switch - Switch branches
alias gits='git switch'
# git switch -c - Create and switch to a new branch
alias gsn='git switch -c'
# git branch -d - Delete a specified branch
alias gbd='git branch -d'
# git reset --hard - Reset the current HEAD to a specified state, discarding changes
alias grh='git reset --hard'
# git reset --soft - Reset the current HEAD to a specified state, keeping changes in the working directory and staging area
alias grs='git reset --soft'
# git log - Show commit logs
alias gl='git log'
# git log --pretty=format - Show a custom formatted commit log
alias glog='git log --graph --oneline --decorate'
# git diff - Show changes between commits, commit and working tree, etc.
alias gd='git diff'
# git diff --cached - Show changes between the index () and the HEAD
alias gdc='git diff --cached'
# git status - Show the current status of the repository
alias gss='git status --short'           # Short and concise status
alias gsl='git status --long'            # Detailed status with full file paths
alias gsu='git status --untracked-files' # Show untracked files
alias gsi='git status --ignored'         # Show ignored files
alias gf='git fetch'                     # Show ignored files
alias n='nvim'


# Custom functions
extract() {
    if [ -f "$1" ]; then
        case $1 in
        *.tar.bz2) tar xvjf "$1" ;;
        *.tar.gz) tar xvzf "$1" ;;
        *.tar.xz) tar xvJf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xvf "$1" ;;
        *.tbz2) tar xvjf "$1" ;;
        *.tgz) tar xvzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "Unknown archive format" ;;
        esac
    else
        echo "File does not exist"
    fi
}

# >>> juliaup initialize >>>
path=("$HOME/.juliaup/bin" $path)
export PATH
# Lazy-load julia completions
[ -f "$HOME/.julia/juliaup/completions/zsh.zsh" ] && {
  zstyle ':completion:*' fpath ~/.julia/juliaup/completions
}
# <<< juliaup initialize <<<

export JULIA_UPDATE_LEVEL=0



export NVM_DIR="$HOME/.nvm"
# Lazy-load NVM for faster startup
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { unset -f node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@"; }
npm() { unset -f node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@"; }
npx() { unset -f node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@"; }



alias oc=opencode
alias n=nvim

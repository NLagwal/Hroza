# Path for functions (before compinit)
fpath=(/usr/share/zsh/site-functions $fpath)

# History configuration
HISTFILE=~/.config/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY          
setopt INC_APPEND_HISTORY      
setopt HIST_IGNORE_SPACE      
setopt HIST_IGNORE_DUPS        
setopt HIST_IGNORE_ALL_DUPS    
setopt HIST_REDUCE_BLANKS      
setopt HIST_VERIFY  

# Vi mode
bindkey -v

# Basic options
setopt extendedglob
setopt prompt_subst

# ---------- COMPLETION (Optimized to load dump file) ----------
autoload -Uz compinit
# Check if the completion dump file is older than any directory in fpath
# If it is, re-run compinit without -C to generate a new dump file.
if [[ -n "$ZSH_COMPDUMP" && ( ! -f "$ZSH_COMPDUMP" || "$ZSH_COMPDUMP" -ot "$fpath[1]" ) ]]; then
    compinit
else
    # Load the completion dump file directly for maximum speed.
    compinit -C
fi

# Completion Styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ---------- GIT INTEGRATION (VCS Info) ----------
autoload -Uz vcs_info
precmd() {
    # Only run vcs_info if the shell is interactive
    if [[ -o interactive ]]; then
        vcs_info
    fi
}
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
zstyle ':vcs_info:*' enable git

# ---------- PROMPT ----------
# Theme-inspired prompt
# Red Accent: #D3273F, Text: #E6E7E9, Light Yellow: #fbf1c7, Dark Yellow: #d79921
PS1='%F{#D3273F}[%f%F{#E6E7E9}%n%f%F{#D3273F}@%f%F{#d79921}%m%f %F{#fbf1c7}%~%f${vcs_info_msg_0_}%F{#D3273F}]%f
%F{#D3273F}❯%f '

#---------- PATH AND ENVIRONMENT VARIABLES ----------
export PATH="$HOME/.local/bin:$PATH"

export PATH="$PATH:/home/lag/.lmstudio/bin"

export DATA_DIR="/home/lag/.open-webui/"

# ---------- ALIASES ----------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias domake='doas env PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig make'
alias fetch='fastfetch'
alias ap='cd /home/lag/Projects/Apollo/'
# Power up for Jio
alias jio-fix="sudo sysctl -w net.ipv4.ip_default_ttl=65 && sudo ip link set dev wlan0 mtu 1280"
# Back to normal
alias jio-unfix="sudo sysctl -w net.ipv4.ip_default_ttl=64 && sudo ip link set dev wlan0 mtu 1500"

# ---------- FZF (Fuzzy Finder) Configuration ----------
# Load FZF functions/bindings
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi
if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi

export FZF_DEFAULT_OPTS='
--color=bg:#1D1A20,bg+:#1D1A20,fg:#E6E7E9,fg+:#ffffff,
--color=hl:#D3273F,hl+:#D3273F,info:#D3273F,border:#D3273F,
--color=prompt:#D3273F,pointer:#D3273F,marker:#D3273F
'
bindkey '^r' fzf-history-widget

# ---------- NVM (Node Version Manager) Lazy Initialization ----------
export NVM_DIR="$HOME/.nvm"

# Define functions for node commands that auto-load NVM on first call
# This completely bypasses the source command during shell startup.
nvm() {
  \unfunction nvm node npm yarn
  # Source NVM script and execute the command passed to the function
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() {
  \unfunction nvm node npm yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  \unfunction nvm node npm yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}

yarn() {
  \unfunction nvm node npm yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  yarn "$@"
}

# --- Syntax Highlighting Styles (Put at the very end for final customization) ---
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#E6E7E9'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#D3273F'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8ec07c,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#8ec07c,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8ec07c,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#8ec07c,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=#8ec07c,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#D3273F,underline'
ZSH_HIGHLIGHT_STYLES[path]='fg=#fbf1c7,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#fbf1c7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#E6E7E9'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#E6E7E9'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#E6E7E9'

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh


# ====================================================
#                 ENVIRONMENT & PATH
# ====================================================
typeset -U PATH # Prevent duplicate PATH entries

# 1. Editors & Language
export EDITOR="cursor --wait"
export VISUAL="cursor --wait"
export KUBE_EDITOR="cursor --wait"

# 2. Go path configuration
export PATH="$HOME/.local/bin:$HOME/go/bin:/usr/local/go/bin:$PATH"

# 3. Custom LiteLLM endpoint for Claude Code
unset CLAUDE_CODE_USE_BEDROCK
export ANTHROPIC_BASE_URL="https://xxxx"
export ANTHROPIC_AUTH_TOKEN="sk-xxxxx"
export ANTHROPIC_MODEL="anthropic.claude-sonnet-4-20250514-v1:0"

# ====================================================
#                  ZAP PLUGIN MANAGER
# ====================================================
if [ ! -f "$HOME/.local/share/zap/zap.zsh" ]; then
    mkdir -p "$HOME/.local/share/zap"
    git clone https://github.com/zap-zsh/zap.git "$HOME/.local/share/zap"
fi
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# --- Plugins ---
plug "zsh-users/zsh-autosuggestions"
plug "MichaelAquilina/zsh-you-should-use"
plug "zsh-users/zsh-history-substring-search"
plug "zsh-users/zsh-syntax-highlighting" # Needs to be loaded last

# --- Completion ---
autoload -Uz compinit && compinit

# ====================================================
#              TERMINAL TITLE & GIT INFO
# ====================================================
setopt PROMPT_SUBST
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zmodload zsh/stat

# Git format for git status
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats ' %F{240}on %b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{240}on %b|%a%u%c%f'

function update_git_info() { vcs_info; }

# Cache kubectl availability at shell startup
typeset -g HAS_KUBECTL=0
command -v kubectl &>/dev/null && HAS_KUBECTL=1

function update_terminal_title() {
    local conf="${KUBECONFIG:-$HOME/.kube/config}"
    conf="${conf%%:*}"
    local k8s_clean="$CACHED_K8S_CONTEXT"
    
    if [[ "$HAS_KUBECTL" -eq 1 ]] && [[ -f "$conf" ]]; then
        local -A fstat
        zstat -H fstat "$conf" 2>/dev/null || return
        
        if [[ "$fstat[mtime]" != "$CACHED_KUBE_MTIME" ]]; then
            local raw=$(kubectl config current-context 2>/dev/null)
            k8s_clean="${raw##*_}"
            
            export CACHED_K8S_CONTEXT="$k8s_clean"
            export CACHED_KUBE_MTIME="$fstat[mtime]"
        fi
    fi
    
    local new_title="${k8s_clean:-${PWD##*/}}"
    [[ "$new_title" != "$LAST_TERM_TITLE" ]] || return
    
    print -n "\e]0;${new_title}\a"
    export LAST_TERM_TITLE="$new_title"
}

add-zsh-hook precmd update_git_info
add-zsh-hook precmd update_terminal_title
update_terminal_title

# ====================================================
#               PROMPT & HISTORY
# ====================================================
PROMPT='%F{blue}%1~%f${vcs_info_msg_0_} $ '
RPROMPT=''

# --- UNLIMITED HISTORY  ---
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

alias history="history 0"

# --- KEYBINDINGS ---
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ====================================================
#               ALIASES & FUNCTIONS
# ====================================================
alias kx="kubectx"
alias code="cursor"
alias ls="ls -G"
alias ll="ls -lah"

function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# Disable beeps
setopt NO_BEEP 

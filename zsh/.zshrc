### Download and init zap plugin manager
# download zap if doesn't exist already
if [ ! -f "$HOME/.local/share/zap/zap.zsh" ]; then
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)
fi

#Auto added by the zap installer to init zap
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
###END of download and init zap plugin manager

###Auto added by Google Cloud SDK
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lukas.monkevicius/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/lukas.monkevicius/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/lukas.monkevicius/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/lukas.monkevicius/google-cloud-sdk/completion.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
###END of auto added by Google Cloud SDK

###Load version control information copied from https://stackoverflow.com/a/65540755
autoload -Uz vcs_info
precmd() { vcs_info }

# format vcs_info variable
zstyle ':vcs_info:git:*' formats ':%F{green}%b%f'

# set up the prompt
setopt PROMPT_SUBST
PROMPT='%F{blue}%1~%f${vcs_info_msg_0_} $ '
RPROMPT="[%D{%f/%m/%y} | %D{%L:%M:%S}]" # Added by me to have time and date on the right side
autoload -Uz compinit && compinit
###END of load version control information 

###Install pluins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "MichaelAquilina/zsh-you-should-use"
plug "zsh-users/zsh-history-substring-search"
###END of install plugins

###Setup alias
alias kx="kubectx"
alias vim="nvim"
###END of setup aliases

###Setup exports
#add go to path
export PATH=$PATH:/usr/local/go/bin 
export PATH=$PATH:$GOPATH/bin
#set vscode as default editor for k8s
export KUBE_EDITOR="code --wait"
#END of setup exports

###Custom functions
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
###END of custom functions


###Setup history from https://a4z.gitlab.io/blog/2021/05/22/Unlimited-shell-history-and-completion.html
#use a history file in here
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# make it huge, really huge.
SAVEHIST=1000000
HISTSIZE=1000000

# there is for sure still some redundancy, but ...
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
#setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.

alias history="history 0"
###END of setup history

###Bind keys for substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
###END of bind keys for substring search

# .zshrc - Should be used for the shell configuration and for executing commands.

## User configuration

# Source aliases and environment variables
source $ZDOTDIR/.zshaliases
source $HOME/.zshenv

# Zsh options (see https://zsh.sourceforge.io/Doc/Release/Options.html or https://gist.github.com/mattmc3/c490d01751d6eb80aa541711ab1d54b1)
setopt auto_cd                 # if a command isn't valid, but is a directory, cd to that dir

setopt append_history          # append to history file
setopt hist_save_no_dups       # don't write a duplicate event to the history file
setopt hist_no_store           # don't store history commands
setopt hist_reduce_blanks      # remove superfluous blanks from each command line being added to the history list
setopt share_history           # share history between all sessions
unsetopt inc_append_history      # write to the history file immediately, not when the shell exits
unsetopt inc_append_history_time # store execution time of command as well

setopt zle # turn on line editing

# Custom keybinds
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Start in a default tmux session (see https://unix.stackexchange.com/a/113768)
#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux new-session -A -s default # attach to default session or create session if it doesn't exist
#fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]] ; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# add ~/.local/bin to path
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Load files
fpath=($ZDOTDIR/addons $fpath)
autoload -Uz compinit; compinit
autoload -Uz promptinit; promptinit

# Source plugins
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] ; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  echo "zsh-syntax-highlighting not sourced"
fi

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] ; then
  export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS="vi-forward-char"
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else 
  echo "zsh-autosuggestions not sourced"
fi

# Print motd
motd-interactive-shell

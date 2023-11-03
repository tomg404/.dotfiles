# .zshrc - Should be used for the shell configuration and for executing commands.

## User configuration

# Source aliases and environment variables
source $ZDOTDIR/.zshaliases
source $HOME/.zshenv

# Zsh options (see https://zsh.sourceforge.io/Doc/Release/Options.html)
setopt AUTO_CD
setopt HIST_SAVE_NO_DUPS

# Custom keybinds
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Set your language environment
export LANG=en_US.UTF-8

# Start in a default tmux session (see https://unix.stackexchange.com/a/113768)
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s default # attach to default session or create session if it doesn't exist
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
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
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
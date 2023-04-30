# .zshrc - Should be used for the shell configuration and for executing commands.
# Really good guide to configure everything without oh-my-zsh

## User configuration

# Source aliases and environment variables
source $ZDOTDIR/.zshaliases
source $HOME/.zshenv

# Zsh options (see https://zsh.sourceforge.io/Doc/Release/Options.html)
setopt AUTO_CD
setopt HIST_SAVE_NO_DUPS

# Set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Load files
fpath=($ZDOTDIR/addons $fpath)
autoload -Uz compinit; compinit
autoload -Uz promptinit; promptinit

# Source plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Set theme. See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Case / hyphen sensitive completion
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

# Auto update behavior
zstyle ':omz:update' mode reminder

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

source $ZSH/oh-my-zsh.sh

## User configuration

# Set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# source aliases
source $ZDOTDIR/.zshaliases

# source environment variables
source $ZDOTDIR/.zshenv


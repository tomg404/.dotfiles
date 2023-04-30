# .zshenv - Should only contain user’s environment variables.

# Basic stuff
export EDITOR=nvim
export VISUAL=code

# XDG variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# ZSH stuff
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000 # Maximum lines in internal history
export SAVEHIST=10000 # Maximum lines of saved history file
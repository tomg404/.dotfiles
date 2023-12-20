# .zshenv - Should only contain user’s environment variables.

# Basic stuff
export EDITOR=nvim
export VISUAL=nvim

# XDG variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ZSH stuff
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000 # Maximum lines in internal history
export SAVEHIST=10000 # Maximum lines of saved history file

# recommended by xdg-ninja
export ANDROID_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GDBHISTFILE="$XDG_CONFIG_HOME"/gdb/.gdb_history
export GEF_RC="$XDG_CONFIG_HOME"/gef/.gef.rc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var

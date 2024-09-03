# use .zshenv file in ZDOTDIR as suggested by https://github.com/mattmc3/zdotdir
export ZDOTDIR=~/.config/zsh
[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv

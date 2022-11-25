#!/bin/bash

# list of all configuration folders
configurations=(
    "alacritty"
    "conky"
    "gdb"
    "neofetch"
    "nvim"
    "tmux"
    "tmuxinator"
    "zsh"
)

# location of the dotfiles repository
dotfiles_path="$HOME/.dotfiles"

# stow parameters
verbosity_level="1"             # verbosity level from 0 to 5
dry_run="-n"                    # empty string for actual run, -n for dry run
stow_directory=$dotfiles_path   # probably no need to change
target_directory=$HOME          # probably no need to change

# print help message and exit
print_help() {
    echo "Usage: $0 stow-all"
    echo "       $0 unstow-all"
    exit 0
}

# allowed arguments for script
STOW_ALL_CMD="stow-all"
UNSTOW_ALL_CMD="unstow-all"

# exit if no command line argument was specified
if [[ -z $1 ]]; then
    print_help
fi

# stow everything
if [ "$1" = "$STOW_ALL_CMD" ]; then
    for config in "${configurations[@]}"
    do
        stow -v $verbosity_level $dry_run --dir=$stow_directory --target=$target_directory --stow $config
        echo "$config"
    done

# unstow everything
elif [ "$1" = "$UNSTOW_ALL_CMD" ]; then
    for config in "${configurations[@]}"
    do
        stow -v $verbosity_level $dry_run --dir=$stow_directory --target=$target_directory --delete $config
    done

# unknown argument
else
    print_help
fi


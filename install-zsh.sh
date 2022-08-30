#!/bin/bash

### SETUP ENVIRONMENT VARIABLES
touch $HOME/.zshenv
echo 'export XDG_CONFIG_HOME="$HOME/.config"' > $HOME/.zshenv
echo 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' > $HOME/.zshenv

### SYMLINK ZSH-CONFIG to .config/zsh
stow zsh

### INSTALL LATEST ZSH VERSION
sudo apt-get install zsh -y

### SET ZSH AS DEFAULT SHELL
sudo chsh -s $(which zsh)

### INSTALL OHMYZSH
#ZSH="$HOME/.config/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


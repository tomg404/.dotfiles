#!/bin/bash

### Setup environment variables
touch $HOME/.zshenv
echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> $HOME/.zshenv  # set default location for config files
echo 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' >> $HOME/.zshenv   # set folder for zsh config files
echo 'export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"' >> $HOME/.zshenv # set $ZSH to oh-my-zsh folder

### Symlink zsh config folder to $HOME/.config/zsh (using GNU stow)
stow zsh

### Install latest version of zsh
sudo apt-get install zsh -y

### Install plugins
sudo apt-get install zsh-autosuggestions

### Change default shell to zsh (does not work reliably!)
sudo chsh -s $(which zsh)

### INSTALL OHMYZSH
ZSH="$HOME/.dotfiles/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


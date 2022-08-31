#!/bin/bash

### Setup environment variables
touch $HOME/.zshenv
echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> $HOME/.zshenv  # default location for config files : /home/user/.config
echo 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' >> $HOME/.zshenv   # folder for zsh config files

### Symlink zsh config folder to $HOME/.config/zsh (using GNU stow)
stow zsh

### Install latest version of zsh
sudo apt-get install zsh -y

### Change default shell to zsh (does not work reliably!)
sudo chsh -s $(which zsh)

### INSTALL OHMYZSH
#ZSH="$HOME/.config/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


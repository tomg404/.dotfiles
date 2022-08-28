#!/bin/bash

### INSTALL LATEST ZSH VERSION
sudo apt-get install zsh -y

### SET ZSH AS DEFAULT SHELL
sudo chsh -s $(which zsh)

### INSTALL OHMYZSH
ZSH="$HOME/.dotfiles/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#!/bin/bash

### SET ZSH CONFIG DIR TO BE IN .config
export ZDOTDIR='$HOME/.config/zsh'
source /etc/profile

### INSTALL LATEST ZSH VERSION
sudo apt-get install zsh -y

### SET ZSH AS DEFAULT SHELL
sudo chsh -s $(which zsh)

### INSTALL OHMYZSH
ZSH="$HOME/.config/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

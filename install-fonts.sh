#!/bin/bash

# This script is adapted from:
# https://github.com/mu-gaimann/mise-en-place

### Download Meslo font 
curl https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip

### Unzip font and install to local font directory
mkdir -p ~/.local/share/fonts/meslo-nerd-fonts/
unzip -o Meslo.zip -d ~/.local/share/fonts/meslo-nerd-fonts/
rm Meslo.zip

### Rebuild font cache
fc-cache ~/.local/share/fonts
fc-cache -f -v
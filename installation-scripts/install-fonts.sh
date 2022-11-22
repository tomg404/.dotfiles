#!/bin/bash

# This script is adapted from:
# https://github.com/mu-gaimann/mise-en-place

url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip"
file="Meslo.zip"

### Download Meslo font 
if curl -o "${PWD}/${file}" -L ${url}; then
    echo 'Font downloaded successfully'
else
    echo 'Something went wrong while downloading'
    exit 1
fi

### Unzip font and install to local font directory
mkdir -p ~/.local/share/fonts/meslo-nerd-fonts/
unzip -o ${file} -d ~/.local/share/fonts/meslo-nerd-fonts/
rm ${file}

### Rebuild font cache
fc-cache ~/.local/share/fonts
fc-cache -f -v

### Output
echo 'Font was installed successfully!'
echo 'A restart might be necessary for the font to appear in the terminal settings!'
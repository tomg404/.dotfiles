#!/bin/bash

### UPDATE SYSTEM
sudo apt-get update -y
sudo apt-get upgrade -y

### CORE STUFF
sudo apt-get install git -y
sudo apt-get install curl -y
sudo apt-get install stow -y            # managing config files
sudo apt-get install okular -y          # best pdf reader
sudo apt-get install ffmpeg -y

### BASIC TERMINAL STUFF
sudo apt-get install tmux -y
sudo apt-get install neovim -y          # maybe remove: need version >= 0.8.0 for astronvim

### SYSTEM STUFF
sudo apt-get install lm-sensors -y
sudo apt-get install tlp -y             # maybe remove

### BACKUP AND SECURITY
sudo apt-get install keepassxc -y       # best password manager
sudo apt-get install synology-drive -y

### FILE PROCESSING
sudo apt-get install unzip -y

### APP IMAGE STUFF
sudo apt-get install libfuse2 -y
sudo apt-get install appimagelauncher -y
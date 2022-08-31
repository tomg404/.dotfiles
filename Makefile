all: install

install:
	sh install-core.sh
	stow --verbose nvim zsh
	sh install-fonts.sh
	sh install-zsh.sh
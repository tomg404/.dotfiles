all: install

install:
	stow --verbose nvim zsh
	sh install-core.sh
	sh install-fonts.sh
	sh install-zsh.sh
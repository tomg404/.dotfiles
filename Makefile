scripts = installation-scripts

all: install

install:
	sh $(scripts)/install-core.sh
	sh $(scripts)/install-fonts.sh
	sh $(scripts)/install-zsh.sh

core:
	sh $(scripts)/install-core.sh
	
fonts:
	sh $(scripts)/install-fonts.sh
	
term:
	sh $(scripts)/install-zsh-and-term.sh

clean:


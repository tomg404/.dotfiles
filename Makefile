
DIRS=$(find . -maxdepth 2 -type d -name ".config" ! -path "./archive/*" -printf "%h ")
all:
	echo $(DIRS)

stow-all:
	stow --verbose --target=$$HOME --stow $(DIRS) --simulate
	
unstow-all:
	stow --verbose --target=$$HOME --delete --simulate

cron:
	crontab -u $USER cron 

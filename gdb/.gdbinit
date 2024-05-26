source ~/.config/gdb/custom_commands.py
source ~/.config/gdb/ptrfind.py
source /usr/share/gef/gef.py

set auto-load safe-path /
set debuginfod enabled on

#set follow-fork-mode child
#catch fork
#catch exec

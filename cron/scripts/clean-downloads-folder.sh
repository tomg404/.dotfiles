#!/bin/bash

export XDG_RUNTIME_DIR=/run/user/$(id -u)

# settings: files/folders which are older than x days are deleted
older_than=7

files_delete=$(find $HOME/Downloads/ -maxdepth 1 -mtime +"$older_than")
num_files_delete=$(echo "$files_delete" | wc --lines)

echo "Deleting files ...\n" "$files_delete"
echo "Files to delete: $num_files_delete"

# Delete files and notify
find $HOME/Downloads/ -maxdepth 1 -mtime +"$older_than" -exec rm -r "{}" \;
notify-send -u critical -t 10000 -a "Cleanup" "Deleted $num_files_delete files from ~/Downloads"

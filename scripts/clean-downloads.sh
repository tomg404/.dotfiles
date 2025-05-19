#/bin/sh

export XDG_RUNTIME_DIR=/run/user/$(id -u)

# TODO: maybe switch to deletion by `creation date` (-ctime) as this
# would delete files after x days regardless of their modifcation date.
# this would be a way stricter policy and would keep the download
# folder cleaner

# downloads folder location
DOWNLOADS="$HOME/Downloads"

# all files and folders with a `modification date` older
# than DAY_THRESHOLD days will be deleted
DAY_THRESHOLD=7

# delete files
# N=$(find "$DOWNLOADS" -mtime "+$DAY_THRESHOLD" -type f -printf '.' | wc -c)
N=$(find "$DOWNLOADS" -mtime "+$DAY_THRESHOLD" -type f -printf '.' -exec rm {} \; | wc -c)

# delete empty (top level) folders
# N=$(find "$DOWNLOADS" -maxdepth 1 -type d -empty -printf '.' | wc -c)
M=$(find "$DOWNLOADS" -maxdepth 1 -type d -empty -printf '.' -delete | wc -c)

echo "Deleted $N files in $M folders from $DOWNLOADS"
notify-send \
  -a 'Downloads Cleaner' \
  -i '/usr/share/icons/Papirus-Dark/24x24/actions/trash-empty.svg' \
  "Deleted $N files in $M folders from $DOWNLOADS"

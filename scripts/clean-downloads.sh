#/bin/sh

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
echo "Deleted $N files"

# delete empty (top level) folders
# N=$(find "$DOWNLOADS" -maxdepth 1 -type d -empty -printf '.' | wc -c)
N=$(find "$DOWNLOADS" -maxdepth 1 -type d -empty -printf '.' -delete | wc -c)
echo "Deleted $N empty folders"

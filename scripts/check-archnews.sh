#!/bin/sh

# check if xmlstarlet and curl exist
if ! command -v xmlstarlet &> /dev/null; then
  echo "Error executing $0: 'xmlstarlet' not installed" >&2
  exit 1
fi
if ! command -v curl &> /dev/null; then
  echo "Error executing $0: 'curl' not installed" >&2
  exit 1
fi

# create temp file
TMP_FILE=$(mktemp)
trap 'rm -f "$TMP_FILE"' EXIT

# fetch arch news feed
curl --fail --silent "https://archlinux.org/feeds/news/" -o "$TMP_FILE"
if [ $? -ne 0 ]; then
  echo "Error executing $0: curl failed to fetch arch news page"
  exit 1
fi

# print news table
echo "+-----------------------------------------------------------------+"
echo "| Arch News Feed (Don't forget to update your system)             |"
echo "+-------------+---------------------------------------------------+"

xmlstarlet sel -t -m "//item" -v "concat('| ', substring(pubDate, 6, 11), ' | ', substring(concat(title, '                                                  '), 0, 50), ' |')" -n < "$TMP_FILE"
echo "+-------------+---------------------------------------------------+"


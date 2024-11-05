#!/usr/bin/env sh

# Make sure minid isn't running or the database will be locked
if pgrep -x "minid" > /dev/null
then
    echo "minid is running. Please stop it before running this script."
    exit 1
fi

echo "Exporting checkers-torram state..."
minid export | jq '.app_state["checkers-torram"]'

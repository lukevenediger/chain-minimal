#!/usr/bin/env sh

# Usage: minid-get-game.sh <game-id>
# Ensure game ID is passed in
if [ -z "$1" ]; then
  echo "Usage: $0 <game-id>"
  exit 1
fi

GAME_ID=$1

# Fetch the game
minid q checkers-torram get-game ${GAME_ID} --output json | jq
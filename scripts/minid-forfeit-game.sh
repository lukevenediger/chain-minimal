#!/usr/bin/env sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_minid_functions.sh"

# Usage: minid-forfeit-game.sh <game-id> <wallet-name>
# Ensure game ID is passed in
if [ -z "$2" ]; then
  echo "Usage: $0 <game-id> <wallet-name>"
  exit 1
fi

GAME_ID=$1
WALLET_NAME=$2

echo "Forfeiting game $GAME_ID from $WALLET_NAME"

# Forfeit a game 
TX_HASH=$(minid tx checkers-torram forfeit ${GAME_ID} \
    --from ${WALLET_NAME} \
    --output json \
    --yes | jq -r '.txhash')

wait_for_tx ${TX_HASH}
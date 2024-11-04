#!/usr/bin/env sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_minid_functions.sh"

# Ensure game ID is passedb in
if [ -z "$1" ]; then
  echo "Usage: $0 <game-id>"
  exit 1
fi

# Save game ID
GAME_ID=$1

echo "Creating game with ID: $GAME_ID"

# Grab Alice and Bob's wallet addresses
ALICE_WALLET=$(minid keys list --keyring-backend test --output json | jq -r ".[] | select(.name == \"alice\") | .address")
BOB_WALLET=$(minid keys list --keyring-backend test --output json | jq -r ".[] | select(.name == \"bob\") | .address")

# Create the game
TX_HASH=$(minid tx checkers-torram create ${GAME_ID} ${ALICE_WALLET} ${BOB_WALLET} \
    --from alice \
    --output json \
    --yes | jq -r '.txhash')

wait_for_tx ${TX_HASH}

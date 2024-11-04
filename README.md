# Mini - The Checkers Hosting Chain

This chain is a simple implementation of a checkers hosting chain. It allows users to create games, join games, and play games. The chain is built using the Cosmos SDK.

## How to use

In addition to learn how to build a chain thanks to `minid`, you can as well directly run `minid`.

### Installation

Install and run `minid`:

```sh
git clone git@github.com:lukevenediger/chain-minimal.git
cd chain-minimal
make install # install the minid binary
make init # initialize the chain
minid start # start the chain
```

## Helpful Scripts

The `scripts` directory contains a few helpful shell scripts to interact with the chain's checkers-torram module.

* Create a game
  * Usage: `scripts/minid-create-game.sh <game-id>`
  * Creates a new game with <game-id>, alice as player 1, and bob as player 2
* Forfeit a game
  * Usage: `scripts/minid-forfeit-game.sh <game-id>`
  * Forfeits the game with <game-id> and signed by alice
* Get a game
  * Usage: `scripts/minid-get-game.sh <game-id>`
  * Gets the game state with <game-id>
* Export Game State
    * Usage: `scripts/minid-export-game.sh`
    * Exports the game state with <game-id> to a file
    * Note: make sure the chain is not running, or it will fail with a database initalization error

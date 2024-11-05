# Mini - The Checkers Hosting Chain

This chain hosts the [checkers-torram](https://github.com/lukevenediger/checkers) module, providing users with a way to play checkers on the blockchain. It is build using [Cosmos SDK 0.50.1](https://github.com/cosmos/cosmos-sdk/releases/tag/v0.50.10)

## Prerequisites

To run this chain, you will need the following installed on your machine:
 * Go 1.21 or later
 * Make
 * jq

## Installation

Install and run `minid`:

```sh
git clone git@github.com:lukevenediger/chain-minimal.git
cd chain-minimal
make install # install the minid binary
make init # initialize the chain
minid start # start the chain
```

Your chain is now initialised and ready to use. There are two wallets added to the test keyring backend: `alice` and `bob`.

> ⚠️ **WARNING** Wallets in the `test` keyring backend are stored in unencrypted plain text. Do not use them on any chain where real funds are at risk.

Verify your installation by listing the wallets in your keyring
    
```sh
minid keys list --keyring-backend test
```

## Usage

You will need two terminal windows to interact with the chain. 

In the first terminal, start the chain:

```sh
minid start
```

In the second terminal, you can interact with the chain using the `minid` command. For example, get the chain's current block height:

```sh
minid status | jq -r '.sync_info.latest_block_height'
```

## Playing Checkers with `checkers-torram`
The [checkers-torram](https://github.com/lukevenediger/checkers) module is a simple implementation of a checkers game.

### Create a Game
Create a new checkers game called `game1` using Alice and Bob's wallet addresses.
Note that the game ID must be unique and cannot be re-used.

```sh
minid tx checkers-torram create game1 <address-1> <address-2> --from alice --yes
```

### Get the Game State
Once the game is created, you can get the game state with the `get-game` query:

```sh
minid query checkers-torram get-game game1
```

**Note**: The game may only be queried after the game creation transaction is
included in a block. You may query the status of this transaction using the `query tx` command:

```sh
minid query tx <tx-hash>
```

### Forfeiting a Game
If a player wants to forfeit a game, they can do so using the `forfeit` command.
Only the player who is waiting for their turn can forfeit the game.

```sh
minid tx checkers-torram forfeit game1 --from alice --yes
```

## Helpful Scripts

The `scripts` directory contains a few helpful shell scripts to interact with the chain's checkers-torram module.

For scripts running transactions, it will wait for the transaction to be included in a block before returning by using the `tx wait-tx` command.


| Script | Usage | Description |
| ---- | ---- | ---- |
| Create a Game  | `scripts/minid-create-game.sh <game-id>` | Creates a new game with `<game-id>`, with Alice as player 1 and Bob as player 2. |
| Forfeit a Game | `scripts/minid-forfeit-game.sh <game-id>` | Forfeits the game with `<game-id>`, signed by Alice. |
| Get a Game | `scripts/minid-get-game.sh <game-id>` | Retrieves the game state for `<game-id>`. |
| Export Game State | `scripts/minid-export-game.sh` | Exports the game state to a file. <br/>**Note:** Ensure the chain is not running, or it will fail with a database initialization error. |

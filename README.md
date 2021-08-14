# TRON Smart Contracts

This repository contains sample smart contracts for the TRON blockchain, including:

- AdvancedToken.sol: A sample ERC20 token contract with additional functionality such as burn and mint.
- Kingdoms.sol: A sample strategy game where players can claim land and build structures.
- RockPaperScissors.sol: A sample game where players can play rock-paper-scissors against each other.
- SimpleStorage.sol: A sample contract that demonstrates how to store and retrieve data on the TRON blockchain.
- ZombieSurvival.sol: A sample action game where players can survive in a zombies apocalypse.

## Requirements
- [TronBox](https://github.com/TRON-US/tronbox)

## Deployment

1. Install TronBox and TronWeb
```shell
npm install -g tronbox
npm install tronweb
```
2. Compile the contracts
```shell
tronbox compile
```
3. Deploy the contracts to the TRON network using TronBox
```shell
tronbox migrate --network mainnet
```

## Usage
You can interact with the contracts using TronWeb or a TRON wallet such as [TronLink](https://www.tronlink.org/)

## License
This repository is licensed under the Mozilla Public License Version 2.0. See the LICENSE file for more details.
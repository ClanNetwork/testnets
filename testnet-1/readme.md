# Clan Network's testnet-1 Testnet Instructions: Part 1

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

## Software requirements

- Latest version : (https://github.com/ClanNetwork/clan-network/releases/tag/latest)

### Install Clan Network

Requires [Go version v1.18+](https://golang.org/doc/install)

#### Build Clan Network from source

```sh
mkdir -p $GOPATH/src/github.com/ClanNetwork
cd $GOPATH/src/github.com/ClanNetwork
git clone https://github.com/ClanNetwork/clan-network && cd clan-network
git fetch origin --tags
make build && make install
```

#### Verify installation

To verify if the installation was successful, execute the following command:

```sh
cland version --long
```

It will display the cland of `cland` currently installed:

```sh
name: Clan-Network
server_name: clan-networkd
version: latest-a7ee4541
commit: a7ee4541dbb19e55221bbb575284eeb39c462610
build_tags: ""
go: go version go1.18 darwin/amd64
```

## Create testnet validator

1. Init Chain and start your node

   ```sh
   > cland init <moniker-name> --chain-id=testnet-1
   ```

2. Create a local key pair

   ```sh
   > cland keys add <key-name>
   > cland keys show <key-name> -a
   ```

3. Download genesis
   Fetch `genesis.json` into `cland`'s `config` directory.

   ```sh
   > curl -s https://raw.githubusercontent.com/ClanNetwork/testnets/main/testnet-1/genesis.json > genesis.json
   > mv genesis.json ~/.clan/config/
   ```

4. Create validator

   ```sh
   $ cland tx staking create-validator \
   --amount 50000000uclan \
   --commission-max-change-rate "0.1" \
   --commission-max-rate "0.20" \
   --commission-rate "0.1" \
   --min-self-delegation "1" \
   --details "validators write bios too" \
   --pubkey=$(cland tendermint show-validator) \
   --moniker <your_moniker> \
   --chain-id testnet-1 \
   --gas-prices 0.025uclans \
   --from <key-name>
   ```

5. Request tokens from the Faucet if you need more (TBD Link).

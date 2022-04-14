# Clan Network's testnet-1 Testnet Instructions: Part 1

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

## Software requirements

- [Ubuntu Setup Guide](./ubuntu.md)
- Latest version : (https://github.com/ClanNetwork/clan-network/releases/tag/latest)

### Install Clan Network

#### Install Go

Clan Network is built using Go and requires Go version 1.18+. In this example, we will be installing Go on Ubuntu 20.04:

```sh
# First remove any existing old Go installation
sudo rm -rf /usr/local/go

# Install the latest version of Go using this helpful script
curl https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

# Update environment variables to include go
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
```

To verify that Go is installed:

```sh
go version
# Should return go version go1.16.4 linux/amd64
```

#### Build Clan Network from source

```sh
mkdir -p $GOPATH/src/github.com/public-awesome
cd $GOPATH/src/github.com/ClanNetwork
git clone https://github.com/ClanNetwork/clan-network && cd clan-network
git fetch origin --tags
make build linux && make install
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
   > curl -s https://raw.githubusercontent.com/ClanNetwork/testnets/main/testnet-1/genesis/genesis.tar.gz > genesis.tar.gz
   > tar -C ~/.clan/config/ -xvf genesis.tar.gz
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

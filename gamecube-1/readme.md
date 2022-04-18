# Clan Network's gamecube-1 Testnet Instructions: Part 1

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

## Software requirements

- Latest version : (https://github.com/ClanNetwork/clan-network/releases/tag/latest)

## Install Clan Network

### Option 1: Download binary

1. Download the binary for your platform: [releases](https://github.com/ClanNetwork/clan-network/releases/tag/latest).
2. Copy it to a location in your PATH, i.e: `/usr/local/bin` or `$HOME/bin`.

i.e:

```sh
> wget https://github.com/ClanNetwork/clan-network/releases/download/latest/clan-network_latest_linux_amd64.tar.gz
> sudo tar -C /usr/local/bin -zxvf clan-network_latest_linux_amd64.tar.gz
```

### Option 2: Build from source

Requires [Go version v1.18+](https://golang.org/doc/install)

```sh
# 1. Download the archive

wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz

# Optional: remove previous /go files:

sudo rm -rf /usr/local/go

# 2. Unpack:

sudo tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz

# 3. Add the path to the go-binary to your system path:
# (for this to persist, add this line to your ~/.profile or ~/.bashrc or  ~/.zshrc)

export PATH=$PATH:/usr/local/go/bin

# 4. Verify your installation:

go version

# go version go1.18.1 linux/amd64
```

```sh
mkdir -p $GOPATH/src/github.com/ClanNetwork
cd $GOPATH/src/github.com/ClanNetwork
git clone https://github.com/ClanNetwork/clan-network && cd clan-network
git fetch origin --tags
make install
```

## Verify installation

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
   > cland init <moniker-name> --chain-id=gamecube-1
   ```

2. Create a local key pair

   ```sh
   > cland keys add <key-name>
   > cland keys show <key-name> -a
   ```

3. Download genesis
   Fetch `genesis.json` into `cland`'s `config` directory.

   ```sh
   > curl -s https://raw.githubusercontent.com/ClanNetwork/testnets/main/gamecube-1/genesis/genesis.tar.gz > genesis.tar.gz
   > tar -C ~/.clan/config/ -xvf genesis.tar.gz
   ```

   **Genesis sha256**

   ```sh
    shasum -a 256 ~/.clan/config/genesis.json
   7a496cddea2538231af2179129447999725b60000b9073f39007485df7fc2961  /home/amit/.clan/config/genesis.json
   ```

4. Add persistent peers
   Add persistent peers in `config.toml`.

   ```sh
   > vi $HOME/.clan/config/config.toml
   ```

   Find the following section and add the seed nodes.

   ```sh
   # Comma separated list of seed nodes to connect to
   seeds = ""
   ```

   ````sh
   # Comma separated list of persistent peers to connect to
   persistent_peers = "15bd2b7e8c2f4335dc65f11bc1f432dc2e99ea7e@104.196.221.90:26656"
   ```ֿ
   ````

## Start node automatically (Linux only)

Create a `systemd` service

```sh
> sudo vi /etc/systemd/system/cland.service
```

Copy and paste the following and update `<your_username>` and `<go_workspace>`:

```sh
[Unit]
Description=cland
After=network-online.target

[Service]
User=<your_username>
ExecStart=/home/<your_username>/<go_workspace>/bin/cland start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

**This assumes `$HOME/go_workspace` to be your Go workspace. Your actual workspace directory may vary.**

```sh
> sudo systemctl enable cland
> sudo systemctl start cland
```

## Create testnet validator

1. Request tokens from the Faucet (TBD Link).

2. Create validator

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
   --chain-id gamecube-1 \
   --gas-prices 0.025uclans \
   --from <key-name>
   ```

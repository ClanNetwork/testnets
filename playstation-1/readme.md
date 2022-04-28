# Clan Network PlayStation-1 Testnet Instructions (2/2): Prepare Node

## Details

**cland version**
`v1.0.4-alpha`

**Genesis file**

```
https://github.com/ClanNetwork/testnets/playstation-1/genesis.json
```

**Genesis sha256**

```
00df7ac7b9477597cbe5d551661190013173f2ec1985fe91f7db70c3af011d42
```

**Persistent Peers**

```
persistent_peers = "43de6c2ae93262a7369f2134c19cc87109c41006@34.73.151.40:26656,c8cf12593970f5762019f0742f911df31fc2c018@34.138.179.136:26656"
```

**Seed nodes**

N/A

## Overview

Thank you for submitting a gentx! This guide will provide instructions on getting ready for the testnet.

**The Chain Genesis Time is on 17:00 UTC on April 28, 2022**

Please have your validator up and ready by this time, and be available for further instructions if necessary
at that time.

The primary point of communication for the genesis process will be the #validators. Right now only white-listed validators can participate.
channel on the [Clan's Discord](http://discord.gg/9m4JBfD3bh).

## Instructions

This guide assumes that you have completed the [Submit Gentx part](https://github.com/ClanNetwork/testnets/blob/main/playstation-1/submit-gentx.md).
You should be running on a machine that meets the hardware requirements specified in Part 1 with Go installed. We are assuming you already have a daemon home (`$HOME/.clan`) setup.

These examples are written targeting an Ubuntu 20.04 system. Relevant changes to commands should be made depending on the OS/architecture you are running on.

Prerequisites:
You will need `jq` and for some optional parts `make` and `git`
installation:

```sh
sudo apt install build-essential jq -y

sudo apt install git
```

### 1. Update cland to v1.0.4-alpha

Please update to the `v1.0.4-alpha` tag and rebuild your binaries.

There are 2 options available:

- [Download binary from github](#option-1-download-binary-from-github)
- [Build from source](#option-2-build-from-source)

#### Option 1: Download binary from github

1. Download the binary for your platform: [releases](https://github.com/ClanNetwork/clan-network/releases/tag/v1.0.4-alpha).
2. Copy it to a location in your PATH, i.e: `/usr/local/bin` or `$HOME/bin`.

```sh
wget https://github.com/ClanNetwork/clan-network/releases/download/v1.0.4-alpha/clan-network_v1.0.4-alpha_linux_amd64.tar.gz
sudo tar -C /usr/local/bin -zxvf clan-network_v1.0.4-alpha_linux_amd64.tar.gz
```

#### Option 2: Build from source

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
git clone https://github.com/ClanNetwork/clan-network
cd clan-network
git fetch origin --tags
git checkout v1.0.4-alpha

make build & make install

sudo cp ./bin/cland /usr/local/bin/cland
```

### 2. Verify installation

Verify that everything is OK.

```sh
cland version --long
name: Clan-Network
server_name: clan-networkd
version: 1.0.4-alpha
commit: 7a6a92d782c978ac730e337b28d2bc927e809739
build_tags: ""
go: go version go1.18 darwin/amd64
```

If the software version does not match, then please check your `$PATH` to ensure the correct `cland` is running.

### 3. Genesis file

There are 2 options available to retrieve the genesis file:

- [Download genesis file](#option-1-download-genesis-file)
- [Generate the genesis file yourself](#option-2-generate-genesis-file)

#### Option 1: Download Genesis file

[Genesis File](/playstation-1/genesis.json):

```bash
curl -s  https://raw.githubusercontent.com/ClanNetwork/testnets/main/playstation-1/genesis.json > ~/.clan/config/genesis.json
```

#### Option 2: Generate Genesis File

clone the testnets folder

```sh
git clone https://github.com/ClanNetwork/testnets
cd testnets
```

If you haven't already, install jq

```sh
# Install packages necessary to run go and jq for pretty formatting command line outputs
sudo apt install build-essential jq -y
```

Update to the latest:

```sh
git checkout master
git pull
```

Build the genesis file:

```sh
sudo chmod +x ./build-playstation-1-genesis.sh
./build-playstation-1-genesis.sh
```

\_NOTE: This can take a while

#### Verify your genesis file was created properly

```sh
sha256sum ~/.clan/config/genesis.json
00df7ac7b9477597cbe5d551661190013173f2ec1985fe91f7db70c3af011d42
```

### 4. Updates to config files

#### Add persistent peers in `config.toml`.

```sh
vim $HOME/.clan/config/config.toml
```

```
persistent_peers = "43de6c2ae93262a7369f2134c19cc87109c41006@34.73.151.40:26656,c8cf12593970f5762019f0742f911df31fc2c018@34.138.179.136:26656"
```

#### Set 0 gas prices in `app.toml`:

```sh
vim $HOME/.clan/config/app.toml
```

```sh
minimum-gas-prices = "0uclan"
```

### 5. Start your node

Now that everything is setup and ready to go, you can start your node.

```sh
cland start
```

You will need some way to keep the process always running. If you're on linux, you can do this by creating a
service.

```sh
sudo tee /etc/systemd/system/cland.service > /dev/null <<'EOF'
[Unit]
Description=Clan daemon
After=network-online.target

[Service]
User=<your-username>
ExecStart=/home/<your-username>/go/bin/cland start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable cland
sudo systemctl start cland

sudo tee ./status.sh <<'EOF'
sudo systemctl status cland

echo "cland service started"
EOF
```

Then update and start the node

```sh
sudo -S systemctl daemon-reload
sudo -S systemctl enable cland
sudo -S systemctl start cland
```

You can check the status with:

```sh
systemctl status cland
```

## Conclusion

Good luck! See ya in the Discord!

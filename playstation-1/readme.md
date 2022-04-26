# Clan Network PlayStation-1 Testnet Instructions (2/2): Prepare Node

Genesis file: https://github.com/ClanNetwork/testnets/genesis-files/playstation-1.json

Hash: TBD

Seeds: TBD

Peers: TBD

## Overview

Thank you for submitting a gentx! This guide will provide instructions on getting ready for the testnet.

**The Chain Genesis Time is TBD**

Please have your validator up and ready by this time, and be available for further instructions if necessary
at that time.

The primary point of communication for the genesis process will be the #validators
channel on the [Clan's Discord](https://discord.com/invite/gnEeUKM8TW).

## Instructions

This guide assumes that you have completed the [Submit Gentx part](playstation-1/submit-gents.md). You should be running on a machine that meets the hardware requirements specified in Part 1 with Go installed. We are assuming you already have a daemon home (`$HOME/.clan`) setup.

These examples are written targeting an Ubuntu 20.04 system. Relevant changes to commands should be made depending on the OS/architecture you are running on.

### Update cland to v1.0.1-alpha

Please update to the `v1.0.1-alpha` tag and rebuild your binaries.

```sh
git clone https://github.com/ClanNetwork/clan-network
cd clan-network
git checkout v1.0.1-alpha

make install
```

### Verify installation

Verify that everything is OK.

```sh
name: Clan-Network
server_name: clan-networkd
version: 1.0.1-alpha
commit: 3b4431318eeb2bf4828e8112536da0722dc3644d
build_tags: ""
go: go version go1.18 darwin/amd64
```

If the software version does not match, then please check your `$PATH` to ensure the correct `cland` is running.

### Save chain-id in config

Please save the chain-id to your `client.toml`. This will make it so you do not have to manually pass in the chain-id flag for every CLI command.

```sh
cland config chain-id playstation-1
```

### Generate genesis file

Note:
If you wan't to skip this part you can just download the final genesis file :https://github.com/ClanNetwork/testnets/genesis-files/playstation-1.json

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

Verify your genesis file was created properly:

```sh
sha256sum ~/.clan/config/genesis.json
TBD
```

### Updates to config files

You should review the `config.toml` and `app.toml` that was generated when you ran `cland init` last time.

When it comes the min gas fees, our recommendation is to leave this blank for now (charge no gas fees), to make the UX as seamless as possible
for users to be able to pay with IBC assets. So in `app.toml`:

```sh
minimum-gas-prices = ""
```

### Start your node

Now that everything is setup and ready to go, you can start your node.

```sh
cosmovisor start
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
systemctl status cland | jq
```

## Conclusion

Good luck! See ya in the Discord!

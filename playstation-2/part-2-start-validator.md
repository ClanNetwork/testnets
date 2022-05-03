# Clan Network PlayStation-2 Testnet Instructions (2/2): Prepare Node

## Details

**Version**
`v1.0.4-alpha`

**Genesis Time**
8:00 UTC on May 4, 2022

**Genesis File**

```
TBD
```

**Genesis Sha256**

```
TBD
```

**Persistent Peers**

```sh
persistent_peers = "be8f9c8ff85674de396075434862d31230adefa4@35.231.178.87:26656,0cb936b2e3256c8d9d90362f2695688b9d3a1b9e@34.73.151.40:26656,e85dc5ec5b77e86265b5b731d4c555ef2430472a@23.88.43.130:26656,9d7ec4cb534717bfa51cdb1136875d17d10f93c3@116.203.60.243:26656,3049356ee6e6d7b2fa5eef03555a620f6ff7591b@65.108.98.218:56656,61db9dede0dff74af9309695b190b556a4266ebf@34.76.96.82:26656,d97c9ac4a8bb0744c7e7c1a17ac77e9c33dc6c34@34.116.229.135:26656"
```

**Seed nodes**

N/A

## Overview

Thank you for submitting a gentx! This guide will provide instructions on getting ready for the testnet.

**The Chain Genesis Time is on 8:00 UTC on May 4, 2022**

Please have your validator up and ready by this time, and be available for further instructions if necessary
at that time.

The primary point of communication for the genesis process will be the #validators. Right now only white-listed validators can participate.
channel on the [Clan's Discord](http://discord.gg/9m4JBfD3bh).

## Instructions

This guide assumes that you have completed the [Submit Gentx part](https://github.com/ClanNetwork/testnets/blob/main/playstation-2/part-1-submit-gentx.md).

You should be running on a machine that meets the hardware requirements specified in Part 1 with Go installed. We are assuming you already have a daemon home (`$HOME/.clan`) setup.

These examples are written targeting an Ubuntu 20.04 system. Relevant changes to commands should be made depending on the OS/architecture you are running on.

### 1. Download Genesis file

[Genesis File](/playstation-2/genesis.json):

```bash
curl -s  https://raw.githubusercontent.com/ClanNetwork/testnets/main/playstation-2/genesis.json > ~/.clan/config/genesis.json
```

### 2. Verify your genesis file was created properly

```sh
sha256sum ~/.clan/config/genesis.json
TBD
```

### 3. Updates to config files

#### 3.1 Add persistent peers in `config.toml`.

```sh
#Set the base repo URL for the testnet & retrieve peers
CHAIN_REPO="https://raw.githubusercontent.com/ClanNetwork/testnets/main/playstation-2" && \
export PEERS="$(curl -s "$CHAIN_REPO/persistent_peers.txt")"

# check it worked
echo $PEERS


sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ~/.clan/config/config.toml
```

#### 3.2 Set 0 gas prices in `app.toml`:

```sh
# note testnet denom
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uclan\"/" ~/.clan/config/app.toml
```

### 4. Start your node

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
ExecStart=/path/to/cland start
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

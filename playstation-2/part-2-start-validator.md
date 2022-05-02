# Clan Network PlayStation-2 Testnet Instructions (2/2): Prepare Node

## Details

**Version**
`v1.0.4-alpha`

**Genesis Time**
13:00 UTC on May 2, 2022

**Genesis File**

```
https://raw.githubusercontent.com/ClanNetwork/testnets/main/playstation-2/genesis.json
```

**Genesis Sha256**

```
f9824537624c79f3ace324f992e9d87bc761304b093a050b6941476e9daafd35
```

**Persistent Peers**

```sh
persistent_peers = "be8f9c8ff85674de396075434862d31230adefa4@35.231.178.87:26656,0cb936b2e3256c8d9d90362f2695688b9d3a1b9e@34.73.151.40:26656,e85dc5ec5b77e86265b5b731d4c555ef2430472a@23.88.43.130:26656"
```

**Seed nodes**

N/A

## Overview

Thank you for submitting a gentx! This guide will provide instructions on getting ready for the testnet.

**The Chain Genesis Time is on 13:00 UTC on May 2, 2022**

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
f9824537624c79f3ace324f992e9d87bc761304b093a050b6941476e9daafd35
```

### 3. Updates to config files

#### 3.1 Add persistent peers in `config.toml`.

```sh
vim $HOME/.clan/config/config.toml
```

```
persistent_peers = "be8f9c8ff85674de396075434862d31230adefa4@35.231.178.87:26656,0cb936b2e3256c8d9d90362f2695688b9d3a1b9e@34.73.151.40:26656,e85dc5ec5b77e86265b5b731d4c555ef2430472a@23.88.43.130:26656"
```

#### 3.2 Set 0 gas prices in `app.toml`:

```sh
vim $HOME/.clan/config/app.toml
```

```sh
minimum-gas-prices = "0uclan"
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

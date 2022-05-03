# Clan Network PlayStation-2 Testnet Instructions (1/2): Submit Gentx

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

## Steps

### 1. Install cland

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

##### Install local package list and toolchain

```sh
# update the local package list and install any available upgrades
sudo apt-get update && sudo apt upgrade -y

# install toolchain
sudo apt install build-essential jq -y
```

##### Install go (1.18+ required):

```sh
# 1. Download the archive

wget https://go.dev/dl/go1.18.linux-amd64.tar.gz

# Optional: remove previous /go files:

sudo rm -rf /usr/local/go

# 2. Unpack:

sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz

# 3. Add the path to the go-binary to your system path:
# (for this to persist, add this line to   your ~/.profile or ~/.bashrc or  ~/.zshrc)

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# After updating your ~/.profile you will need to source it:
source ~/.profile

# 4. Verify your installation:

go version

# go version go1.18 linux/amd64
```

##### Download source code and build

```sh
# Close and checkout to needed version
git clone https://github.com/ClanNetwork/clan-network
cd clan-network
git fetch origin --tags
git checkout v1.0.4-alpha

# Install
make install
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

### 3. Setup validator node

Below are the instructions to generate and submit your genesis transaction.

#### 3.1 Generate genesis transaction (gentx)

1. Initialize the Clan Network directories and create the local genesis file with the correct
   chain-id

   ```sh
   # This step is optional but recommended
   cland config chain-id playstation-2

   # moniker is the name of your node
   cland init <moniker> --chain-id=playstation-2
   ```

2. Create a local key pair

   ```sh
   cland keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you
   just created. Use only `100000000000uclan`, other amounts will be ignored.

   ```sh
   cland add-genesis-account $(cland keys show <key-name> -a) 100000000000uclan
   ```

4. Generate the genesis transaction (gentx) that submits your validator info to the chain.
   The amount here is how much of your own funds you want to delegate to your validator (self-delegate).
   Start with 50% of your total (50000000000uclan). You can always delegate the rest later.

   ```sh
   cland gentx <key-name> 50000000000uclan --chain-id=playstation-2
   ```

   If all goes well, you will see a message similar to the following:

   ```sh
   Genesis transaction written to "/home/user/.clan/config/gentx/gentx-******.json"
   ```

#### 3.2 Submit genesis transaction

Submit your gentx in a PR [here](https://github.com/ClanNetwork/testnets)

- Fork [the testnets repo](https://github.com/ClanNetwork/testnets) into your Github account

- Clone your repo using

  ```sh
  git clone https://github.com/<github-username>/testnets
  ```

- Copy the generated gentx json file to `<repo_path>/playstation-2/gentxs/`

  ```sh
  cd testnets
  cp ~/.clan/config/gentx/gentx*.json ./playstation-2/gentxs/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/ClanNetwork/testnets

✨ Congrats! You have done everything you need to participate in the testnet. Now just hang tight for further instructions on starting your node when the network starts.

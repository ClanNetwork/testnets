# Clan Network PlayStation-1 Testnet Instructions (1/2): Submit Gentx

## Minimum hardware requirements

- 2x CPUs
- 4GB RAM
- 50GB+ of disk space

### Install Clan Network

#### Download binary from github

1. Download the binary for your platform: [releases](https://github.com/ClanNetwork/clan-network/releases/tag/v1.0.0-alpha).
2. Copy it to a location in your PATH, i.e: `/usr/local/bin` or `$HOME/bin`.

```sh
> wget https://github.com/ClanNetwork/clan-network/releases/download/v1.0.0-alpha/clan-network_v1.0.0-alpha_linux_amd64.tar.gz
> sudo tar -C /usr/local/bin -zxvf clan-network_v1.0.0-alpha_linux_amd64.tar.gz
```

#### Verify installation

To verify if the installation was successful, execute the following command:

```sh
cland version --long
```

It will display the version of `cland` currently installed:

```sh
name: Clan-Network
server_name: clan-networkd
version: latest
commit: a7ee4541dbb19e55221bbb575284eeb39c462610
build_tags: ""
go: go version go1.18 linux/amd64
```

## Setup validator node

Below are the instructions to generate and submit your genesis transaction.

### Generate genesis transaction (gentx)

1. Initialize the Clan Network directories and create the local genesis file with the correct
   chain-id

   ```sh
   cland config chain-id playstation-1
   # moniker is the name of your node
   cland init <moniker>
   ```

2. Create a local key pair

   ```sh
   cland keys add <key-name>
   ```

3. Add your account to your local genesis file with a given amount and the key you
   just created. Use only `1000000000000uclan`, other amounts will be ignored.

   ```sh
   cland add-genesis-account $(cland keys show <key-name> -a) 1000000000000uclan
   ```

4. Generate the genesis transaction (gentx) that submits your validator info to the chain.
   The amount here is how much of your own funds you want to delegate to your validator (self-delegate).
   Start with 50% of your total (500000000000uclan). You can always delegate the rest later.

   ```sh
   cland gentx <key-name> 500000000000uclan --chain-id=playstation-1
   ```

   If all goes well, you will see a message similar to the following:

   ```sh
   Genesis transaction written to "/home/user/.clan/config/gentx/gentx-******.json"
   ```

### Submit genesis transaction

Submit your gentx in a PR [here](https://github.com/ClanNetwork/testnets)

- Fork [the testnets repo](https://github.com/ClanNetwork/testnets) into your Github account

- Clone your repo using

  ```sh
  git clone https://github.com/<github-username>/testnets
  ```

- Copy the generated gentx json file to `<repo_path>/playstation-1/gentxs/`

  ```sh
  cd testnets
  cp ~/.clan/config/gentx/gentx*.json ./playstation-1/gentxs/
  ```

- Commit and push to your repo
- Create a PR onto https://github.com/ClanNetwork/testnets

✨ Congrats! You have done everything you need to participate in the testnet. Now just hang tight for further instructions on starting your node when the network starts (28/4/2022 1300 UTC).

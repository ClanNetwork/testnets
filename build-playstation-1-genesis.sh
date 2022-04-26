#!/bin/bash

DENOM=uclan
CHAIN_ID=playstation-1
VALIDATOR_INIT_COINS=100000000000000$DENOM
FAUCET_INIT_COINS=50000000000000$DENOM
ORACLE_INIT_COINS=1000000$DENOM
REQUIRED_VERSION="1.0.1-alpha"
VERSION="$(cland version |  awk '{print $NF}')"
SNAPSHOT_ATOM_STAKERS="snapshot_atom_9681900.json"
SNAPSHOT_TERRA_STAKERS="snapshot_terra_6768200.json"
SNAPSHOT_SCRT_STAKERS="snapshot_scrt_2446200.json"
SNAPSHOT_TANGO_HOLDERS="snapshot_tango_14347922.json"
EXCHANGES_TERRA="exchanges-terra.json"
EXCHANGES_SECRET="exchanges-secret.json"
EXCHANGES_COSMOSHUB="exchanges-cosmoshub.json"
COSMOS_AIRDROP_ALLOCATION=20055000000000
TANGO_AIRDROP_ALLOCATION=53480000000000
EXPORTED_CLAIM_RECORDS="exported-claim-records.json"
EXPORTED_CLAIM_ETH_RECORDS="exported-claim-eth-records.json"
VALIDATOR_ADDRESS="clan10jq29ktde4xpges8ah0z4r48ywqsj7029u9f5c"
ORACLE_ADDRESS="clan147m4eyj8ejcax2k5a96ag5yxan8884p37qnn9z"
FAUCET_ADDRESS="clan1anl88fsxy2pucyxdxme8pmpmw779lvhhn0faks"
GENTX_PATH="playstation-1"
VALIDATORS_GENESIS_ALLOCATION=100000000000

if [ "$VERSION" != "$REQUIRED_VERSION" ]; then
    echo "cland required $REQUIRED_VERSION, current $VERSION"
    exit 1
fi


rm -f ~/.clan/config/genesis.json
rm -f ~/.clan/config/gentx/*

declare -a SNAPSHOTS_LIST=($SNAPSHOT_ATOM_STAKERS $SNAPSHOT_TERRA_STAKERS $SNAPSHOT_SCRT_STAKERS $SNAPSHOT_TANGO_HOLDERS)
declare -a EXCHANGES_LIST=($EXCHANGES_TERRA $EXCHANGES_COSMOSHUB $EXCHANGES_SECRET)

for i in "${EXCHANGES_LIST[@]}"
do
    echo "Downloading $i"
    wget -N snapshots.clan.network/$i
done

for i in "${SNAPSHOTS_LIST[@]}"
do
    echo "Downloading $i holders snapshot..."
    wget -N snapshots.clan.network/$i.gz
    echo "Unzipping $i holders snapshot..."
    gzip -d -k -f $i.gz
done

cland export-snapshot ./$SNAPSHOT_TERRA_STAKERS ./$SNAPSHOT_TERRA_STAKERS-output.json $COSMOS_AIRDROP_ALLOCATION $EXCHANGES_TERRA.json --minStaked=10000000 --whalecap=200000000000  
cland export-snapshot ./$SNAPSHOT_SCRT_STAKERS ./$SNAPSHOT_SCRT_STAKERS-output.json $COSMOS_AIRDROP_ALLOCATION $EXCHANGES_SECRET --minStaked=100000000 --whalecap=200000000000 
cland export-snapshot ./$SNAPSHOT_ATOM_STAKERS ./$SNAPSHOT_ATOM_STAKERS-output.json $COSMOS_AIRDROP_ALLOCATION $EXCHANGES_COSMOSHUB --minStaked=50000000 --whalecap=280000000000  
cland export-tango-snapshot ./$SNAPSHOT_TANGO_HOLDERS ./$SNAPSHOT_TANGO_HOLDERS-output.json $TANGO_AIRDROP_ALLOCATION --minTango=1000

cland snapshot-to-claim-records ./$SNAPSHOT_TERRA_STAKERS-output.json ./$SNAPSHOT_SCRT_STAKERS-output.json ./$SNAPSHOT_ATOM_STAKERS-output.json --outputFile=./$EXPORTED_CLAIM_RECORDS 
cland snapshot-to-claim-eth-records ./$SNAPSHOT_TANGO_HOLDERS-output.json --outputFile=./$EXPORTED_CLAIM_ETH_RECORDS
cland prepare-genesis testnet $CHAIN_ID $EXPORTED_CLAIM_RECORDS $EXPORTED_CLAIM_ETH_RECORDS

cland init testmoniker --chain-id $CHAIN_ID

cland config chain-id $CHAIN_ID
cland config keyring-backend test
cland config output json

cland add-genesis-account $VALIDATOR_ADDRESS $VALIDATOR_INIT_COINS
cland add-genesis-account $ORACLE_ADDRESS $ORACLE_INIT_COINS
cland add-genesis-account $FAUCET_ADDRESS $FAUCET_INIT_COINS

echo "Processing gentxs"
mkdir -p ~/.clan/config/gentx
for i in $GENTX_PATH/gentx/*.json; do
    echo $i
    cland add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $VALIDATORS_GENESIS_ALLOCATION 
    cp $i ~/.clan/config/gentx/
done

cland keys add my-validator --keyring-backend test --recover
cland gentx my-validator 95000000000000uclan --chain-id $CHAIN_ID --keyring-backend test

cland collect-gentxs
cland validate-genesis

cp ~/.clan/config/genesis.json $GENTX_PATH/pre-built.json
jq -S -f normalize.jq  ~/.clan/config/genesis.json > $GENTX_PATH/genesis.json
cp $GENTX_PATH/genesis.json ~/.clan/config/genesis.json
sha256sum $GENTX_PATH/genesis.json
sha256sum ~/.clan/config/genesis.json

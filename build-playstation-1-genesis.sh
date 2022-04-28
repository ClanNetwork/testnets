#!/bin/bash

DENOM=uclan
CHAIN_ID=playstation-1
PEER_VALIDATOR_GENESIS_ALLOCATION=10000000000000$DENOM
VALIDATORS_GENESIS_ALLOCATION=1000000000000$DENOM
FAUCET_INIT_COINS=50000000000000$DENOM
ORACLE_INIT_COINS=1000000$DENOM
GENTX_PATH="playstation-1"
REQUIRED_VERSION="1.0.4-alpha"
VERSION="$(cland version |  awk '{print $NF}')"
SNAPSHOT_ATOM_STAKERS="snapshot_atom_9681900"
SNAPSHOT_TERRA_STAKERS="snapshot_terra_6768200"
SNAPSHOT_SCRT_STAKERS="snapshot_scrt_2446200"
SNAPSHOT_TANGO_HOLDERS="snapshot_tango_14347922"
EXCHANGES_TERRA="exchanges-terra.json"
EXCHANGES_SECRET="exchanges-secret.json"
EXCHANGES_COSMOSHUB="exchanges-cosmoshub.json"
COSMOS_AIRDROP_ALLOCATION=20055000000000
TANGO_AIRDROP_ALLOCATION=53480000000000
EXPORTED_CLAIM_RECORDS="exported-claim-records.json"
EXPORTED_CLAIM_ETH_RECORDS="exported-claim-eth-records.json"
ORACLE_ADDRESS="clan147m4eyj8ejcax2k5a96ag5yxan8884p37qnn9z"
FAUCET_ADDRESS="clan1anl88fsxy2pucyxdxme8pmpmw779lvhhn0faks"
DAO_ADDRESS="clan10q4cddypjcq5lr4j3dznt0e5krghrpcjzn94xz"
CORE_DEV_ADDRESS="clan1cyk5jz84kmrqle6p0px0fdzu57jfyy5x4p697r"
GOVERNANCE_AIRDROP_ADDRESS="clan105qpg0kmdv2sclprev8fr3a6gvcthekdxrvy8q"

if [ "$VERSION" != "$REQUIRED_VERSION" ]; then
    echo "cland required $REQUIRED_VERSION, current $VERSION"
    exit 1
fi

rm -f ~/.clan/config/genesis.json
rm -f ~/.clan/config/gentx/*

# declare -a SNAPSHOTS_LIST=($SNAPSHOT_ATOM_STAKERS $SNAPSHOT_TERRA_STAKERS $SNAPSHOT_SCRT_STAKERS $SNAPSHOT_TANGO_HOLDERS)
# declare -a EXCHANGES_LIST=($EXCHANGES_TERRA $EXCHANGES_COSMOSHUB $EXCHANGES_SECRET)

# for i in "${EXCHANGES_LIST[@]}"
# do
#     echo "Downloading $i"
#     wget -N snapshots.clan.network/$i
# done

# for i in "${SNAPSHOTS_LIST[@]}"
# do
#     echo "Downloading $i holders snapshot..."
#     wget -N snapshots.clan.network/$i.json.gz
#     echo "Unzipping $i holders snapshot..."
#     gzip -d -f $i.json.gz
# done

# cland export-snapshot ./$SNAPSHOT_TERRA_STAKERS.json ./$SNAPSHOT_TERRA_STAKERS-output.json $COSMOS_AIRDROP_ALLOCATION $EXCHANGES_TERRA --minStaked=10000000 --whalecap=200000000000  
# cland export-snapshot ./$SNAPSHOT_SCRT_STAKERS.json ./$SNAPSHOT_SCRT_STAKERS-output.json $COSMOS_AIRDROP_ALLOCATION $EXCHANGES_SECRET --minStaked=100000000 --whalecap=200000000000 
# cland export-snapshot ./$SNAPSHOT_ATOM_STAKERS.json ./$SNAPSHOT_ATOM_STAKERS-output.json $COSMOS_AIRDROP_ALLOCATION $EXCHANGES_COSMOSHUB --minStaked=50000000 --whalecap=280000000000  
# cland export-tango-snapshot ./$SNAPSHOT_TANGO_HOLDERS.json ./$SNAPSHOT_TANGO_HOLDERS-output.json $TANGO_AIRDROP_ALLOCATION --minTango=1000

cland snapshot-to-claim-records ./$SNAPSHOT_TERRA_STAKERS-output.json ./$SNAPSHOT_SCRT_STAKERS-output.json ./$SNAPSHOT_ATOM_STAKERS-output.json --outputFile=./$EXPORTED_CLAIM_RECORDS 
cland snapshot-to-claim-eth-records ./$SNAPSHOT_TANGO_HOLDERS-output.json --outputFile=./$EXPORTED_CLAIM_ETH_RECORDS

cland init testmoniker --chain-id $CHAIN_ID
cland prepare-genesis testnet $CHAIN_ID ./$EXPORTED_CLAIM_ETH_RECORDS ./$EXPORTED_CLAIM_RECORDS --daoAddr=$DAO_ADDRESS --coreDevAddr=$CORE_DEV_ADDRESS

cland add-genesis-account $ORACLE_ADDRESS $ORACLE_INIT_COINS
cland add-genesis-account $FAUCET_ADDRESS $FAUCET_INIT_COINS
cland add-genesis-account $GOVERNANCE_AIRDROP_ADDRESS $COSMOS_AIRDROP_ALLOCATION$DENOM

echo "Processing gentxs"
mkdir -p ~/.clan/config/gentx
for i in $GENTX_PATH/gentxs/*.json; do
    echo $i
    cland add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $VALIDATORS_GENESIS_ALLOCATION 
    cp $i ~/.clan/config/gentx/
done

echo "Processing peer gentxs"
mkdir -p ~/.clan/config/gentx
for i in $GENTX_PATH/peer-gentxs/*.json; do
    echo $i
    cland add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) $PEER_VALIDATOR_GENESIS_ALLOCATION 
    cp $i ~/.clan/config/gentx/
done

cland collect-gentxs
cland validate-genesis

jq -S -f normalize.jq  ~/.clan/config/genesis.json > $GENTX_PATH/generated-genesis.json
cp $GENTX_PATH/generated-genesis.json ~/.clan/config/genesis.json
shasum -a 256 $GENTX_PATH/genesis.json
shasum -a 256 ~/.clan/config/genesis.json

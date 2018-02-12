#!/bin/bash

#Bring down all first
./down.sh

#Make sure no space betwee "=" for variables
channelDir="channel-artifacts"
channelName="fteChannel"
genesisProfile="FreeTradeEnterpriseOrdererGenesis"
channelProfile="FreeTradeEnterpriseOrgsChannel"

#Create channel-artifacts folder is no existing
if [ ! -d $channelDir ]
then
	#echo "directory not found!"
	mkdir -p $channelDir
fi 

#Generate organization certificates by using cryptogen tool
cryptogen generate --config=./crypto-config.yaml

#Tell configtxgen tool where to look for configtx.yaml file 
export FABRIC_CFG_PATH=$PWD
#Generate genesis block from configtx.yaml by configtxgen tool
configtxgen -profile $genesisProfile -outputBlock ./channel-artifacts/genesis.block

#Creating the channel transaction artifact
configtxgen -profile $channelProfile -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $channelName

#Generate anchor peer update for TradeCompany
configtxgen -profile $channelProfile -outputAnchorPeersUpdate ./channel-artifacts/TradeCompanyMSPanchors.tx -channelID $channelName -asOrg TradeCompanyMSP

#Generate anchor peer update for Bank
configtxgen -profile $channelProfile -outputAnchorPeersUpdate ./channel-artifacts/BankMSPanchors.tx -channelID $channelName -asOrg BankMSP

#Generate anchor peer update for ShippingCompany
configtxgen -profile $channelProfile -outputAnchorPeersUpdate ./channel-artifacts/ShippingCompanyMSPanchors.tx -channelID $channelName -asOrg ShippingCompanyMSP

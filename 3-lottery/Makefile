# To include all env variables
-include .env

# List of all make commands
.PHONY: deploy-anvil deploy-sepolia

# use the "@" to hide the command from your shell
deploy-sepolia :; @forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url ${SEPOLIA_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY}  -vvvv

# This is the private key of account from the mnemonic from the "anvil" command
deploy-anvil :; @forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv

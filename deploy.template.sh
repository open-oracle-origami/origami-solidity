# For more information on forge scripting, see: https://book.getfoundry.sh/tutorials/solidity-scripting
# Forge script reference, see: https://book.getfoundry.sh/reference/forge/forge-script

forge script script/DeployScriptV1.s.sol:DeployScriptV1 -vvvv --broadcast --slow --rpc-url $RPC_URL --chain-id $CHAIN_ID --private-key $PRIVATE_KEY

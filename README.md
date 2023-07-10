# Open Oracle Origami Solidity

The following repository maintains the EVM compatible Solidity contracts for the Open Oracle Origami project.
They are free to use and deploy, but are currently not audited and should be used at your own risk.
We are looking for auditors to help us audit the contracts and ensure they are secure and perform as intended. Please reach out if you can help and have the time to donate to an open source project.

The Open Oracle Origami Foundation will maintain a deployment of these contracts on several EVM compatible networks and provide a public interface for the community to interact with the contracts allowing for an open marketplace of Origami (Oracle Data). 

It is recommended that you understand the Open Oracle Origami project before using these contracts. Please refer to the [litepaper](https://docs.google.com/document/d/1CItxoVQetPqNPQGl4WVXbSmwyRgzFTy1660T-WBltH4).

## Contract Summary
1. `ShibuyaImplV1.sol`:
    - The contract initializes and extends the `UUPSUpgradeable` and `OwnableUpgradeable` contracts.
    - It maintains a mapping of museums and their counts.
    - The `createMuseum` function creates a new museum using a beacon proxy pattern and adds it to the `museums` mapping.
    - The `_authorizeUpgrade` function is overridden to only allow the owner to perform contract upgrades.

2. `MuseumImplV1.sol`:
    - The contract initializes and extends the `OwnableUpgradeable` contract.
    - It maintains various state variables such as `name`, `valuePerBlockFee`, `collectionCount`, and `subscriptionCount`.
    - It has structs for `Subscription` and `Visitor`.
    - The contract allows the owner to create collections, attach collections, detach collections, subscribe, extend subscriptions, withdraw funds, grant visitation, and update contract parameters.
    - The `hasVisitor` function checks if a visitor has a valid subscription and can access the museum.

3. `CollectionImplV1.sol`:
    - The contract initializes and extends the `OwnableUpgradeable` contract.
    - It uses the `EnumerableSetUpgradeable` library to manage a set of museum addresses.
    - The contract maintains state variables for `name`, `decimals`, `version`, and `counter`.
    - It allows the owner to curate origami items, attach/detach museums, and update contract parameters.
    - The `onlyVisitor` modifier checks if the sender has visitor rights at any of the attached museums.
    - The contract also includes functions to retrieve museum information and supports the ChainLink Aggregator interface.

## Recommended Usage & Flows

## Deployment

## Foundation Deployments


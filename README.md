# Open Oracle Origami Solidity
The following repository contains the EVM compatible Solidity contracts for Open Oracle Origami.
They are free to use and deploy, but are currently not audited and should be used at your own risk.
We are looking for auditors to help ensure they are secure and perform as intended. 

Please reach out if you are an auditor and willing to donate some time.

The Open Oracle Origami Foundation will maintain a deployment of these contracts on several EVM compatible networks and provide a public user interface for the community to interact with including an open marketplace for Origami Museums. 

It is recommended that you understand concepts of Open Oracle Origami before using these contracts. Please refer to the [litepaper](https://docs.google.com/document/d/1CItxoVQetPqNPQGl4WVXbSmwyRgzFTy1660T-WBltH4) for more details.

## Overview
Open Oracle Origami is a versatile open oracle project that facilitates the rapid launch of blockchain oracles through our user-friendly SDKs. Our smart contracts empower the creation of Origami Museums and Origami Collections, serving as data repositories and retrieval mechanisms for Origami Data.

As an Origami Curator, you have the flexibility to monetize your data by charging a subscription fee for access or offer your museums as public goods for free visitation. This ecosystem allows curators to participate in an open marketplace to profit from their data, while visitors can easily access curated data for their DApp development needs.

## Contract Summary

### ShibuyaImplV1
- Manages the creation and upgrade of museums on the blockchain.
- Utilizes OpenZeppelin libraries (UUPSUpgradeable and OwnableUpgradeable) for upgradability and access control.
- Allows users (curators) to create new museums with specified parameters like `name` and `valuePerBlockFee`.
- Tracks the total count of museums created and their associated addresses.
- Provides functions to update the museum and collection beacons by owner.
- Enables contract owner to authorize upgrades.
- Implements `initialize`, `createMuseum`, `updateMuseumBeacon`, `updateCollectionBeacon`, related events and more.

### MuseumImplV1
- Represents a museum within the Origami ecosystem.
- Implements the IVisitable interface for visitor management.
- Allows museum owner (curator) to create and manage collections associated with the museum.
- Visitors can subscribe to the museum and extend their subscriptions with a fee.
- Provides functions to attach and detach collections to a museum.
- Implements `initialize`, `createCollection`, `attachCollection`, `detachCollection`, related events and more.

### CollectionImplV1
- Represents a collection within a museum.
- Allows curator to curate origami in the collection.
- Manages a list of associated museums.
- Provides functions to attach and detach museums from the collection.
- Implements `initialize`, `curate`, `attachMuseum`, `detachMuseum`, related events and more.
- Backwards compatible with ChainLink Aggregator Interface (view functions for obtaining origami data).

## Development Setup
This repository uses [Foundry](https://book.getfoundry.sh/) and assumes that you have it installed. 

If you are new to [Foundry](https://book.getfoundry.sh/), follow their getting started guide. Otherwise, perform the following actions to quickly get up and running.

```bash
cp foundry.template.toml foundry.toml
cp deploy.template.sh deploy.sh

forge install
forge test
```

## Deployment
To deploy the contracts to a network other than localhost, edit the `deploy.sh` accordingly and run `sh deploy.sh`.

On completion the `deploy.sh` script will print the addresses required to interact with the contracts. 

You'll find the ABIs in the `broadcast/` directory, or check the `abi/` directory for a quick more human-readable version.

## Contract Functions and Events
Coming soon...

## Recommended Usage & Flows
### As a Visitor
Coming soon...
### As a Curator
Coming soon...
### Attaching a Collection to a second Museum
Coming soon...
### As owner of the deployment
Coming soon...

## Contract Upgrades
All contracts are written using the latest [OpenZeppelin Upgradeable Contracts](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable).
The `ShibuyaImplV1.sol` contract uses an ERC1967Proxy pattern to allow for upgrades without the need to migrate data.
The `MuseumImplV1.sol` and `CollectionImplV1.sol` contracts use a BeaconProxy pattern to allow for upgrades without the need to migrate data across all museums and collections.
Upgrades are performed solely by the owner of the contracts. To better understand how this works, review the tests or the `script/DeployScriptV1.s.sol`

## Foundation Deployments
### Tenet Testnet
Tenet Testnet details found [here](https://docs.tenet.org/testnet/tenet-testnet).

- Collection Implementation: `0x573051620885dd85E24808911E41cc3FB1f58ab9`
- Collection Beacon: `0xFDA5261B95249Ad791A04a93e1C2b0521f386C9c`
- Museum Implementation: `0x9b2D6204F6DC6623b53F08Ba813Ec50b57C5bCeb`
- Museum Beacon: `0x1b430e574395B8204d7E84c064C29B14B0B5E52c`
- Shibuya Implementation: `0xceb3abE1434067C53B371B14B96801d0b8D0e7B7`
- Shibuya Proxy: `0x5D2BD667720f3156981780c2e1378f68F6DE3286`

## Disclaimer
These smart contracts are provided as-is, without any warranties or guarantees. Use them at your own risk. The developers and maintainers of these smart contracts shall not be held responsible for any issues or losses arising from their use.

## Contributing
Contributions are always welcome! Our source code is licensed under the MIT License, and contributions are welcome.

See [contributing](./CONTRIBUTING.md) for ways to get started.

Please adhere to our [code of conduct](./CODE_OF_CONDUCT.md).

## License
[MIT](https://choosealicense.com/licenses/mit/)

---

*折 お り 紙 がみ (origami), from 折 お り (ori, “to fold”) + 紙 かみ (kami, “paper“)*

# origami-solidity
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

## Contract Deep Dive

### ShibuyaImplV1

#### State Variables

- `uint256 public museumCount`: The total count of museums created.
- `address public museumBeacon`: The address of the beacon contract used for creating new museums.
- `address public collectionBeacon`: The address of the beacon contract used for creating new collections within museums.
- `mapping(uint256 => address) public museums`: A mapping to store the addresses of museums created, indexed by their count.

#### Events

- `event Museum(address indexed _museum)`: Emitted when a new museum is created.
- `event UpdateMuseumBeacon(address indexed _museumBeacon)`: Emitted when the museum beacon address is updated.
- `event UpdateCollectionBeacon(address indexed _collectionBeacon)`: Emitted when the collection beacon address is updated.

#### Functions

##### `initialize(address _museumBeacon, address _collectionBeacon)`

- **Description**: Initializes the contract and sets the initial values for the museumBeacon and collectionBeacon.
- **Parameters**:
    - `_museumBeacon`: The address of the beacon contract used for creating new museums.
    - `_collectionBeacon`: The address of the beacon contract used for creating new collections within museums.
- **Visibility**: Public (initializer).
- **Modifiers**: `initializer`

##### `createMuseum(string memory _name, uint256 _valuePerBlockFee)`

- **Description**: Creates a new museum with the specified parameters and initializes it using the museumBeacon.
- **Parameters**:
    - `_name`: The name of the museum.
    - `_valuePerBlockFee`: The fee in wei per block to be charged for subscriptions to the museum.
- **Returns**: `address`: The address of the newly created museum.
- **Visibility**: Public.
- **Modifiers**: None.

##### `updateMuseumBeacon(address _museumBeacon)`

- **Description**: Updates the museumBeacon address to a new value.
- **Parameters**:
    - `_museumBeacon`: The new address of the museum beacon contract.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `updateCollectionBeacon(address _collectionBeacon)`

- **Description**: Updates the collectionBeacon address to a new value.
- **Parameters**:
    - `_collectionBeacon`: The new address of the collection beacon contract.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `_authorizeUpgrade(address)`

- **Description**: Internal function required by UUPSUpgradeable library to authorize upgrades.
- **Parameters**:
    - `_`: Unused address parameter required by the UUPSUpgradeable library.
- **Visibility**: Internal.
- **Modifiers**: `onlyOwner`.

### MuseumImplV1

#### State Variables

- `string public name`: The name of the museum.
- `uint256 public valuePerBlockFee`: The fee in wei per block to be charged for subscriptions to the museum.
- `uint256 public collectionCount`: The total count of collections associated with the museum.
- `uint256 public subscriptionCount`: The total count of subscriptions to the museum.
- `address public collectionBeacon`: The address of the beacon contract used for creating new collections within the museum.
- `mapping(uint256 => address) public collections`: A mapping to store the addresses of collections associated with the museum, indexed by their count.
- `mapping(uint256 => Subscription) private _subscriptions`: A mapping to store information about subscriptions to the museum, indexed by their count.
- `mapping(address => Visitor) private _visitors`: A mapping to store information about visitors, indexed by their addresses.

#### Structs

- `struct Subscription`: Represents a subscription to the museum, containing the subscriber's address and the block number until which the subscription is valid.
- `struct Visitor`: Represents a visitor to the museum, containing the subscription ID and the timestamp of the visitor's last visit.

#### Events

- `event Collection(address indexed _collection)`: Emitted when a new collection is created within the museum.
- `event AttachCollection(uint256 indexed _index, address indexed _collection)`: Emitted when a collection is attached to the museum.
- `event DetachCollection(uint256 indexed _index)`: Emitted when a collection is detached from the museum.
- `event Subscribe(address indexed _subscriber, uint256 indexed _subscription, uint256 indexed _block)`: Emitted when a visitor subscribes to the museum.
- `event Extend(uint256 indexed _subscription, uint256 indexed _block, address indexed _by)`: Emitted when a visitor extends their subscription.
- `event Withdraw(address indexed _to, uint256 indexed _amount)`: Emitted when the museum curator withdraws funds from the contract.
- `event Grant(address indexed _visitor, uint256 indexed _subscription)`: Emitted when the museum curator grants visitation rights to a visitor.
- `event UpdateName(string _name)`: Emitted when the museum name is updated.
- `event UpdateValuePerBlockFee(uint256 _valuePerBlockFee)`: Emitted when the valuePerBlockFee is updated.
- `event UpdateCollectionBeacon(address indexed _collectionBeacon)`: Emitted when the collection beacon address is updated.

#### Functions

##### `initialize(address _collectionBeacon, address _curator, string memory _name, uint256 _valuePerBlockFee)`

- **Description**: Initializes the contract and sets the initial values for the collectionBeacon, curator, name, and valuePerBlockFee.
- **Parameters**:
    - `_collectionBeacon`: The address of the beacon contract used for creating new collections within the museum.
    - `_curator`: The address of the museum curator (owner).
    - `_name`: The name of the museum.
    - `_valuePerBlockFee`: The fee in wei per block to be charged for subscriptions to the museum.
- **Visibility**: Public (initializer).
- **Modifiers**: None.

##### `createCollection(string memory _name, uint8 _decimals, uint256 _version)`

- **Description**: Creates a new collection within the museum with the specified parameters and initializes it using the collectionBeacon.
- **Parameters**:
    - `_name`: The name of the collection.
    - `_decimals`: The number of decimals for origami items within the collection (used when the origami is integer-based).
    - `_version`: The version of the collection.
- **Returns**: `address`: The address of the newly created collection.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `attachCollection(address _collection)`

- **Description**: Attaches an existing collection contract to the museum.
- **Parameters**:
    - `_collection`: The address of the collection contract to be attached.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `detachCollection(uint256 _index)`

- **Description**: Detaches an existing collection from the museum.
- **Parameters**:
    - `_index`: The index of the collection to be detached.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `subscribe()`

- **Description**: Allows a visitor to subscribe to the museum by paying the required valuePerBlockFee for a certain number of blocks.
- **Parameters**: None.
- **Visibility**: Public.
- **Modifiers**: None.

##### `extend(uint256 _index)`

- **Description**: Allows a visitor to extend their existing subscription to the museum by paying additional valuePerBlockFee for a certain number of blocks.
- **Parameters**:
    - `_index`: The index of the subscription to be extended.
- **Visibility**: Public.
- **Modifiers**: None.

##### `withdraw(address _to, uint256 _amount)`

- **Description**: Allows the museum curator to withdraw funds from the contract.
- **Parameters**:
    - `_to`: The address to which the funds will be transferred.
    - `_amount`: The amount of funds to be withdrawn

### CollectionImplV1

#### State Variables

- `using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet`: The using directive to enable the usage of EnumerableSetUpgradeable for managing museums associated with the collection.
- `string public name`: The name of the collection.
- `uint8 public decimals`: The number of decimals for origami items within the collection (used when the origami is integer-based).
- `uint256 public version`: The version of the collection.
- `uint256 public counter`: The total count of origami items curated in the collection.
- `EnumerableSetUpgradeable.AddressSet private _museums`: A set to store the addresses of museums associated with the collection.

#### Events

- `event Origami(int256 indexed _data)`: Emitted when a new origami item is curated in the collection.
- `event AttachMuseum(address indexed _museum)`: Emitted when a museum is attached to the collection.
- `event DetachMuseum(address indexed _museum)`: Emitted when a museum is detached from the collection.
- `event UpdateName(string _name)`: Emitted when the collection name is updated.
- `event UpdateDecimals(uint8 _decimals)`: Emitted when the number of decimals is updated.
- `event UpdateVersion(uint256 _version)`: Emitted when the collection version is updated.

#### Functions

##### `initialize(address _museum, address _curator, string memory _name, uint8 _decimals, uint256 _version)`

- **Description**: Initializes the contract and sets the initial values for the museum, curator, name, decimals, and version.
- **Parameters**:
    - `_museum`: The address of the museum associated with the collection.
    - `_curator`: The address of the collection curator (owner).
    - `_name`: The name of the collection.
    - `_decimals`: The number of decimals for origami items within the collection (used when the origami is integer-based).
    - `_version`: The version of the collection.
- **Visibility**: Public (initializer).
- **Modifiers**: None.

##### `curate(int256 _data)`

- **Description**: Allows the curator to curate a new origami item in the collection.
- **Parameters**:
    - `_data`: The data representing the origami item.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `museums(uint256 _index)`

- **Description**: Returns the address of the museum associated with the collection at the specified index.
- **Parameters**:
    - `_index`: The index of the museum in the list of associated museums.
- **Returns**: `address`: The address of the museum.
- **Visibility**: Public.
- **Modifiers**: None.

##### `attachMuseum(address _museum)`

- **Description**: Attaches an existing museum contract to the collection.
- **Parameters**:
    - `_museum`: The address of the museum contract to be attached.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `detachMuseum(address _museum)`

- **Description**: Detaches an existing museum from the collection.
- **Parameters**:
    - `_museum`: The address of the museum contract to be detached.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `museumCount()`

- **Description**: Returns the total count of museums associated with the collection.
- **Returns**: `uint256`: The total count of associated museums.
- **Visibility**: Public.
- **Modifiers**: None.

##### `updateName(string memory _name)`

- **Description**: Allows the curator to update the name of the collection.
- **Parameters**:
    - `_name`: The new name of the collection.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `updateDecimals(uint8 _decimals)`

- **Description**: Allows the curator to update the number of decimals for origami items within the collection.
- **Parameters**:
    - `_decimals`: The new number of decimals.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

##### `updateVersion(uint256 _version)`

- **Description**: Allows the curator to update the version of the collection.
- **Parameters**:
    - `_version`: The new version of the collection.
- **Visibility**: Public.
- **Modifiers**: `onlyOwner`.

## Usage & Flows

### As a Curator

#### Creating a Museum
To create a new museum:

1. Find the `ShibuyaImplV1` contract address or deploy a new `ShibuyaImplV1` contract, passing the addresses of the beacon contracts for museum and collection implementations.
2. Call the `createMuseum(string memory _name, uint256 _valuePerBlockFee)` function to create a new museum with your desired name and subscription fee charged in wei value per block.
3. The `createMuseum` function will deploy a new museum contract using the `BeaconProxy` and make you the owner.

#### Creating a Collection
As a curator, you can create collections within museums you manage:

1. Call the `createCollection(string memory _name, uint8 _decimals, uint256 _version)` function of the `MuseumImplV1` contract.
2. The `createCollection` function will deploy a new collection contract associated with the museum and make you the owner.

#### Curating Origami
Curators can curate origami within collections they own:

1. Use the `curate(int256 _data)` function of the `CollectionImplV1` contract to add origami to the collection.
2. The `curate` function adds the origami to the collection's state, timestamping the curating event.

### Attaching a Collection to Multiple Museums
Curators can attach a collection to multiple museums:

1. Use the `attachCollection(address _collection)` function of the `MuseumImplV1` contract to attach an existing collection to the museum.
2. Use the `attachMuseum(address _museum)` function of the `CollectionImplV1` contract to attach an existing museum to the collection.
3. Now a relationship between the museum and the collection has been established, allowing the museum to access the collection's data.

> Note: It's possible to attach a collection that you do not manage assuming the collection curator has made the attachment call from the controlling account. For performance reasons, no more than 10 museums can be attached to any given collection.

### Balance and Withdrawals
Curators can manage the contract balance and withdrawals:

1. Call the `withdraw(address _to, uint256 _amount)` function of the `MuseumImplV1` contract to withdraw funds from the contract balance.
2. Only the contract owner (curator) can withdraw funds, and the `_amount` must not exceed the contract's balance.

### As a Subscriber

#### Subscribing to a Museum
To access a museum's origami data as a subscriber:

1. Ensure you have the required amount of native tokens to cover the subscription fee.
2. Call the `subscribe()` function of the desired museum contract you wish to subscribe to.
3. Optionally, use the `extend(uint256 _index)` function to extend your subscription by paying additional native tokens.
4. Your subscription is valid for a specific number of blocks based on the amount of native tokens paid and the `valuePerBlockFee`.
5. Access the museum's data and services as long as your subscription is valid.
6. Renew your subscription at any time by calling `extend(uint256 _index)`.

> Note: The `value` of native tokens sent in the call must be equal to multiples of the `valuePerBlockFee` for the subscription to be valid.

#### Extending a Subscription
Subscribers can extend their subscriptions:

1. Call the `extend(uint256 _index)` function of the museum contract.
2. The `extend` function allows subscribers to pay additional native tokens to extend their subscription for a certain number of additional blocks.

> Note: Calling `extend` after the subscription has already expired will simply re-engage the subscription from the current block.

#### Granting Visitor Access to a Subscription
As a subscription holder, you can grant access to other contracts or addresses to use your subscription:

1. Deploy the contract that requires access to the museum data.
2. Call the `grant(address _visitor)` function of the museum contract to grant access to the visitors address.
3. Grant access to multiple contracts or addresses by calling `grant()` with different `_visitor` addresses.

### As A Visitor

#### Viewing Origami
As the museum owner, subscription holder or visitor with access granted to a subscription:

1. Call the `visit()` function of the `CollectionImplV1` contract to view the latest origami in the collection.
2. Use the `visit(uint256 _index)` function to view origami at specific indices in the collection.

## Contract Upgrades
All contracts are written using the latest [OpenZeppelin Upgradeable Contracts](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable).
The `ShibuyaImplV1.sol` contract uses an ERC1967Proxy pattern to allow for upgrades without the need to migrate data.
The `MuseumImplV1.sol` and `CollectionImplV1.sol` contracts use a BeaconProxy pattern to allow for upgrades without the need to migrate data across all museums and collections.
Upgrades are performed solely by the owner of the contracts. To better understand how this works, review the tests or the `script/DeployScriptV1.s.sol`

## Foundation Deployments
Deployments managed by the Open Oracle Origami Foundation are listed below.

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

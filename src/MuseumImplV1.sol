// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/proxy/beacon/BeaconProxy.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./IVisitable.sol";


contract MuseumImplV1 is Initializable, OwnableUpgradeable, IVisitable {
    string public name;
    uint256 public valuePerBlockFee;
    uint256 public collectionCount;
    uint256 public subscriptionCount;
    address public collectionBeacon;

    struct Subscription {
        address subscriber;
        uint256 block;
    }

    struct Visitor {
        uint256 subscription;
        uint256 timestamp;
    }

    mapping(uint256 => address) public collections;
    mapping(uint256 => Subscription) private _subscriptions;
    mapping(address => Visitor) private _visitors;
    // The above Subscription/Visitor structure does not account for multiple subscriptions to be attached to a visitor but we probably don't care.

    event Collection(address indexed _collection);
    event AttachCollection(uint256 indexed _index, address indexed _collection);
    event DetachCollection(uint256 indexed _index);
    event Subscribe(address indexed _subscriber, uint256 indexed _subscription, uint256 indexed _block);
    event Extend(uint256 indexed _subscription, uint256 indexed _block, address indexed _by);
    event Withdraw(address indexed _to, uint256 indexed _amount);
    event Grant(address indexed _visitor, uint256 indexed _subscription);
    event UpdateName(string _name);
    event UpdateValuePerBlockFee(uint256 _valuePerBlockFee);
    event UpdateCollectionBeacon(address indexed _collectionBeacon);

    function initialize(address _collectionBeacon, address _curator, string memory _name, uint256 _valuePerBlockFee) initializer public {
        require(_collectionBeacon != address(0), "Invalid collection beacon address");
        require(_curator != address(0), "Invalid curator address");
        __Ownable_init();
        collectionBeacon = _collectionBeacon;
        _transferOwnership(_curator);
        name = _name;
        valuePerBlockFee = _valuePerBlockFee;

        // Start at 1 because 0 is reserved for non-subscribers
        subscriptionCount = 1;
    }

    function createCollection(string memory _name, uint8 _decimals, uint256 _version) public onlyOwner returns (address) {
        address _collection = address(new BeaconProxy(collectionBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint8,uint256)",
            address(this),
            owner(),
            _name,
            _decimals,
            _version
        )));
        emit Collection(_collection);
        _attachCollection(_collection);

        return _collection;
    }

    function attachCollection(address _collection) public onlyOwner {
        _attachCollection(_collection);
    }

    function _attachCollection(address _collection) internal {
        require(_collection != address(0), "Invalid collection address");
        collections[collectionCount] = _collection;
        collectionCount += 1;
        emit AttachCollection(collectionCount - 1, _collection);
    }

    function detachCollection(uint256 _index) public onlyOwner {
        require(collections[_index] != address(0), "Invalid collection address");
        delete collections[_index];
        emit DetachCollection(_index);
    }

    function subscribe() public payable {
        require(msg.value >= valuePerBlockFee, "Insufficient fee");
        require(msg.value % valuePerBlockFee == 0, "Invalid fee");
        require(_visitors[msg.sender].timestamp == 0 || _subscriptions[_subscription(msg.sender)].subscriber != msg.sender, "Already subscribed");

        uint256 _blocks = msg.value / valuePerBlockFee;
        _subscriptions[subscriptionCount] = Subscription(msg.sender, block.number + _blocks);
        _visitors[msg.sender] = Visitor(subscriptionCount, block.timestamp);
        subscriptionCount += 1;

        emit Subscribe(msg.sender, subscriptionCount - 1, _subscriptions[subscriptionCount - 1].block);
        emit Grant(msg.sender, subscriptionCount - 1);
    }

    function extend(uint256 _index) public payable {
        require(msg.value >= valuePerBlockFee, "Insufficient fee");
        require(msg.value % valuePerBlockFee == 0, "Invalid fee");
        require(_subscriptions[_index].subscriber != address(0), "Invalid subscription");

        uint256 _blocks = msg.value / valuePerBlockFee;

        if (_subscriptions[_index].block < block.number) {
            _subscriptions[_index].block = block.number + _blocks;
        } else {
            _subscriptions[_index].block += _blocks;
        }

        emit Extend(_index, _subscriptions[_index].block, msg.sender);
    }

    function withdraw(address _to, uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(_to).transfer(_amount);
        emit Withdraw(_to, _amount);
    }

    function grant(address _visitor) public {
        require(_subscriptions[_subscription(msg.sender)].subscriber == msg.sender, "Only subscription owner can grant visitation");
        _visitors[_visitor] = Visitor(_subscription(msg.sender), block.timestamp);
        emit Grant(_visitor, _subscription(msg.sender));
    }

    function subscriptions(uint256 _index) public view returns (address subscriber, uint256 block) {
        return (_subscriptions[_index].subscriber, _subscriptions[_index].block);
    }

    function visitors(address _visitor) public view returns (uint256 subscription, uint256 timestamp) {
        return (_visitors[_visitor].subscription, _visitors[_visitor].timestamp);
    }

    function subscription(address _subscriber) public view returns (uint256) {
        return _subscription(_subscriber);
    }

    function _subscription(address _subscriber) internal view returns (uint256) {
        return _visitors[_subscriber].subscription;
    }

    function hasVisitor(address _visitor) public view override returns (bool) {
        if (valuePerBlockFee == 0) {
            return true;
        } else if (_visitor == owner()) {
            return true;
        }

        Visitor memory _visitorItem = _visitors[_visitor];
        if (_visitorItem.timestamp > 0 && _subscriptions[_visitorItem.subscription].block >= block.number) {
            return true;
        }
        return false;
    }

    function curator() public view returns (address) {
        return owner();
    }

    function updateName(string memory _name) public onlyOwner {
        name = _name;
        emit UpdateName(_name);
    }

    function updateValuePerBlockFee(uint256 _valuePerBlockFee) public onlyOwner {
        valuePerBlockFee = _valuePerBlockFee;
        emit UpdateValuePerBlockFee(_valuePerBlockFee);
    }

    function updateCollectionBeacon(address _collectionBeacon) public onlyOwner {
        require(_collectionBeacon != address(0), "Invalid collection beacon address");
        collectionBeacon = _collectionBeacon;
        emit UpdateCollectionBeacon(_collectionBeacon);
    }

}

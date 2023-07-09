// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";


contract MuseumImpl is Initializable, Ownable {
    string public name;
    uint256 public valuePerBlockFee;
    uint256 public collectionCount;
    uint256 public subscriptionCount = 1; // Start at 1 because 0 is reserved for non-subscribers

    struct Subscription {
        address subscriber;
        uint256 block;
    }

    struct Visitor {
        uint256 subscription;
        uint256 timestamp;
    }

    mapping(uint256 => address) public collections;
    mapping(uint256 => Subscription) public subscriptions;
    mapping(address => Visitor) public visitors;
    // The above Subscription/Visitor structure does not account for multiple subscriptions to be attached to a visitor but we probably don't care.

    event Collection(address indexed _collection);
    event AttachCollection(uint256 indexed _index, address indexed _collection);
    event DetachCollection(uint256 indexed _index);
    event Subscribe(address indexed _subscriber, uint256 indexed _subscription);
    event Extend(uint256 indexed _subscription, uint256 indexed _block, address indexed _by);
    event Withdraw(address indexed _to, uint256 indexed _amount);
    event Grant(address indexed _visitor, uint256 indexed _subscription);
    event UpdateName(string _name);
    event UpdateValuePerBlockFee(uint256 _valuePerBlockFee);

    function initialize(address _curator, string memory _name, uint256 _valuePerBlockFee) initializer public {
        require(_curator != address(0), "Invalid curator address");
        _transferOwnership(_curator);
        name = _name;
        valuePerBlockFee = _valuePerBlockFee;
    }

    function createCollection(address _beacon, string memory _name, uint8 _decimals, uint256 _version) public onlyOwner {
        address _collection = address(new BeaconProxy(_beacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint8,uint256)",
            address(this),
            owner(),
            _name,
            _decimals,
            _version
        )));
        emit Collection(_collection);
        _attachCollection(_collection);
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
        require(visitors[msg.sender].timestamp == 0 || subscriptions[_subscription(msg.sender)].subscriber != msg.sender, "Already subscribed");

        uint256 blocks = msg.value / valuePerBlockFee;
        subscriptions[subscriptionCount] = Subscription(msg.sender, block.number + blocks);
        visitors[msg.sender] = Visitor(subscriptionCount, block.timestamp);
        subscriptionCount += 1;

        emit Subscribe(subscriptionCount - 1, msg.sender, subscriptions[subscriptionCount - 1].block);
        emit Grant(msg.sender, subscriptionCount - 1);
    }

    function extend(uint256 _subscription) public payable {
        require(msg.value >= valuePerBlockFee, "Insufficient fee");
        require(msg.value % valuePerBlockFee == 0, "Invalid fee");

        uint256 blocks = msg.value / valuePerBlockFee;

        if (subscriptions[_subscription].block < block.number) {
            subscriptions[_subscription].block = block.number + _blocks;
        } else {
            subscriptions[_subscription].block += _blocks;
        }

        emit Extend(_subscription, subscriptions[_subscription].block, msg.sender);
    }

    function withdraw(address _to, uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(_to).transfer(_amount);
        emit Withdraw(_to, _amount);
    }

    function grant(address _visitor) public {
        require(subscriptions[_subscription(msg.sender)].subscriber == msg.sender, "Only subscription owner can grant visitation");
        visitors[_visitor] = Visitor(_subscription(msg.sender), block.timestamp);
        emit Grant(_visitor, _subscription(msg.sender));
    }

    function subscription(address _subscriber) public view returns (uint256) {
        return _subscription(_subscriber);
    }

    function _subscription(address _subscriber) internal view returns (uint256) {
        return visitors[_subscriber].subscription;
    }

    function hasVisitor() public view returns (bool) {
        if (msg.sender == owner()) {
            return true;
        }
        visitor = visitors[msg.sender];
        if (visitor.timestamp > 0 && subscriptions[visitor.subscription].block >= block.number) {
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

}

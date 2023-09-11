// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@zeppelin/proxy/Clones.sol";
import "@zeppelin/proxy/utils/Initializable.sol";

import "./Configurable.sol";
import "./interfaces/IMuseum.sol";


contract Museum is Initializable, Configurable, IMuseum {
    string public name;
    uint256 public valuePerBlockFee;
    uint256 public collectionCount;
    uint256 public subscriptionCount;

    struct Subscription {
        address subscriber;
        uint256 block;
    }

    struct Visitor {
        uint256 subscription;
        uint256 timestamp;
    }

    mapping(uint256 => address) public collections;
    mapping(uint256 => Subscription) private subscriptions;
    mapping(address => Visitor) private visitors;
    mapping(address => bool) public admins;
    mapping(address => bool) public curators;
    // The above Subscription/Visitor structure does not account for multiple subscriptions to be attached to a visitor but we probably don't care.

    event Collection(address indexed _collection);
    event AttachCollection(uint256 indexed _index, address indexed _collection);
    event DetachCollection(uint256 indexed _index);
    event Subscribe(address indexed _subscriber, uint256 indexed _subscription, uint256 indexed _block);
    event Extend(uint256 indexed _subscription, uint256 indexed _block, address indexed _by);
    event Withdraw(address indexed _to, uint256 indexed _amount);
    event Grant(address indexed _visitor, uint256 indexed _subscription);
    event UpdateName(string _oldName, string _newName);
    event UpdateValuePerBlockFee(uint256 _oldValuePerBlockFee, uint256 _newValuePerBlockFee);
    event UpdateAdmin(address indexed _admin, bool _enable);
    event UpdateCurator(address indexed _curator, bool _enable);

    constructor() {
        _disableInitializers();
    }

    function initialize(address _admin, address _curator, address _config, string memory _name, uint256 _valuePerBlockFee) initializer external {
        require(_admin != address(0), "Museum: invalid admin address");
        require(_curator != address(0), "Museum: invalid curator address");
        require(_config != address(0), "Museum: invalid config address");

        __Configurable_init(_config);

        admins[_admin] = true;
        curators[_curator] = true;
        name = _name;
        valuePerBlockFee = _valuePerBlockFee;

        // Start at 1 because 0 is reserved for non-subscribers
        subscriptionCount = 1;
    }

    function createCollection(string memory _name) external onlyAdmin returns (address _collection) {
        _collection = _createCollection(_name, 18, 1, "(int256)", true);
    }

    function createCollection(string memory _name, uint8 _decimals) external onlyAdmin returns (address _collection) {
        _collection = _createCollection(_name, _decimals, 1, "(int256)", true);
    }

    function createCollection(string memory _name, uint8 _decimals, uint256 _version, string memory _decode, bool _compatible) external onlyAdmin returns (address _collection) {
        _collection = _createCollection(_name, _decimals, _version, _decode, _compatible);
    }

    function _createCollection(string memory _name, uint8 _decimals, uint256 _version, string memory _decode, bool _compatible) internal returns (address _collection) {
        bytes memory _data = abi.encodeWithSignature(
            "initialize(address,string,uint8,uint256,string,bool)",
            address(this),
            _name,
            _decimals,
            _version,
            _decode,
            _compatible
        );
        bytes32 _salt = keccak256(_data);
        _collection = Clones.cloneDeterministic(config.collectionImpl(), _salt);
        (bool _success,) = _collection.call(_data);
        require(_success, "Museum: failed to initialize collection");
        emit Collection(_collection);
        _attachCollection(_collection);
    }

    function attachCollection(address _collection) external onlyAdmin returns (uint256 _index) {
        _index = _attachCollection(_collection);
    }

    function _attachCollection(address _collection) internal returns (uint256 _index) {
        require(_collection != address(0), "Museum: invalid collection address");
        _index = collectionCount;
        collections[_index] = _collection;
        collectionCount += 1;
        emit AttachCollection(_index, _collection);
    }

    function detachCollection(uint256 _index) external onlyAdmin {
        require(collections[_index] != address(0), "Museum: invalid collection address");
        delete collections[_index];
        emit DetachCollection(_index);
    }

    function subscribe() external payable {
        require(msg.value >= valuePerBlockFee, "Museum: insufficient fee");
        require(msg.value % valuePerBlockFee == 0, "Museum: invalid fee");
        require(visitors[msg.sender].timestamp == 0 || subscriptions[_subscription(msg.sender)].subscriber != msg.sender, "Museum: already subscribed");

        uint256 _blocks = msg.value / valuePerBlockFee;
        subscriptions[subscriptionCount] = Subscription(msg.sender, block.number + _blocks);
        visitors[msg.sender] = Visitor(subscriptionCount, block.timestamp);
        subscriptionCount += 1;

        emit Subscribe(msg.sender, subscriptionCount - 1, subscriptions[subscriptionCount - 1].block);
        emit Grant(msg.sender, subscriptionCount - 1);

        if (config.tax() > 0) {
            uint256 _tax = msg.value * config.tax() / 10000;
            payable(config.treasury()).transfer(_tax);
        }
    }

    function extend(uint256 _index) external payable {
        require(msg.value >= valuePerBlockFee, "Museum: insufficient fee");
        require(msg.value % valuePerBlockFee == 0, "Museum: invalid fee");
        require(subscriptions[_index].subscriber != address(0), "Museum: invalid subscription");

        uint256 _blocks = msg.value / valuePerBlockFee;

        if (subscriptions[_index].block < block.number) {
            subscriptions[_index].block = block.number + _blocks;
        } else {
            subscriptions[_index].block += _blocks;
        }

        emit Extend(_index, subscriptions[_index].block, msg.sender);
    }

    function withdraw(address _to, uint256 _amount) external onlyAdmin {
        require(address(this).balance >= _amount, "Museum: insufficient balance");
        payable(_to).transfer(_amount);
        emit Withdraw(_to, _amount);
    }

    function grant(address _visitor) external {
        require(subscriptions[_subscription(msg.sender)].subscriber == msg.sender, "Museum: only subscription owner can grant visitation");
        visitors[_visitor] = Visitor(_subscription(msg.sender), block.timestamp);
        emit Grant(_visitor, _subscription(msg.sender));
    }

    function subscription(address _subscriber) external view returns (uint256) {
        return _subscription(_subscriber);
    }

    function _subscription(address _subscriber) internal view returns (uint256) {
        return visitors[_subscriber].subscription;
    }

    function updateName(string memory _newName) external onlyAdmin {
        require(bytes(_newName).length > 0, "Museum: invalid name");
        string memory _oldName = name;
        name = _newName;
        emit UpdateName(_oldName, _newName);
    }

    function updateValuePerBlockFee(uint256 _newValuePerBlockFee) external onlyAdmin {
        require(_newValuePerBlockFee > 0, "Museum: invalid valuePerBlockFee");
        uint256 _oldValuePerBlockFee = valuePerBlockFee;
        valuePerBlockFee = _newValuePerBlockFee;
        emit UpdateValuePerBlockFee(_oldValuePerBlockFee, _newValuePerBlockFee);
    }

    function updateAdmin(address _admin, bool _enable) external onlyAdmin {
        require(_admin != address(0), "Museum: invalid admin address");
        require(admins[_admin] != _enable, "Museum: same admin status");
        admins[_admin] = _enable;
        emit UpdateAdmin(_admin, _enable);
    }

    function updateCurator(address _curator, bool _enable) external onlyAdmin {
        require(_curator != address(0), "Museum: invalid curator address");
        require(curators[_curator] != _enable, "Museum: same curator status");
        curators[_curator] = _enable;
        emit UpdateCurator(_curator, _enable);
    }

    function hasVisitor(address _visitor) external view returns (bool _exists) {
        _exists = false;

        if (valuePerBlockFee == 0 || admins[_visitor] || curators[_visitor]) {
            _exists = true;
        }

        Visitor memory _visitorItem = visitors[_visitor];
        if (_visitorItem.timestamp > 0 && subscriptions[_visitorItem.subscription].block >= block.number) {
            _exists = true;
        }
    }

    function hasAdmin(address _admin) external view returns (bool) {
        return admins[_admin];
    }

    function hasCurator(address _curator) external view returns (bool) {
        return curators[_curator];
    }

    modifier onlyAdmin {
        require(admins[msg.sender], "Museum: only admin");
        _;
    }
}

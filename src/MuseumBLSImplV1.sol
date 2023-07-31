// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./IVisitable.sol";
import "./MuseumV1.sol";
import "./bls/BLSOwnableUpgradeable.sol";


contract MuseumBLSImplV1 is Initializable, BLSOwnableUpgradeable, MuseumV1 {
    bytes32 constant EIP712_CREATE_COLLECTION = keccak256("CreateCollection(string name, uint8 decimals, uint256 version)");
    bytes32 constant EIP712_ATTACH_COLLECTION = keccak256("AttachCollection(address collection)");
    bytes32 constant EIP712_DETACH_COLLECTION = keccak256("DetachCollection(uint256 index)");
    bytes32 constant EIP712_WITHDRAW = keccak256("Withdraw(address to, uint256 amount)");
    bytes32 constant EIP712_UPDATE_NAME = keccak256("UpdateName(string name)");
    bytes32 constant EIP712_UPDATE_VALUE_PER_BLOCK_FEE = keccak256("UpdateValuePerBlockFee(uint256 valuePerBlockFee)");
    bytes32 constant EIP712_UPDATE_COLLECTION_BEACON = keccak256("UpdateCollectionBeacon(address collectionBeacon)");

    function initialize(address _collectionBeacon, uint256[4] memory blsPublicKey_, string memory _name, uint256 _valuePerBlockFee) initializer public {
        __BLSOwnable_init("MuseumBLS", "v1", blsPublicKey_);
        __MuseumV1_init(_collectionBeacon, _name, _valuePerBlockFee);
    }

    function createCollection(string memory _name, uint8 _decimals, uint256 _version, uint256[2] memory blsSignature) public returns (address) {
        bytes32 digest = keccak256(abi.encode(
            EIP712_CREATE_COLLECTION,
            _name,
            _decimals,
            _version
        ));
        requireMessageVerified(digest, blsSignature);
        address _collection = address(new BeaconProxy(collectionBeacon, abi.encodeWithSignature(
            "initialize(address,uint256[4],string,uint8,uint256)",
            address(this),
            blsPublicKey,
            _name,
            _decimals,
            _version
        )));
        return _createCollection(_collection); 
    }

    function attachCollection(address _collection, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_ATTACH_COLLECTION,
            _collection
        ));
        requireMessageVerified(digest, blsSignature);
        _attachCollection(_collection);
    }

    function detachCollection(uint256 _index, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_DETACH_COLLECTION,
            _index
        ));
        requireMessageVerified(digest, blsSignature);
        _detachCollection(_index); 
    }

    function withdraw(address _to, uint256 _amount, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_WITHDRAW,
            _to,
            _amount
        ));
        requireMessageVerified(digest, blsSignature);
        _withdraw(_to, _amount); 
    }

    function hasVisitor(address _visitor) public view override returns (bool) {
        return _hasVisitor(address(0), _visitor); 
    }

    function curator() public pure override returns (address) {
        return address(0);
    }

    function updateName(string memory _name, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_NAME,
            _name
        ));
        requireMessageVerified(digest, blsSignature);
        _updateName(_name); 
    }

    function updateValuePerBlockFee(uint256 _valuePerBlockFee, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_VALUE_PER_BLOCK_FEE,
            _valuePerBlockFee
        ));
        requireMessageVerified(digest, blsSignature);
        _updateValuePerBlockFee(_valuePerBlockFee);
    }

    function updateCollectionBeacon(address _collectionBeacon, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_COLLECTION_BEACON,
            _collectionBeacon
        ));
        requireMessageVerified(digest, blsSignature);
        _updateCollectionBeacon(_collectionBeacon);
    }

}
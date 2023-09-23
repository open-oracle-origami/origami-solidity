// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@upgradeable/proxy/utils/Initializable.sol";
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

    function initialize(address _collectionBeacon, string memory _name, uint256 _valuePerBlockFee, uint256[4] memory _blsPublicKey) initializer public {
        __BLSOwnable_init("MuseumBLS", "v1", _blsPublicKey);
        __MuseumV1_init(_collectionBeacon, _name, _valuePerBlockFee);
    }

    function _preDeployCollection(string memory _name, uint8 _decimals, uint256 _version, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_CREATE_COLLECTION,
            _name,
            _decimals,
            _version
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _deployCollection(string memory _name, uint8 _decimals, uint256 _version) internal override returns (address) {
        address _collection = address(new BeaconProxy(collectionBeacon, abi.encodeWithSignature(
            "initialize(address,uint256[4],string,uint8,uint256)",
            address(this),
            blsPublicKey,
            _name,
            _decimals,
            _version
        )));
        return _collection;
    }

    function _preAttachCollection(address _collection, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_ATTACH_COLLECTION,
            _collection
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preDetachCollection(uint256 _index, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_DETACH_COLLECTION,
            _index
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preWithdraw(address _to, uint256 _amount, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_WITHDRAW,
            _to,
            _amount
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _owner() internal pure override returns (address) {
        return address(0);
    }

    function curator() public pure override returns (address) {
        return address(0);
    }

    function _preUpdateName(string memory _name, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_NAME,
            _name
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preUpdateValuePerBlockFee(uint256 _valuePerBlockFee, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_VALUE_PER_BLOCK_FEE,
            _valuePerBlockFee
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preUpdateCollectionBeacon(address _collectionBeacon, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_COLLECTION_BEACON,
            _collectionBeacon
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

}

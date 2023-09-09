// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./IVisitable.sol";
import "./CollectionV1.sol";
import "./bls/BLSOwnableUpgradeable.sol";


contract CollectionBLSImplV1 is Initializable, BLSOwnableUpgradeable, CollectionV1 {
    bytes32 public constant EIP712_CURATE = keccak256("Curate(int256 data)");
    bytes32 public constant EIP712_ATTACH_MUSEUM = keccak256("AttachMuseum(address museum)");
    bytes32 public constant EIP712_DETACH_MUSEUM = keccak256("DetachMuseum(address museum)");
    bytes32 public constant EIP712_UPDATE_NAME = keccak256("UpdateName(string name)");
    bytes32 public constant EIP712_UPDATE_DECIMALS = keccak256("UpdateDecimals(uint8 decimals)");
    bytes32 public constant EIP712_UPDATE_VERSION = keccak256("UpdateVersion(uint256 version)");

    function initialize(address _museum, string memory _name, uint8 _decimals, uint256 _version, uint256[4] memory _blsPublicKey) initializer public {
        __CollectionV1_init(_museum, _name, _decimals, _version);
        __BLSOwnable_init("CollectionBLS", "v1", _blsPublicKey);
    }

    function curator() public pure override returns (address) {
        return address(0);
    }

    function _preCurate(int256 _data, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_CURATE,
            _data
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preAttachMuseum(address _museum, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_ATTACH_MUSEUM,
            _museum
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preDetachMuseum(address _museum, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_DETACH_MUSEUM,
            _museum
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preUpdateName(string memory _name, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_NAME,
            _name
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preUpdateDecimals(uint8 _decimals, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_DECIMALS,
            _decimals
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _preUpdateVersion(uint256 _version, bytes memory _blsSignatureRaw) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_VERSION,
            _version
        ));
        requireMessageVerified(digest, decodeProof(_blsSignatureRaw));
    }

    function _owner() internal override pure returns (address) {
        return address(0);
    } 
}


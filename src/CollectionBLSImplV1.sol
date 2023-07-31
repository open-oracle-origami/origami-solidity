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

    function initialize(address _museum, uint256[4] memory blsPublicKey_, string memory _name, uint8 _decimals, uint256 _version) initializer public {
        __CollectionV1_init(_museum, _name, _decimals, _version);
        __BLSOwnable_init("CollectionBLS", "v1", blsPublicKey_);
    }

    function curator() public pure override returns (address) {
        return address(0);
    }

    function curate(int256 _data, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_CURATE,
            _data
        ));
        requireMessageVerified(digest, blsSignature);
        _curate(_data); 
    }

    function attachMuseum(address _museum, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_ATTACH_MUSEUM,
            _museum
        ));
        requireMessageVerified(digest, blsSignature);
        _attachMuseum(_museum); 
    }

    function detachMuseum(address _museum, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_DETACH_MUSEUM,
            _museum
        ));
        requireMessageVerified(digest, blsSignature);
        _detachMuseum(_museum);
    }

    function updateName(string memory _name, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_NAME,
            _name
        ));
        requireMessageVerified(digest, blsSignature);
        _updateName(_name);
    }

    function updateDecimals(uint8 _decimals, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_DECIMALS,
            _decimals
        ));
        requireMessageVerified(digest, blsSignature);
        _updateDecimals(_decimals);
    }

    function updateVersion(uint256 _version, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_VERSION,
            _version
        ));
        requireMessageVerified(digest, blsSignature);
        _updateVersion(_version);
    }

    function requireVisitor() internal view override {
        _requireVisitor(); 
    }
}


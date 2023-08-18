// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./ShibuyaV1.sol";
import "./bls/BLSOwnableUpgradeable.sol";


contract ShibuyaBLSImplV1 is Initializable, ShibuyaV1, BLSOwnableUpgradeable {
    bytes32 constant public EIP712_UPDATE_MUSEUM_BEACON = keccak256("UpdateMuseumBeacon(address museumBeacon)");
    bytes32 constant public EIP712_UPDATE_COLLECTION_BEACON = keccak256("UpdateCollectionBeacon(address collectionBeacon)");
    bytes32 constant public EIP712_UPGRADE_TO = keccak256("UpgradeTo(address newImplementation)");
    bytes32 constant public EIP712_UPGRADE_TO_AND_CALL = keccak256("UpgradeToAndCall(address newImplementation,bytes data)");

    function initialize(address _museumBeacon, address _collectionBeacon, uint256[4] memory blsPublicKey_) initializer public {
        __BLSOwnable_init("ShibuyaBLS", "v1", blsPublicKey_);
        __ShibuyaV1_init(_museumBeacon, _collectionBeacon); 
    }

    function _deployMuseum(string memory _name, uint256 _valuePerBlockFee, bytes memory blsPublicKeyRaw) internal override returns (address) {
        address _museum = address(new BeaconProxy(museumBeacon, abi.encodeWithSignature(
            "initialize(address,uint256[4],string,uint256)",
            collectionBeacon,
            decodeAuthority(blsPublicKeyRaw),
            _name,
            _valuePerBlockFee
        )));

        return _museum;
    }

    function _preUpdateMuseum(address _museumBeacon, bytes memory blsSignatureRaw) internal override view  {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_MUSEUM_BEACON,
            _museumBeacon
        ));
        requireMessageVerified(digest, decodeProof(blsSignatureRaw));
    }

    function _preUpdateCollectionBeacon(address _collectionBeacon, bytes memory blsSignature) internal override view {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPDATE_COLLECTION_BEACON,
            _collectionBeacon
        ));
        requireMessageVerified(digest, decodeProof(blsSignature));
    }

    function upgradeTo(address newImplementation, uint256[2] memory blsSignature) public onlyProxy {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPGRADE_TO,
            newImplementation
        ));
        requireMessageVerified(digest, blsSignature);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    function upgradeToAndCall(address newImplementation, bytes memory data, uint256[2] memory blsSignature) public onlyProxy {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPGRADE_TO_AND_CALL,
            newImplementation,
            data
        ));
        requireMessageVerified(digest, blsSignature);
        _upgradeToAndCallUUPS(newImplementation, data, true);
    }

    function _authorizeUpgrade(address) internal pure override {
        revert("Method not allowed");
    }
}
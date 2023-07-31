// SPDX-License-Identifier: MIT
// based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/proxy/beacon/UpgradeableBeacon.sol
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/proxy/beacon/IBeacon.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "./bls/BLSOwnableUpgradeable.sol";

contract UpgradeableBeaconBLS is IBeacon, BLSOwnableUpgradeable {
    bytes32 constant public EIP712_UPGRADE_TO = keccak256("UpgradeTo(address newImplementation)");

    address private _implementation;

    event Upgraded(address indexed implementation);

    constructor(address implementation_, uint256[4] memory blsPublicKey_) {
        __BLSOwnable_init("UpgradeableBeaconBLS", "v1", blsPublicKey_);
        _setImplementation(implementation_);
    }

    function implementation() public view override returns (address) {
        return _implementation;
    }

    function upgradeTo(address newImplementation, uint256[2] memory blsSignature) public {
        bytes32 digest = keccak256(abi.encode(
            EIP712_UPGRADE_TO,
            newImplementation
        ));
        requireMessageVerified(digest, blsSignature);
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    function _setImplementation(address newImplementation) private {
        require(Address.isContract(newImplementation), "UpgradeableBeacon: implementation is not a contract");
        _implementation = newImplementation;
    }
}
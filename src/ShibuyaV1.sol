// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/proxy/beacon/BeaconProxy.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";


abstract contract ShibuyaV1 is Initializable, UUPSUpgradeable {
    uint256 public museumCount;
    address public museumBeacon;
    address public collectionBeacon;

    mapping(uint256 => address) public museums;

    event Museum(address indexed _museum);
    event UpdateMuseumBeacon(address indexed _museumBeacon);
    event UpdateCollectionBeacon(address indexed _collectionBeacon);

    function __ShibuyaV1_init(address _museumBeacon, address _collectionBeacon) onlyInitializing public {
        __UUPSUpgradeable_init();
        museumBeacon = _museumBeacon;
        collectionBeacon = _collectionBeacon;
    }

    function _createMuseum(address _museum) public returns (address) {
        museums[museumCount] = _museum;
        museumCount += 1;
        emit Museum(_museum);

        return _museum;
    }

    function _updateMuseumBeacon(address _museumBeacon) internal {
        require(_museumBeacon != address(0), "Invalid museum beacon address");
        museumBeacon = _museumBeacon;
        emit UpdateMuseumBeacon(_museumBeacon);
    }

    function _updateCollectionBeacon(address _collectionBeacon) internal {
        require(_collectionBeacon != address(0), "Invalid collection beacon address");
        collectionBeacon = _collectionBeacon;
        emit UpdateCollectionBeacon(_collectionBeacon);
    }
}


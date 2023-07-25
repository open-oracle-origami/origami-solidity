// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/proxy/beacon/BeaconProxy.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";


contract ShibuyaImplV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public museumCount;
    address public museumBeacon;
    address public collectionBeacon;

    mapping(uint256 => address) public museums;

    event Museum(address indexed _museum);
    event UpdateMuseumBeacon(address indexed _museumBeacon);
    event UpdateCollectionBeacon(address indexed _collectionBeacon);

    function initialize(address _museumBeacon, address _collectionBeacon) initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();
        museumBeacon = _museumBeacon;
        collectionBeacon = _collectionBeacon;
    }

    function createMuseum(string memory _name, uint256 _valuePerBlockFee) public returns (address) {
        address _museum = address(new BeaconProxy(museumBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint256)",
            collectionBeacon,
            msg.sender,
            _name,
            _valuePerBlockFee
        )));
        museums[museumCount] = _museum;
        museumCount += 1;
        emit Museum(_museum);

        return _museum;
    }

    function updateMuseumBeacon(address _museumBeacon) public onlyOwner {
        require(_museumBeacon != address(0), "Invalid museum beacon address");
        museumBeacon = _museumBeacon;
        emit UpdateMuseumBeacon(_museumBeacon);
    }

    function updateCollectionBeacon(address _collectionBeacon) public onlyOwner {
        require(_collectionBeacon != address(0), "Invalid collection beacon address");
        collectionBeacon = _collectionBeacon;
        emit UpdateCollectionBeacon(_collectionBeacon);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}

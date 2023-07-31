// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./ShibuyaV1.sol";


contract ShibuyaImplV1 is Initializable, ShibuyaV1, OwnableUpgradeable {
    function initialize(address _museumBeacon, address _collectionBeacon) initializer public {
        __Ownable_init();
        __ShibuyaV1_init(_museumBeacon, _collectionBeacon); 
    }

    function createMuseum(string memory _name, uint256 _valuePerBlockFee) public returns (address) {
        address _museum = address(new BeaconProxy(museumBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint256)",
            collectionBeacon,
            msg.sender,
            _name,
            _valuePerBlockFee
        )));
        return _createMuseum(_museum);
    }

    function updateMuseumBeacon(address _museumBeacon) public onlyOwner {
        _updateMuseumBeacon(_museumBeacon); 
    }

    function updateCollectionBeacon(address _collectionBeacon) public onlyOwner {
        _updateCollectionBeacon(_collectionBeacon); 
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}

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

    function _deployMuseum(string memory _name, uint256 _valuePerBlockFee, bytes memory) internal override returns (address) {
        address _museum = address(new BeaconProxy(museumBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint256)",
            collectionBeacon,
            msg.sender,
            _name,
            _valuePerBlockFee
        )));
        return _museum;
    }

    function _preUpdateMuseum(address _museumBeacon, bytes memory) internal override view onlyOwner {}

    function _preUpdateCollectionBeacon(address _collectionBeacon, bytes memory) internal override view onlyOwner {}

    function _authorizeUpgrade(address) internal override onlyOwner {}
}

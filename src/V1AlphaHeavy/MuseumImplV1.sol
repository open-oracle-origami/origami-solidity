// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@upgradeable/access/OwnableUpgradeable.sol";
import "@upgradeable/proxy/utils/Initializable.sol";
import "./IVisitable.sol";
import "./MuseumV1.sol";


contract MuseumImplV1 is Initializable, OwnableUpgradeable, MuseumV1 {
    function initialize(address _collectionBeacon, address _curator, string memory _name, uint256 _valuePerBlockFee) initializer public {
        __Ownable_init();
        __MuseumV1_init(_collectionBeacon, _name, _valuePerBlockFee);
        _transferOwnership(_curator);
    }

    function _preDeployCollection(string memory, uint8, uint256, bytes memory) internal override view onlyOwner {}

    function _deployCollection(string memory _name, uint8 _decimals, uint256 _version) internal override returns (address) {
        address _collection = address(new BeaconProxy(collectionBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint8,uint256)",
            address(this),
            owner(),
            _name,
            _decimals,
            _version
        )));
        return _collection;
    }

    function _preAttachCollection(address, bytes memory) internal override view onlyOwner {}

    function _preDetachCollection(uint256, bytes memory) internal override view onlyOwner {}

    function _preWithdraw(address, uint256, bytes memory) internal override view onlyOwner {}

    function _owner() internal override view returns (address) {
        return owner();
    }

    function curator() public view override returns (address) {
        return owner();
    }

    function _preUpdateName(string memory, bytes memory) internal override view onlyOwner {}

    function _preUpdateValuePerBlockFee(uint256, bytes memory) internal override view onlyOwner {}

    function _preUpdateCollectionBeacon(address, bytes memory) internal override view onlyOwner {}

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./IVisitable.sol";
import "./MuseumV1.sol";


contract MuseumImplV1 is Initializable, OwnableUpgradeable, MuseumV1 {
    function initialize(address _collectionBeacon, address _curator, string memory _name, uint256 _valuePerBlockFee) initializer public {
        __Ownable_init();
        __MuseumV1_init(_collectionBeacon, _name, _valuePerBlockFee);
        _transferOwnership(_curator);
    }

    function createCollection(string memory _name, uint8 _decimals, uint256 _version) public onlyOwner returns (address) {
        address _collection = address(new BeaconProxy(collectionBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint8,uint256)",
            address(this),
            owner(),
            _name,
            _decimals,
            _version
        )));
        return _createCollection(_collection);
    }

    function attachCollection(address _collection) public onlyOwner {
        _attachCollection(_collection);
    }

    function detachCollection(uint256 _index) public onlyOwner {
        _detachCollection(_index); 
    }

    function withdraw(address _to, uint256 _amount) public onlyOwner {
        _withdraw(_to, _amount); 
    }

    function hasVisitor(address _visitor) public view returns (bool) {
        return _hasVisitor(owner(), _visitor); 
    }

    function curator() public view override returns (address) {
        return owner();
    }

    function updateName(string memory _name) public onlyOwner {
        _updateName(_name); 
    }

    function updateValuePerBlockFee(uint256 _valuePerBlockFee) public onlyOwner {
        _updateValuePerBlockFee(_valuePerBlockFee);
    }

    function updateCollectionBeacon(address _collectionBeacon) public onlyOwner {
        _updateCollectionBeacon(_collectionBeacon);
    }

}

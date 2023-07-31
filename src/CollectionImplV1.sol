// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "./IVisitable.sol";
import "./CollectionV1.sol";


contract CollectionImplV1 is Initializable, OwnableUpgradeable, CollectionV1 {
    function initialize(address _museum, address _curator, string memory _name, uint8 _decimals, uint256 _version) initializer public {
        require(_curator != address(0), "Invalid curator address");
        __CollectionV1_init(_museum, _name, _decimals, _version);
        __Ownable_init();
        _transferOwnership(_curator);
    }

    function curator() public view override returns (address) {
        return owner();
    }

    function curate(int256 _data) public onlyOwner {
        _curate(_data); 
    }

    function attachMuseum(address _museum) public onlyOwner {
        _attachMuseum(_museum); 
    }

    function detachMuseum(address _museum) public onlyOwner {
        _detachMuseum(_museum);
    }

    function updateName(string memory _name) public onlyOwner {
        _updateName(_name);
    }

    function updateDecimals(uint8 _decimals) public onlyOwner {
        _updateDecimals(_decimals);
    }

    function updateVersion(uint256 _version) public onlyOwner {
        _updateVersion(_version);
    }

    function requireVisitor() internal view override {
        if (msg.sender != owner()) {
            _requireVisitor(); 
        }
    }
}

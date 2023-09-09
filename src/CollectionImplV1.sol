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

    function _preCurate(int256, bytes memory) internal override view onlyOwner {}

    function _preAttachMuseum(address, bytes memory) internal override view onlyOwner {}

    function _preDetachMuseum(address, bytes memory) internal override view onlyOwner {}

    function _preUpdateName(string memory, bytes memory) internal override view onlyOwner {}

    function _preUpdateDecimals(uint8, bytes memory) internal override view onlyOwner {}

    function _preUpdateVersion(uint256, bytes memory) internal override view onlyOwner {}

    function _owner() internal view override returns (address) {
        return owner();
    }
}

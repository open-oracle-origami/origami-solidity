// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

// TODO: Make upgradeable
contract Shibuya is Ownable {
    uint public museumCount;

    mapping(uint256 => address) public museums;

    event Museum(address indexed _museum);

    function createMuseum(address _beacon, string memory _name, uint256 _valuePerBlockFee) public {
        address _museum = address(new BeaconProxy(_beacon, abi.encodeWithSignature(
            "initialize(address,string,uint256)",
            msg.sender,
            _name,
            _valuePerBlockFee
        )));
        museums[museumCount] = _museum;
        museumCount += 1;
        emit Museum(_museum);
    }
}

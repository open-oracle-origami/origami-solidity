// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract MuseumImpl is Ownable {
    // Owner is the curator in this contract
    string public name;
    uint public valuePerBlockFee;
    uint256 public counter;

    struct Origami {
        uint256 data; // TODO: Default implementation is a uint256, change this and deploy for different data type
        uint256 timestamp;
    }

    struct Collection {
        string name;
        uint256 counter;
        mapping(uint256 => Origami) origami;
    }

    mapping(string => Collection) public collections;
}
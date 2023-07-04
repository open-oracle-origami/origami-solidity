// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
    TODO:
        Make upgradeable?
        Make contract proxy for compatability with AggregatorV3 ChainLink for Drop In Replacement IE: pass it this address and a collection
*/
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract OrigamiBeacon is Ownable {

    mapping(string => uint256) private counter;
    constructor() {

    }
}
/**
    Create3
    Encode/Decode Origami Data
    Meta Transactions
    Fix init to be like openzeppelin chained and unchained

    Better structure to use library for origami verification vs contract ownership
    BLS, Standard ACL and Single Owner for origami verification
        - Add Nonce or vulnerable to replay attack
        - Admin
        - Origami Verification
        - Visitation
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Shibuya {
    uint256 public museumCount;
    mapping(uint256 => address) public museums;

    event Museum(address indexed _museum);

    constructor(address _museumImpl, address _collectionImpl) {
        museumImpl = _museumImpl;
        collectionImpl = _collectionImpl;
    }

    function createMuseum(string memory _name, uint256 _valuePerBlockFee) public returns (address) {
        address _museum = address(new BeaconProxy(museumImpl, abi.encodeWithSignature(
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
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@open-oracle-origami/interfaces/IVisitor.sol";

contract VisitorIntegrationExample {
    /// @dev Origami Museum Collection Address For BTC Price (RTM)
    address public collection;

    constructor(address _collection) {
        collection = _collection;
    }

    function _btcPrice() private view returns (uint256) {
        (bytes memory _origami, uint256 _timestamp) = IVisitor(collection).visit();

        /// @dev Example of decoding uint256
        /// @dev Decode Origami based on collection type (RTM)
        (uint256 _price) = abi.decode(_origami, (uint256));

        return _price;
    }

    function swap() external {
        uint256 _btcPrice = _btcPrice();
        /// @dev Do something with the price
    }
}

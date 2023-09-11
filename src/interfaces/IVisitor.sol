// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IVisitor {
    function visit() external view returns (bytes memory _origami, uint256 _timestamp);
    function visit(uint80 _roundId) external view returns (bytes memory _origami, uint256 _timestamp);
}

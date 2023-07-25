// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IVisitable {
    function hasVisitor(address _visitor) external view returns (bool);
}

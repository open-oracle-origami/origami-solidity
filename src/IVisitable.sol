// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IVisitable {
    function hasVisitor(address _visitor) external view returns (bool);
}

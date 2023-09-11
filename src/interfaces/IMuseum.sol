// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IMuseum {
    function hasVisitor(address _visitor) external view returns (bool);
    function hasAdmin(address _admin) external view returns (bool);
    function hasCurator(address _curator) external view returns (bool);
}

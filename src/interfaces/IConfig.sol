// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IConfig {
    function tax() external view returns (uint16);
    function treasury() external view returns (address);
    function museumImpl() external view returns (address);
    function collectionImpl() external view returns (address);
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@solady/utils/CREATE3.sol";

contract C3 {
    function deploy(bytes32 salt, bytes memory creationCode) external payable returns (address deployed) {
        return CREATE3.deploy(salt, creationCode, msg.value);
    }

    function getDeployed(bytes32 salt) external view returns (address deployed) {
        return CREATE3.getDeployed(salt);
    }
}

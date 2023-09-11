// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@zeppelin/proxy/utils/Initializable.sol";

import "./interfaces/IConfig.sol";


abstract contract Configurable is Initializable {
    IConfig public config;

    function __Configurable_init(address _config) onlyInitializing internal {
        __Configurable_init_unchained(_config);
    }

    function __Configurable_init_unchained(address _config) onlyInitializing internal {
        require(_config != address(0), "Configurable: invalid config address");
        config = IConfig(_config);
    }
}

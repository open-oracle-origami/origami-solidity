// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin-contracts/contracts/proxy/beacon/UpgradeableBeacon.sol";

import "../src/V1Alpha/ShibuyaImplV1.sol";
import "../src/V1Alpha/MuseumImplV1.sol";
import "../src/V1Alpha/CollectionImplV1.sol";


contract DeployScriptV1 is Script {
    function run() public {
        vm.startBroadcast();
        address collectionImpl = address(new CollectionImplV1());
        address collectionBeacon = address(new UpgradeableBeacon(collectionImpl));

        address museumImpl = address(new MuseumImplV1());
        address museumBeacon = address(new UpgradeableBeacon(museumImpl));

        address shibuyaImpl = address(new ShibuyaImplV1());
        address shibuyaProxy = address(new ERC1967Proxy(shibuyaImpl, abi.encodeWithSignature(
            "initialize(address,address)",
            museumBeacon,
            collectionBeacon
        )));

        console.log("Collection Implementation: %s", collectionImpl);
        console.log("Collection Beacon: %s", collectionBeacon);

        console.log("Museum Implementation: %s", museumImpl);
        console.log("Museum Beacon: %s", museumBeacon);

        console.log("Shibuya Implementation: %s", shibuyaImpl);
        console.log("Shibuya Proxy: %s", shibuyaProxy);

        vm.stopBroadcast();
    }
}

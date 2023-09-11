// SPDX-License-Identifier: MIT
/*
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin-contracts/contracts/proxy/beacon/UpgradeableBeacon.sol";

import "../../src/V1AlphaHeavy/ShibuyaImplV1.sol";
import "../../src/V1AlphaHeavy/MuseumImplV1.sol";


contract InitLsdMuseumScript is Script {
    function run() public {
        vm.startBroadcast();
        ShibuyaImplV1 shibuya = ShibuyaImplV1(vm.envAddress("SHIBUYA_ADDRESS"));
        address museumAddress = shibuya.createMuseum("LSD Museum", 0);
        MuseumImplV1 museum = MuseumImplV1(museumAddress);

        address ankrAvax = museum.createCollection("ankravax-usd", 8, 1);
        address ankrBnb = museum.createCollection("ankrbnb-usd", 8, 1);
        address ankrEth = museum.createCollection("ankreth-usd", 8, 1);
        address ankrFtm = museum.createCollection("ankrftm-usd", 8, 1);
        address ankrMatic = museum.createCollection("ankrmatic-usd", 8, 1);
        address cbEth = museum.createCollection("cbeth-usd", 8, 1);
        address rEth = museum.createCollection("reth-usd", 8, 1);
        address rEth2 = museum.createCollection("reth2-usd", 8, 1);
        address stEth = museum.createCollection("steth-usd", 8, 1);
        address stMatic = museum.createCollection("stmatic-usd", 8, 1);
        address stSol = museum.createCollection("stsol-usd", 8, 1);

        console.log("Museum: %s", museumAddress);
        console.log("ANKRAVAX-USD: %s", ankrAvax);
        console.log("ANKRBNB-USD: %s", ankrBnb);
        console.log("ANKRETH-USD: %s", ankrEth);
        console.log("ANKRFTM-USD: %s", ankrFtm);
        console.log("ANKRMATIC-USD: %s", ankrMatic);
        console.log("CBETH-USD: %s", cbEth);
        console.log("RETH-USD: %s", rEth);
        console.log("RETH2-USD: %s", rEth2);
        console.log("STETH-USD: %s", stEth);
        console.log("STMATIC-USD: %s", stMatic);
        console.log("STSOL-USD: %s", stSol);

        vm.stopBroadcast();
    }
}
*/

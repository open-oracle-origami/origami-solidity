// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import "../src/Shibuya.sol";
import "../src/Museum.sol";
import "../src/Collection.sol";


contract LSDCore is Script {
    function run() public {
        vm.startBroadcast();
        Shibuya shibuya = Shibuya(vm.envAddress("SHIBUYA_ADDRESS"));
        Museum museum = Museum(shibuya.createMuseum("Origami LSD Arrangement Museum"));

        Collection ankrAvax = Collection(museum.createCollection("ankravax-usd", 8, 1, "(int256)", true));
        Collection ankrBnb = Collection(museum.createCollection("ankrbnb-usd", 8, 1, "(int256)", true));
        Collection ankrEth = Collection(museum.createCollection("ankreth-usd", 8, 1, "(int256)", true));
        Collection ankrFtm = Collection(museum.createCollection("ankrftm-usd", 8, 1, "(int256)", true));
        Collection ankrMatic = Collection(museum.createCollection("ankrmatic-usd", 8, 1, "(int256)", true));
        Collection cbEth = Collection(museum.createCollection("cbeth-usd", 8, 1, "(int256)", true));
        Collection rEth = Collection(museum.createCollection("reth-usd", 8, 1, "(int256)", true));
        Collection rEth2 = Collection(museum.createCollection("reth2-usd", 8, 1, "(int256)", true));
        Collection stEth = Collection(museum.createCollection("steth-usd", 8, 1, "(int256)", true));
        Collection stMatic = Collection(museum.createCollection("stmatic-usd", 8, 1, "(int256)", true));
        Collection stSol = Collection(museum.createCollection("stsol-usd", 8, 1, "(int256)", true));

        int256 ankrAvaxPrice = 1115000000;
        int256 ankrBnbPrice = 22219000000;
        int256 ankrEthPrice = 177706000000;
        int256 ankrFtmPrice = 20071100;
        int256 ankrMaticPrice = 57354000;
        int256 cbEthPrice = 165538000000;
        int256 rEthPrice = 164128000000;
        int256 rEth2Price = 156414000000;
        int256 stEthPrice = 157874000000;
        int256 stMaticPrice = 55072000;
        int256 stSolPrice = 2027000000;
        ankrAvax.curate(1, abi.encode(ankrAvaxPrice));
        ankrBnb.curate(1, abi.encode(ankrBnbPrice));
        ankrEth.curate(1, abi.encode(ankrEthPrice));
        ankrFtm.curate(1, abi.encode(ankrFtmPrice));
        ankrMatic.curate(1, abi.encode(ankrMaticPrice));
        cbEth.curate(1, abi.encode(cbEthPrice));
        rEth.curate(1, abi.encode(rEthPrice));
        rEth2.curate(1, abi.encode(rEth2Price));
        stEth.curate(1, abi.encode(stEthPrice));
        stMatic.curate(1, abi.encode(stMaticPrice));
        stSol.curate(1, abi.encode(stSolPrice));

        console.log("Origami LSD Arrangement Museum: %s", address(museum));
        console.log("ANKRAVAX-USD: %s", address(ankrAvax));
        console.log("ANKRBNB-USD: %s", address(ankrBnb));
        console.log("ANKRETH-USD: %s", address(ankrEth));
        console.log("ANKRFTM-USD: %s", address(ankrFtm));
        console.log("ANKRMATIC-USD: %s", address(ankrMatic));
        console.log("CBETH-USD: %s", address(cbEth));
        console.log("RETH-USD: %s", address(rEth));
        console.log("RETH2-USD: %s", address(rEth2));
        console.log("STETH-USD: %s", address(stEth));
        console.log("STMATIC-USD: %s", address(stMatic));
        console.log("STSOL-USD: %s", address(stSol));
        vm.stopBroadcast();
    }
}

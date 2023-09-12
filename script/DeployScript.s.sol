// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import "../src/C3.sol";
import "../src/Shibuya.sol";
import "../src/Museum.sol";
import "../src/Collection.sol";


contract Core is Script {
    function run() public {
        vm.startBroadcast();
        C3 c3 = new C3();

        address collectionImpl = c3.deploy(
            keccak256(abi.encodePacked(
                msg.sender,
                "COLLECTION_V0.0.1"
            )),
            vm.getCode("Collection.sol")
        );

        address museumImpl = c3.deploy(
            keccak256(abi.encodePacked(
                msg.sender,
                "MUSEUM_V0.0.1"
            )),
            vm.getCode("Museum.sol")
        );

        address shibuya = c3.deploy(
            keccak256(abi.encodePacked(
                msg.sender,
                "SHIBUYA_V0.0.1"
            )),
            abi.encodePacked(
                vm.getCode("Shibuya.sol"),
                abi.encode(
                    500,
                    vm.envAddress("TREASURY_ADDRESS"),
                    museumImpl,
                    collectionImpl
                )
            )
        );

        console2.log("Collection Implementation: %s", collectionImpl);
        console2.log("Museum Implementation: %s", museumImpl);
        console2.log("Shibuya: %s", shibuya);
        vm.stopBroadcast();
    }
}

contract PrimaryArrangement is Script {
    function run() public {
        vm.startBroadcast();
        Shibuya shibuya = Shibuya(vm.envAddress("SHIBUYA_ADDRESS"));
        Museum museum = Museum(shibuya.createMuseum("Origami Primary Arrangement Museum"));
        Collection btcusd = Collection(museum.createCollection("BTC-USD", 8, 1, "(int256)", true));
        Collection ethusd = Collection(museum.createCollection("ETH-USD", 8, 1, "(int256)", true));
        Collection ethbtc = Collection(museum.createCollection("ETH-BTC", 8, 1, "(int256)", true));
        int256 btcusdPrice = 2509757000000;
        int256 ethusdPrice = 154270000000;
        int256 ethbtcPrice = 61445000;
        btcusd.curate(1, abi.encode(btcusdPrice));
        ethusd.curate(1, abi.encode(ethusdPrice));
        ethbtc.curate(1, abi.encode(ethbtcPrice));

        console2.log("Origami Primary Arrangement Museum: %s", address(museum));
        console2.log("BTC-USD: %s", address(btcusd));
        console2.log("ETH-USD: %s", address(ethusd));
        console2.log("ETH-BTC: %s", address(ethbtc));
        vm.stopBroadcast();
    }
}

contract Decode is Script {
    function run() public {
        int256 btcusdPrice = 2509757000000;
        bytes memory ep = abi.encode(btcusdPrice);
        (int256 price) = abi.decode(ep, (int256));
        console2.log("Price: %s", price);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import "@solady/utils/CREATE3.sol";

import "../src/Shibuya.sol";
import "../src/Museum.sol";
import "../src/Collection.sol";


contract DeployScript is Script {
    function run() public {
        vm.startBroadcast();
        // testing the nonce change with create3 :)
        // payable(vm.envAddress("TREASURY_ADDRESS")).transfer(1 ether);

        address collectionImpl = CREATE3.deploy(
            keccak256(abi.encodePacked(
                msg.sender,
                "COLLECTION_V0.0.1"
            )),
            abi.encodePacked(
                vm.getCode("Collection.sol"),
                ""
            ),
            0
        );

        address museumImpl = CREATE3.deploy(
            keccak256(abi.encodePacked(
                msg.sender,
                "MUSEUM_V0.0.1"
            )),
            abi.encodePacked(
                vm.getCode("Museum.sol"),
                ""
            ),
            0
        );

        address shibuya = CREATE3.deploy(
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
            ),
            0
        );

        console2.log("Collection Implementation: %s", collectionImpl);
        console2.log("Museum Implementation: %s", museumImpl);
        console2.log("Shibuya: %s", shibuya);
        vm.stopBroadcast();
    }
}

contract FlightCheckScript is Script {
    function run() public {
        vm.startBroadcast();
        address collectionImpl = address(new Collection());
        console2.log("Collection Implementation: %s", collectionImpl);
        vm.stopBroadcast();
    }
}

contract FlightCheckAdvancedScript is Script {
    function run() public {
        vm.startBroadcast();
//        address collectionImpl = CREATE3.deploy(
//            keccak256(abi.encodePacked(
//                msg.sender,
//                "COLLECTION_FLIGHT_CHECK_ADVANCED"
//            )),
//            abi.encodePacked(
//                vm.getCode("Collection.sol"),
//                ""
//            ),
//            0
//        );
        address collectionImpl = deployCode("Collection.sol", "");
//        address collectionImpl = CREATE3.deploy(keccak256("test"), abi.encodePacked(vm.getCode("Collection.sol")), 0);
        console2.log("Collection Implementation: %s", collectionImpl);
        vm.stopBroadcast();
    }
}

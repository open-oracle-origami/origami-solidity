// SPDX-License-Identifier: MIT
/*
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin-contracts/contracts/proxy/beacon/UpgradeableBeacon.sol";

import "../../src/V1AlphaHeavy/ShibuyaImplV1.sol";
import "../../src/V1AlphaHeavy/MuseumImplV1.sol";
import "../../src/V1AlphaHeavy/CollectionImplV1.sol";

contract TestShibuyaImplV1 is Test {
    ShibuyaImplV1 shibuya;
    address museumBeacon;
    address collectionBeacon;

    function setUp() public {
        address collectionImpl = address(new CollectionImplV1());
        collectionBeacon = address(new UpgradeableBeacon(collectionImpl));

        address museumImpl = address(new MuseumImplV1());
        museumBeacon = address(new UpgradeableBeacon(museumImpl));

        address shibuyaImpl = address(new ShibuyaImplV1());
        address shibuyaProxy = address(new ERC1967Proxy(shibuyaImpl, abi.encodeWithSignature(
            "initialize(address,address)",
            museumBeacon,
            collectionBeacon
        )));

        shibuya = ShibuyaImplV1(shibuyaProxy);
    }

    function testInitialize() public {
        assertEq(shibuya.museumBeacon(), museumBeacon, "Invalid museum beacon address");
        assertEq(shibuya.museumCount(), 0, "Invalid museum count");
        assertEq(shibuya.collectionBeacon(), collectionBeacon, "Invalid collection beacon address");
    }

    function testInitializeRevertsWhenCalledTwice() public {
        vm.expectRevert();
        shibuya.initialize(museumBeacon, collectionBeacon);
    }

    function testCreateMuseum() public {
        MuseumImplV1 museum = MuseumImplV1(shibuya.createMuseum("Museum", 100));

        assertEq(museum.curator(), address(this), "Incorrect curator address");
        assertEq(museum.name(), "Museum", "Incorrect museum name");
        assertEq(museum.valuePerBlockFee(), 100, "Incorrect museum value per block fee");
        assertEq(shibuya.museumCount(), 1, "Incorrect museum count");
        assertEq(address(museum), shibuya.museums(0), "Incorrect museum address");
        // TODO: test for Museum event emission
    }

    function testUpdateMuseumBeacon() public {
        address newMuseumImpl = address(new MuseumImplV1());
        address newMuseumBeacon = address(new UpgradeableBeacon(newMuseumImpl));

        shibuya.updateMuseumBeacon(newMuseumBeacon);

        assertEq(shibuya.museumBeacon(), newMuseumBeacon, "Invalid museum beacon address");
        // TODO: test for UpdateMuseumBeacon event emission
    }

    function testUpdateMuseumBeaconRevertsWhenNotOwner() public {
        address newMuseumImpl = address(new MuseumImplV1());
        address newMuseumBeacon = address(new UpgradeableBeacon(newMuseumImpl));

        vm.startPrank(address(6));
        vm.expectRevert();
        shibuya.updateMuseumBeacon(newMuseumBeacon);
        vm.stopPrank();
    }

    function testUpdateCollectionBeacon() public {
        address newCollectionImpl = address(new CollectionImplV1());
        address newCollectionBeacon = address(new UpgradeableBeacon(newCollectionImpl));

        shibuya.updateCollectionBeacon(newCollectionBeacon);

        assertEq(shibuya.collectionBeacon(), newCollectionBeacon, "Invalid collection beacon address");
        // TODO: test for UpdateCollectionBeacon event emission
    }

    function testUpdateCollectionBeaconReversWhenNotOwner() public {
        address newCollectionImpl = address(new CollectionImplV1());
        address newCollectionBeacon = address(new UpgradeableBeacon(newCollectionImpl));

        vm.startPrank(address(6));
        vm.expectRevert();
        shibuya.updateCollectionBeacon(newCollectionBeacon);
        vm.stopPrank();
    }

    function testUpgradeRevertsWhenNotOwner() public {
        address newShibuyaImpl = address(new ShibuyaImplV1());

        vm.startPrank(address(6));
        vm.expectRevert();
        shibuya.upgradeTo(newShibuyaImpl);
        vm.stopPrank();
    }

}
*/

// SPDX-License-Identifier: MIT
/*
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@zeppelin/proxy/beacon/UpgradeableBeacon.sol";

import "../../src/V1AlphaHeavy/MuseumImplV1.sol";
import "../../src/V1AlphaHeavy/CollectionImplV1.sol";

contract TestMuseumImplV1 is Test {
    MuseumImplV1 museum;
    CollectionImplV1 collection;
    address collectionBeacon;

    function setUp() public {
        address collectionImpl = address(new CollectionImplV1());
        collectionBeacon = address(new UpgradeableBeacon(collectionImpl));

        museum = new MuseumImplV1();
        museum.initialize(collectionBeacon, address(this), "Museum", 100);
        collection = CollectionImplV1(museum.createCollection("Collection", 2, 1));
    }

    function testInitialize() public {
        assertEq(museum.collectionBeacon(), collectionBeacon, "Incorrect collection beacon address");
        assertEq(museum.curator(), address(this), "Incorrect curator address");
        assertEq(museum.name(), "Museum", "Incorrect museum name");
        assertEq(museum.valuePerBlockFee(), 100, "Incorrect value per block fee");
        assertEq(museum.collectionCount(), 1, "Incorrect collection count");
        assertEq(museum.subscriptionCount(), 1, "Incorrect subscription count");
    }

    function testInitializeRevertsWhenCalledTwice() public {
        vm.expectRevert();
        museum.initialize(collectionBeacon, address(this), "Museum", 200);
    }

    function testCreateCollection() public {
        assertEq(collection.curator(), museum.owner(), "Incorrect curator address");
        assertEq(collection.name(), "Collection", "Incorrect collection name");
        assertEq(collection.decimals(), 2, "Incorrect collection decimals");
        assertEq(collection.version(), 1, "Incorrect collection version");
        assertEq(address(collection), museum.collections(0), "Incorrect collection address");
        // TODO: test for Collection and AttachCollection event emission
    }

    function testAttachCollection() public {
        address _collection = address(new BeaconProxy(collectionBeacon, abi.encodeWithSignature(
            "initialize(address,address,string,uint8,uint256)",
            address(museum),
            address(this),
            "Collection 2",
            2,
            1
        )));

        vm.startPrank(address(6));
        vm.expectRevert();
        museum.attachCollection(_collection);
        vm.stopPrank();

        museum.attachCollection(_collection);

        assertEq(museum.collectionCount(), 2, "Incorrect collection count");
        assertEq(_collection, museum.collections(1), "Incorrect collection address");
        // TODO: test for AttachCollection event emission
    }

    function testDetachCollection() public {
        vm.startPrank(address(6));
        vm.expectRevert();
        museum.detachCollection(0);
        vm.stopPrank();

        museum.detachCollection(0);

        assertEq(museum.collections(0), address(0), "Collection was not detached");
        // TODO: test for DetachCollection event emission
    }

    function testSubscribe() public {
        vm.deal(address(4), 1 ether);
        vm.startPrank(address(4));
        museum.subscribe{value: 100}();
        vm.stopPrank();

        (address subscriber, uint256 blockTtl) = museum.subscriptions(1);
        (uint256 subscription, uint256 timestamp) = museum.visitors(address(4));

        assertEq(address(museum).balance, 100, "Incorrect contract balance");
        assertEq(subscriber, address(4), "Incorrect subscriber address");
        assertEq(blockTtl, block.number + 1, "Incorrect subscription block");
        assertEq(subscription, 1, "Incorrect subscription");
        assertEq(timestamp, block.timestamp, "Incorrect subscription timestamp");
        assertEq(museum.subscriptionCount(), 2, "Incorrect subscription count");
        // TODO: test for Subscribe and Grant event emission
    }

    function testExtend() public {
        vm.deal(address(4), 1 ether);
        vm.startPrank(address(4));
        museum.subscribe{value: 100}();
        museum.extend{value: 100}(1);
        vm.stopPrank();

        (address subscriber, uint256 blockTtl) = museum.subscriptions(1);
        (uint256 subscription, uint256 timestamp) = museum.visitors(address(4));

        assertEq(address(museum).balance, 200, "Incorrect museum balance");
        assertEq(subscriber, address(4), "Incorrect subscriber address");
        assertEq(blockTtl, block.number + 2, "Incorrect subscription block");
        assertEq(subscription, 1, "Incorrect subscription");
        assertEq(timestamp, block.timestamp, "Incorrect subscription timestamp");
        assertEq(museum.subscriptionCount(), 2, "Incorrect subscription count");
        // TODO: test for Extend event emission
    }

    function testWithdraw() public {
        museum.subscribe{value: 100}();

        uint256 withdrawAmount = 50;
        uint256 originalBalance = address(4).balance;

        museum.withdraw(address(4), withdrawAmount);

        assertEq(address(4).balance, originalBalance + withdrawAmount, "Incorrect contract balance");
        // TODO: test for Withdraw event emission
    }

    function testGrant() public {
        museum.subscribe{value: 100}();

        museum.grant(address(4));

        (uint256 subscription, uint256 timestamp) = museum.visitors(address(4));
        (address subscriber, uint256 blockTtl) = museum.subscriptions(subscription);

        assertEq(subscriber, address(this), "Incorrect subscriber address");
        assertEq(blockTtl, block.number + 1, "Incorrect subscription block");
        assertEq(subscription, 1, "Incorrect subscription");
        assertEq(timestamp, block.timestamp, "Incorrect subscription timestamp");
        assertEq(museum.subscriptionCount(), 2, "Incorrect subscription count");
        // TODO: test for Grant event emission
    }

    function testHasVisitor() public {
        museum.subscribe{value: 100}();

        assertEq(museum.hasVisitor(address(this)), true, "Invalid visitor");
    }

    function testUpdateName() public {
        museum.updateName("New Name");

        assertEq(museum.name(), "New Name", "Incorrect museum description");
        // TODO: test for UpdateName event emission
    }

    function testUpdateValuePerBlockFee() public {
        museum.updateValuePerBlockFee(5);

        assertEq(museum.valuePerBlockFee(), 5, "Incorrect value per block fee");
        // TODO: test for UpdateValuePerBlockFee event emission
    }

    function testUpdateCollectionBeacon() public {
        address collectionImpl = address(new CollectionImplV1());
        address newCollectionBeacon = address(new UpgradeableBeacon(collectionImpl));

        museum.updateCollectionBeacon(newCollectionBeacon);

        assertEq(museum.collectionBeacon(), newCollectionBeacon, "Incorrect collection beacon address");
        // TODO: test for UpdateCollectionBeacon event emission
    }
}
*/

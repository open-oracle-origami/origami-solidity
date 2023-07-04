// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/CollectionImpl.sol";

contract CollectionImplTest is Test {
    CollectionImpl private collection;
    address private museumMock;
    address private nonOwner;

    function beforeEach() public {
        museumMock = address(this);
        nonOwner = address(0x123456789);
        collection = new Collection(museumMock, "My Collection", 18);
    }

    function testVisit() public {
        (uint256 data, uint256 timestamp) = collection.visit();
        assertEq(data, 0, "Default data should be zero");
        assertEq(timestamp, 0, "Default timestamp should be zero");
    }

    function testCurator() public {
        address expectedCurator = address(this);
        assertEq(collection.curator(), expectedCurator, "Curator address mismatch");
    }

    function testCurate() public {
        uint256 data = 123;
        collection.curate(data);

        (uint256 curatedData, uint256 timestamp) = collection.visit();
        assertEq(curatedData, data, "Curated data mismatch");
        assertNotEq(timestamp, 0, "Timestamp should not be zero");
    }

    function testOnlyOwnerCanCurate() public {
        uint256 data = 123;
        CollectionImpl maliciousCollection = CollectionImpl(address(collection));
        maliciousCollection.curate(data); // Attempt to curate from a non-owner address

        (uint256 curatedData, uint256 timestamp) = collection.visit();
        assertEq(curatedData, 0, "Curated data should remain zero");
        assertEq(timestamp, 0, "Timestamp should remain zero");
    }

    function testOnlyVisitorCanVisit() public {
        uint256 data = 123;
        collection.curate(data);

        (uint256 curatedData, uint256 timestamp) = collection.visit();
        assertEq(curatedData, data, "Curated data mismatch");
        assertNotEq(timestamp, 0, "Timestamp should not be zero");

        // Non-visitor tries to visit
        CollectionImpl maliciousCollection = CollectionImpl(address(collection));
        maliciousCollection.visit();
        (uint256 nonVisitorData, uint256 nonVisitorTimestamp) = collection.visit();
        assertEq(nonVisitorData, data, "Curated data should remain unchanged");
        assertEq(nonVisitorTimestamp, timestamp, "Timestamp should remain unchanged");
    }

    function testUpdateMuseum() public {
        address newMuseum = address(0x123456789);
        (bool success, ) = collection.updateMuseum.call(newMuseum);
        assertEq(success, false, "Non-owner should not be able to update museum address");

        collection.updateMuseum(newMuseum);

        assertEq(collection.museum(), newMuseum, "Museum address not updated");
    }

    function testUpdateName() public {
        string memory newName = "New Collection Name";
        (bool success, ) = collection.updateName.call(newName);
        assertEq(success, false, "Non-owner should not be able to update collection name");

        collection.updateName(newName);

        assertEq(collection.name(), newName, "Collection name not updated");
    }

    function testUpdateDecimals() public {
        uint8 newDecimals = 10;
        (bool success, ) = collection.updateDecimals.call(newDecimals);
        assertEq(success, false, "Non-owner should not be able to update decimals");

        collection.updateDecimals(newDecimals);

        assertEq(collection.decimals(), newDecimals, "Decimals not updated");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";
import "./IVisitable.sol";

contract CollectionImpl is Initializable, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private museums;
    string public name;
    uint8 public decimals; // Used when the origami is integer based
    uint256 public version;
    uint256 public counter;

    struct OrigamiItem {
        uint256 data; // TODO: Default implementation is a uint256, change this and deploy for different data types, also requires changing other methods
        uint256 timestamp;
    }

    mapping(uint256 => OrigamiItem) private origami;

    event Origami(uint256 indexed _data);
    event AttachMuseum(address indexed _museum);
    event DetachMuseum(address indexed _museum);
    event UpdateName(string _name);
    event UpdateDecimals(uint8 _decimals);
    event UpdateVersion(uint256 _version);

    function initialize(address _museum, address _curator, string memory _name, uint8 _decimals, uint256 _version) initializer public {
        require(_museum != address(0), "Invalid museum address");
        require(_curator != address(0), "Invalid curator address");
        require(_version > 0);
        museums.add(_museum);
        _transferOwnership(_curator);
        name = _name;
        decimals = _decimals;
        version = _version;
    }

    function visit() public view onlyVisitor returns (uint256 data, uint256 timestamp) {
        return (origami[counter - 1].data, origami[counter - 1].timestamp);
    }

    function visit(uint256 _index) public view onlyVisitor returns (uint256 data, uint256 timestamp) {
        return (origami[_index].data, origami[_index].timestamp);
    }

    function curator() public view returns (address) {
        return owner();
    }

    function curate(uint256 _data) public onlyOwner {
        origami[counter] = OrigamiItem(_data, block.timestamp);
        counter += 1;
        emit Origami(_data);
    }

    function museum(uint256 _index) public view returns (address) {
        return museums.at(_index);
    }

    function attachMuseum(address _museum) public onlyOwner {
        require(_museum != address(0), "Invalid museum address");
        require(museums.length <= 10, "No more than 10 museums allowed"); // TBD: Decide what this should be
        museums.add(_museum);
        emit AttachMuseum(_museum);
    }

    function detachMuseum(address _museum) public onlyOwner {
        require(_museum != address(0), "Invalid museum address");
        museums.remove(_museum);
        emit DetachMuseum(_museum);
    }

    function museumCount() public view returns (uint256) {
        return museums.length();
    }

    function updateName(string memory _name) public onlyOwner {
        name = _name;
        emit UpdateName(_name);
    }

    function updateDecimals(uint8 _decimals) public onlyOwner {
        decimals = _decimals;
        emit UpdateDecimals(_decimals);
    }

    function updateVersion(uint256 _version) public onlyOwner {
        version = _version;
        emit UpdateVersion(_version);
    }

    modifier onlyVisitor {
        if (msg.sender != owner()) {
            bool found = false;
            for (uint256 i = 0; i < museums.length(); i++) {
                if (IVisitable(museums.at(i)).hasVisitor(msg.sender)) {
                    found = true;
                    break;
                }
            }
            require(found, "Invalid visitor address");
        }
        _;
    }

    // Supporting ChainLink Aggregator Interface
    function getRoundData(uint80 _roundId)
    external
    view
    onlyVisitor
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        (uint256 data, uint256 timestamp) = visit(uint256(_roundId));
        return (_roundId, data, timestamp, timestamp, _roundId);
    }

    function latestRoundData()
    external
    view
    onlyVisitor
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        (uint256 data, uint256 timestamp) = visit();
        return (uint80(counter - 1), data, timestamp, timestamp, uint80(counter - 1));
    }

    function description() public view returns (string memory) {
        return name;
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@solady/utils/SSTORE2.sol";
import "@zeppelin/proxy/utils/Initializable.sol";

import "./interfaces/IMuseum.sol";
import "./interfaces/IVisitor.sol";
import "./interfaces/AggregatorV2V3Interface.sol";


contract Collection is Initializable, IVisitor, AggregatorV2V3Interface {
    address public museum;
    string public name;
    uint8 public decimals;
    uint256 public version;
    string public decode;
    bool public compatible;

    uint80 public roundCount;
    uint80 public lastRound;

    struct Round {
        address origami;
        uint256 timestamp;
    }

    mapping(uint80 => Round) public rounds;

    event CreateRound(uint80 _id);
    event UpdateMuseum(address indexed _oldMuseum, address indexed _newMuseum);
    event UpdateName(string _oldName, string _newName);
    event UpdateDecimals(uint8 _oldDecimals, uint8 _newDecimals);
    event UpdateVersion(uint256 _oldVersion, uint256 _newVersion);
    event UpdateDecode(string _oldDecode, string _newDecode);
    event UpdateCompatible(bool _oldCompatible, bool _newCompatible);

    constructor () {
        _disableInitializers();
    }

    function initialize(
        address _museum,
        string memory _name,
        uint8 _decimals,
        uint256 _version,
        string memory _decode,
        bool _compatible
    ) initializer external {
        require(_museum != address(0), "Collection: invalid museum address");
        require(_version > 0);
        require(bytes(_decode).length > 0);

        museum = _museum;
        name = _name;
        decimals = _decimals;
        version = _version;
        decode = _decode;
        compatible = _compatible;
    }

    function visit() external view returns (bytes memory _origami, uint256 _timestamp) {
        (_origami, _timestamp) = _visit(lastRound);
    }

    function visit(uint80 _roundId) external view returns (bytes memory _origami, uint256 _timestamp) {
        (_origami, _timestamp) = _visit(_roundId);
    }

    function _visit(uint80 _roundId) internal view returns (bytes memory _origami, uint256 _timestamp) {
        require(IMuseum(museum).hasVisitor(msg.sender), "Collection: invalid visitor address");
        require(_roundId <= lastRound, "Collection: invalid round id");
        Round memory _round = rounds[_roundId];
        _origami = SSTORE2.read(_round.origami);
        _timestamp = _round.timestamp;
    }

    function curate(uint80 _roundId, bytes calldata _data) external onlyCurator {
        require(_roundId > lastRound, "Collection: invalid round id");
        lastRound = _roundId;
        roundCount += 1;
        address _origami = SSTORE2.write(_data);
        rounds[_roundId] = Round(_origami, block.timestamp);
        emit CreateRound(_roundId);
    }

    function updateMuseum(address _newMuseum) external onlyAdmin {
        require(_newMuseum != address(0), "Collection: invalid museum address");
        address _oldMuseum = museum;
        museum = _newMuseum;
        emit UpdateMuseum(_oldMuseum, _newMuseum);
    }

    function updateName(string memory _newName) external onlyAdmin {
        string memory _oldName = name;
        name = _newName;
        emit UpdateName(_oldName, _newName);
    }

    function updateDecimals(uint8 _newDecimals) external onlyAdmin {
        uint8 _oldDecimals = decimals;
        decimals = _newDecimals;
        emit UpdateDecimals(_oldDecimals, _newDecimals);
    }

    function updateVersion(uint256 _newVersion) external onlyAdmin {
        require(_newVersion > 0);
        uint256 _oldVersion = version;
        version = _newVersion;
        emit UpdateVersion(_oldVersion, _newVersion);
    }

    function updateDecode(string memory _newDecode) external onlyAdmin {
        require(bytes(_newDecode).length > 0);
        string memory _oldDecode = decode;
        decode = _newDecode;
        emit UpdateDecode(_oldDecode, _newDecode);
    }

    function updateCompatible(bool _newCompatible) external onlyAdmin {
        bool _oldCompatible = compatible;
        compatible = _newCompatible;
        emit UpdateCompatible(_oldCompatible, _newCompatible);
    }

    function getRoundData(uint80 _id) external view returns (
        uint80 _roundId,
        int256 _answer,
        uint256 _startedAt,
        uint256 _updatedAt,
        uint80 _answeredInRound
    ) {
        require(compatible, "Collection: not compatible");
        (bytes memory _origami, uint256 _timestamp) = _visit(_id);
        (int256 _data) = abi.decode(_origami, (int256));
        return (_id, _data, _timestamp, _timestamp, _id);
    }

    function latestRoundData() external view returns (
        uint80 _roundId,
        int256 _answer,
        uint256 _startedAt,
        uint256 _updatedAt,
        uint80 _answeredInRound
    ) {
        require(compatible, "Collection: not compatible");
        (bytes memory _origami, uint256 _timestamp) = _visit(lastRound);
        (int256 _data) = abi.decode(_origami, (int256));
        return (lastRound, _data, _timestamp, _timestamp, lastRound);
    }

    function latestAnswer() external view returns (int256) {
        require(compatible, "Collection: not compatible");
        (bytes memory _origami,) = _visit(lastRound);
        (int256 _answer) = abi.decode(_origami, (int256));
        return _answer;
    }

    function latestTimestamp() external view returns (uint256) {
        require(compatible, "Collection: not compatible");
        (, uint256 _timestamp) = _visit(lastRound);
        return _timestamp;
    }

    function latestRound() external view returns (uint256) {
        require(compatible, "Collection: not compatible");
        return uint256(lastRound);
    }

    function getAnswer(uint256 _roundId) external view returns (int256) {
        require(compatible, "Collection: not compatible");
        (bytes memory _origami,) = _visit(uint80(_roundId));
        (int256 _answer) = abi.decode(_origami, (int256));
        return _answer;
    }

    function getTimestamp(uint256 _roundId) external view returns (uint256) {
        require(compatible, "Collection: not compatible");
        (, uint256 _timestamp) = _visit(uint80(_roundId));
        return _timestamp;
    }

    function description() public view returns (string memory) {
        return name;
    }

    modifier onlyAdmin {
        require(IMuseum(museum).hasAdmin(msg.sender), "Collection: invalid admin address");
        _;
    }

    modifier onlyCurator {
        require(IMuseum(museum).hasCurator(msg.sender), "Collection: invalid curator address");
        _;
    }
}

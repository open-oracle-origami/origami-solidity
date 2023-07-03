import "@openzeppelin/Ownable.sol";

contract Collection is Ownable {
    string public name;
    uint8 public decimals; // Used when the origami is integer based
    uint256 public counter;

    struct OrigamiItem {
        uint256 data; // TODO: Default implementation is a uint256, change this and deploy for different data type
        uint256 timestamp;
    }

    mapping(uint256 => OrigamiItem) private origami;

    event Origami(uint256 indexed _data);

    constructor(uint8 _decimals) {
        decimals = _decimals;
    }

    function curate(uint256 _data) public onlyOwner {
        origami[counter] = OrigamiItem(_data, block.timestamp);
        counter = counter + 1;
        emit Origami(_data);
    }

    function visit() public view onlyVisitor returns (uint256, uint256) {
        return origami[counter];
    }

    function visit(uint256 _index) public view onlyVisitor returns (uint256, uint256) {
        return origami[_index];
    }
}

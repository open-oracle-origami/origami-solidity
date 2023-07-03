/*
    TODO:
        Make upgradeable?
        Make contract proxy for compatability with AggregatorV3 ChainLink for Drop In Replacement IE: pass it this address and a collection
*/
import "@openzeppelin/Ownable.sol";

contract OrigamiBeacon is Ownable {

    mapping(string => uint256) private counter;
    mapping(string => mapping (uint256 => Origami)) private origami;

    event Curated(string indexed _collection, uint256 indexed _data);

    constructor(string memory _name) {

    }

    modifier onlyVisitor {
        // By default this is open to all
        _;
    }

    function curate(string memory _collection, uint256 _data) public onlyOwner {
        origami[counter[_collection]] = Origami(_collection, _data, block.timestamp);
        counter[_collection] = counter[_collection] + 1;
        emit Collected(_collection, _data);
    }

    function visit(string memory _collection) public view onlyVisitor returns (Origami[] memory) {
        return origami[_blocknumber];
    }

    function visit(string memory _collection, uint256 _blockNumber) public view onlyVisitor returns (Origami[] memory) {
        return origami[_blockNumber];
    }
}
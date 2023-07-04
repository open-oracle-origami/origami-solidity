// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./IVisitable.sol";

contract CollectionImpl is Initializable, Ownable {
    IVisitable public museum;
    string public name;
    uint8 public decimals; // Used when the origami is integer based
    uint256 public counter;

    struct OrigamiItem {
        uint256 data; // TODO: Default implementation is a uint256, change this and deploy for different data type
        uint256 timestamp;
    }

    mapping(uint256 => OrigamiItem) private origami;

    event Origami(uint256 indexed _data);

    function initialize(address _museum, address _curator, string memory _name, uint8 _decimals) initializer public {
        require(_museum != address(0), "Invalid museum address");
        require(_curator != address(0), "Invalid curator address");
        museum = IVisitable(_museum);
        _transferOwnership(_curator);
        name = _name;
        decimals = _decimals;
    }

    function visit() public view onlyVisitor returns (uint256, uint256) {
        return origami[counter];
    }

    function visit(uint256 _index) public view onlyVisitor returns (uint256, uint256) {
        return origami[_index];
    }

    function curator() public view virtual returns (address) {
        return owner();
    }

    function curate(uint256 _data) public onlyOwner {
        origami[counter] = OrigamiItem(_data, block.timestamp);
        counter += 1;
        emit Origami(_data);
    }

    function updateMuseum(address _museum) public onlyOwner {
        require(_museum != address(0), "Invalid museum address");
        museum = IVisitable(_museum);
    }

    function updateName(string memory _name) public onlyOwner {
        name = _name;
    }

    function updateDecimals(uint8 _decimals) public onlyOwner {
        decimals = _decimals;
    }

    modifier onlyVisitor {
        require(museum.hasVisitor(msg.sender), "Address does not have visitation rights");
        _;
    }
}

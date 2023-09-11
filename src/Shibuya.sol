// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@solady/auth/Ownable.sol";
import "@zeppelin/proxy/Clones.sol";

import "./interfaces/IConfig.sol";


contract Shibuya is Ownable, IConfig {
    uint16 public tax;
    address public treasury;
    address public museumImpl;
    address public collectionImpl;

    uint256 public museumCount;
    mapping(uint256 => address) public museums;

    event Museum(address indexed _museum);
    event UpdateTax(uint16 _oldTax, uint16 _newTax);
    event UpdateTreasury(address indexed _oldTreasury, address indexed _newTreasury);
    event UpdateMuseumImpl(address indexed _oldMuseumImpl, address indexed _newMuseumImpl);
    event UpdateCollectionImpl(address indexed _oldCollectionImpl, address indexed _newCollectionImpl);

    constructor(uint16 _tax, address _treasury, address _museumImpl, address _collectionImpl) {
        require(_treasury != address(0), "Shibuya: invalid treasury address");
        require(_museumImpl != address(0), "Shibuya: invalid museumImpl address");
        require(_collectionImpl != address(0), "Shibuya: invalid collectionImpl address");
        tax = _tax;
        treasury = _treasury;
        museumImpl = _museumImpl;
        collectionImpl = _collectionImpl;

        _initializeOwner(msg.sender);
    }

    function createMuseum(string memory _name) external returns (address _museum) {
        _museum = _createMuseum(msg.sender, msg.sender, _name, 0);
    }

    function createMuseum(string memory _name, uint256 _valuePerBlockFee) external returns (address _museum) {
        _museum = _createMuseum(msg.sender, msg.sender, _name, _valuePerBlockFee);
    }

    function createMuseum(address _admin, address _curator, string memory _name, uint256 _valuePerBlockFee) external returns (address _museum) {
        _museum = _createMuseum(_admin, _curator, _name, _valuePerBlockFee);
    }

    function _createMuseum(address _admin, address _curator, string memory _name, uint256 _valuePerBlockFee) internal returns (address _museum) {
        bytes memory _data = abi.encodeWithSignature(
            "initialize(address,address,address,string,uint256)",
            _admin,
            _curator,
            address(this),
            _name,
            _valuePerBlockFee
        );
        bytes32 _salt = keccak256(abi.encodePacked(
            msg.sender,
            address(this),
            _name,
            _valuePerBlockFee
        ));
        _museum = Clones.cloneDeterministic(museumImpl, _salt);
        (bool _success,) = _museum.call(_data);
        require(_success, "Shibuya: failed to initialize museum");
        museums[museumCount] = _museum;
        museumCount += 1;
        emit Museum(_museum);
    }

    function updateTax(uint16 _newTax) external onlyOwner {
        require(_newTax != tax, "Shibuya: same tax");
        uint16 _oldTax = tax;
        tax = _newTax;
        emit UpdateTax(_oldTax, _newTax);
    }

    function updateTreasury(address _newTreasury) external onlyOwner {
        require(_newTreasury != address(0), "Shibuya: invalid treasury address");
        address _oldTreasury = treasury;
        treasury = _newTreasury;
        emit UpdateTreasury(_oldTreasury, _newTreasury);
    }

    function updateMuseumImpl(address _newMuseumImpl) external onlyOwner {
        require(_newMuseumImpl != address(0), "Shibuya: invalid museumImpl address");
        address _oldMuseumImpl = museumImpl;
        museumImpl = _newMuseumImpl;
        emit UpdateMuseumImpl(_oldMuseumImpl, _newMuseumImpl);
    }

    function updateCollectionImpl(address _newCollectionImpl) external onlyOwner {
        require(_newCollectionImpl != address(0), "Shibuya: invalid collectionImpl address");
        address _oldCollectionImpl = collectionImpl;
        collectionImpl = _newCollectionImpl;
        emit UpdateCollectionImpl(_oldCollectionImpl, _newCollectionImpl);
    }
}

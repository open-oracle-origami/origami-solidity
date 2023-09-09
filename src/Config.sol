contract Config {
    address public shibuya;
    address public museumImpl;
    address public collectionImpl;

    constructor(address _shibuya, address _museumImpl, address _collectionImpl) {
        require(_shibuya != address(0), "Config: invalid shibuya address");
        require(_museumImpl != address(0), "Config: invalid museumImpl address");
        require(_collectionImpl != address(0), "Config: invalid collectionImpl address");
        shibuya = _shibuya;
        museumImpl = _museumImpl;
        collectionImpl = _collectionImpl;
    }
}

abstract contract Configurable {
    Config public config;

    constructor(address _config) {
        require(_config != address(0), "Configurable: invalid config address");
        config = _config;
    }
}

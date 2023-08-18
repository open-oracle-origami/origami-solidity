// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol";

import "./BLS.sol";

abstract contract BLSOwnableUpgradeable is Initializable, EIP712Upgradeable {
    bytes32 constant public EIP712_TRANSFER_OWNER = keccak256("TransferOwnership(uint256[4] newOwner)");
    uint256[4] public blsPublicKey;

    error InvalidPublicKey(uint256[4] blsPublicKey);
    error InvalidSignature(bytes32 message, uint256[2] signature);

    // solhint-disable-next-line func-name-mixedcase
    function __BLSOwnable_init(string memory eip712Name, string memory eip712Version, uint256[4] memory _blsPublicKey) internal onlyInitializing {
        __EIP712_init(eip712Name, eip712Version);
        _transferOwnership(_blsPublicKey);
    }

    /**
    * @dev Transfer ownership of the contract to a new bls public key
    * @param _blsPublicKey The new owner bls public key
    * @param _blsSignature The BLS signature, signed by the old public key
    *
    * The following message must be signed:
    * `keccak256(abi.encode(EIP712_TRANSFER_OWNER, blsPublicKey_))`
    */
    function transferOwnership(uint256[4] memory _blsPublicKey, uint256[2] memory _blsSignature) public virtual {
        bytes32 digest = keccak256(abi.encode(
            EIP712_TRANSFER_OWNER,
            _blsPublicKey
        ));
        requireMessageVerified(digest, _blsSignature); 
        _transferOwnership(_blsPublicKey);
    }

    /**
    * @dev Verifies that the message was signed by the owner bls public key
    * @dev Throws if the message is not signed by the owner bls public key
    * @param messageDigest The message digest
    * @param _blsSignature The BLS signature
    *
    * It is recommended to hash the message in the following way:
    * ```solidity
    * bytes32 digest = keccak256(abi.encode(
    *   keccak256("SomeMessage(uint256 foo)"),
    *   foo
    * ));
    * ```
    */
    function requireMessageVerified(bytes32 messageDigest, uint256[2] memory _blsSignature) public virtual view {
        uint256[2] memory point = BLS.hashToPoint(blsDomain(), bytes.concat(messageDigest));
        (bool spCheck, bool sigCheck) = BLS.verifySingle(
            _blsSignature,
            blsPublicKey,
            point
        );
        if (!spCheck || !sigCheck) {
            revert InvalidSignature(messageDigest, _blsSignature);
        }
    }

    /**
    * @dev returns the bls domain that must be used for signing messages for this contract
    */
    function blsDomain() public virtual view returns (bytes32) {
        return _domainSeparatorV4();
    }

    function _transferOwnership(uint256[4] memory _blsPublicKey) internal {
        if (!BLS.isOnCurveG2(_blsPublicKey)) {
            revert InvalidPublicKey(_blsPublicKey);
        }
        blsPublicKey = _blsPublicKey;
    }

    function decodeAuthority(bytes memory _authorityRaw) internal pure returns (uint256[4] memory) {
        return abi.decode(_authorityRaw, (uint256[4]));
    }

    function decodeProof(bytes memory _proofRaw) internal pure returns (uint256[2] memory) {
        return abi.decode(_proofRaw, (uint256[2]));
    }
}
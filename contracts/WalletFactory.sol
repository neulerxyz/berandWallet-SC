// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

import "./WalletImp.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract WalletFactory {
    address public implementation;

    event WalletCreated(address wallet);
    event WalletCreatedViaRelayer(address wallet, address owner, address proxy);

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function createWallet(address _owner) external returns (address) {
        address clone = Clones.clone(implementation);
        WalletImp(clone).initialize(_owner);
        emit WalletCreated(clone);
        return clone;
    }

    // Create wallet for relayer interaction
    function createWalletViaRelayer(address _owner, address _relayerAccount, address _proxyAccount, uint256 salt, bytes memory _ownerSignature) external returns (address) {
        require(_owner != address(0), "Invalid owner address");
        require(_relayerAccount != address(0), "Relayer cannot be zero address");
        require(_proxyAccount != address(0), "Proxy cannot be zero address");
        bytes32 messageHash = keccak256(abi.encodePacked("createWalletViaRelayer", _owner, _relayerAccount, _proxyAccount, salt));
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(messageHash);
        address recoveredAddress = ECDSA.recover(ethSignedMessageHash, _ownerSignature);
        require(recoveredAddress == _owner, "Invalid signature");

        address clone = Clones.clone(implementation); // Create wallet clone
        WalletImp(clone).initializeWithRelayerAndProxy(_owner, _relayerAccount, _proxyAccount); // Initialize with relayer and proxy
        emit WalletCreatedViaRelayer(clone, _owner, _proxyAccount);
        return clone;
    }
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

import "./interfaces/IWalletImp.sol";
import "./interfaces/INFTMintable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract WalletImp is Initializable, OwnableUpgradeable, IWalletImp {
    uint256 public nonce; // Nonce for replay protection
    address public rewardAddress;
    address public proxyAccount;
    address public relayerAccount;

    event ProxyAssigned(address indexed proxyAccount);
    event RelayerAssigned(address indexed relayerAccount);
    event RewardAddressUpdated(address indexed newRewardAddress);
    event RewardsClaimed(address indexed rewardAddress, uint256 amount);
    event ExecutedTransaction(address indexed target, uint256 value, bytes data);
    event SignatureVerificationFailed(address recoveredAddress, address expectedAddress);

    modifier onlyProxy() {
        require(msg.sender == proxyAccount, "Only proxy can call this function");
        _;
    }

    modifier onlyRelayer() {
        require(msg.sender == relayerAccount, "Only relayer can call this function");
        _;
    }

    // Initialize function is used when proxy clones are deployed by the factory
    function initialize(address _owner) public initializer {
        require(_owner != address(0), "Invalid owner address");
        __Ownable_init(_owner); // Initialize the OwnableUpgradeable logic
        rewardAddress = address(0); // Set default reward address to zero
        nonce = 0; // Initialize nonce
    }

    // Initialize function for relayer-based initialization
    function initializeWithRelayerAndProxy(address _owner, address _relayerAccount, address _proxyAccount) public initializer {
        require(_owner != address(0), "Invalid owner address");
        require(_relayerAccount != address(0), "Relayer cannot be zero address");
        require(_proxyAccount != address(0), "Proxy cannot be zero address");
        __Ownable_init(_owner); // Initialize the OwnableUpgradeable logic
        // Set relayer and proxy accounts
        relayerAccount = _relayerAccount;
        proxyAccount = _proxyAccount;
        rewardAddress = address(0); // Set default reward address to zero
        nonce = 0; // Initialize nonce
    }

    // #region Role Management
    function assignProxyAccount(address _proxyAccount) external override onlyOwner {
        require(_proxyAccount != address(0), "Proxy cannot be zero address");
        proxyAccount = _proxyAccount;
        emit ProxyAssigned(_proxyAccount);
    }

    function revokeProxyAccount() external override onlyOwner {
        proxyAccount = address(0);
        emit ProxyAssigned(address(0));
    }

    function assignRelayerAccount(address _relayerAccount) external override onlyOwner {
        require(_relayerAccount != address(0), "Relayer cannot be zero address");
        relayerAccount = _relayerAccount;
        emit RelayerAssigned(_relayerAccount);
    }

    function revokeRelayerAccount() external override onlyOwner {
        relayerAccount = address(0);
        emit RelayerAssigned(address(0));
    }
    // #endregion

    function mintFromNFTViaRelayer(address nftContract, string memory secretMessage, uint256 _nonce, uint256 salt, bytes memory _proxySignature) external override onlyRelayer{
        require(nftContract != address(0), "invalid nft contract");
        require(_nonce == nonce, "Invalid nonce");
        // Construct the message to be signed by the owner
        bytes32 messageHash = keccak256(abi.encodePacked("mintFromNFTViaRelayer",nftContract,secretMessage,_nonce,salt));
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(messageHash);
        address recoveredAddress = ECDSA.recover(ethSignedMessageHash, _proxySignature);
        if (recoveredAddress != proxyAccount) {
            emit SignatureVerificationFailed(recoveredAddress, proxyAccount);
            revert("Invalid signature");
        }
        INFTMintable(nftContract).mintWish(secretMessage);
        nonce++;
    }
    
    function mintFromNFT(address nftContract,string memory secretMessage ) external override onlyOwner{
        require(nftContract != address(0), "invalid nft contract");
        INFTMintable(nftContract).mintWish(secretMessage);
    }

    // #region Reward Management
    function setRewardAddress(address _rewardAddress) external override onlyOwner {
        require(_rewardAddress != address(0), "Reward address cannot be zero address");
        rewardAddress = _rewardAddress;
        emit RewardAddressUpdated(_rewardAddress);
    }

    function claimRewards() external override onlyOwner {
        require(rewardAddress != address(0), "Reward address not set");
        uint256 balance = address(this).balance;
        require(balance > 0, "No rewards to claim");
        (bool success, ) = rewardAddress.call{value: balance}("");
        require(success, "Transfer failed");
        emit RewardsClaimed(rewardAddress, balance);
    }
    // #endregion
}

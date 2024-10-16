// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

interface IWalletImp {
    function assignProxyAccount(address _proxyAccount) external;
    function revokeProxyAccount() external;
    function assignRelayerAccount(address _relayerAccount) external;
    function revokeRelayerAccount() external;
    function mintFromNFTViaRelayer(address nftContract, string memory secretMessage, uint256 _nonce, uint256 salt, bytes memory _proxySignature) external;
    function mintFromNFT(address nftContract,string memory secretMessage ) external;
    function setRewardAddress(address _rewardAddress) external;
    function claimRewards() external;

}
# BerandWallet-SC: On-Chain Smart Contracts for Berand Extension

This repository contains the on-chain smart contracts that power **Berand**. The smart contracts handle the creation of smart contract wallets (SCWallets), facilitating gas-efficient wallet generation and automated NFT campaigns.

## Smart Contracts

### 1. WalletImp.sol
- **WalletImp** is the main smart contract for the Berand Wallet.
- It includes off-chain relayer capacity, enabling the **gasless creation** of SCWallets. Users can generate wallets without incurring gas fees, thanks to the off-chain relayer system.
- This contract acts as the implementation contract in the Berand wallet architecture. 

### 2. WalletFactory.sol
- **WalletFactory** is a proxy contract used to generate BerandWallets with minimal gas consumption.

### 3. DemoNFT.sol
- **DemoNFT** is a sample NFT contract used for promoting NFT campaigns.

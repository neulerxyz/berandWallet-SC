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


## Deployed contracts  
[WalletImp - v0](https://bartio.beratrail.io/address/0xe44588c03F97254294F1Bc1835139bbcc43E647f)  
[WalletFactory - v0](https://bartio.beratrail.io/address/0xe439C9695a82E94f008E69a12bE7052105790a99)  
[Berappucino - Demo Campaign NFT](https://bartio.beratrail.io/address/0x59F37b7E4764635C14B4CbCa97e07baAB9eF29F9)

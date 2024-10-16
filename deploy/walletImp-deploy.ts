import { ethers, upgrades } from "hardhat";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const [deployer] = await ethers.getSigners();
    const deployerBalance = await ethers.provider.getBalance(deployer.address);
    console.log("Deployer Address:", deployer.address);
    console.log("Deployer Balance:", ethers.formatEther(deployerBalance), "Bera");
    
    const WalletImplementation = await ethers.getContractFactory("WalletImp");
    const WalletImp = await WalletImplementation.deploy();
    await WalletImp.waitForDeployment();
    console.log("WalletImp deployed at:", WalletImp.target);
    console.log("Transaction Hash (WalletImp):", WalletImp.deploymentTransaction()?.hash);

	const WalletFactory = await ethers.getContractFactory("WalletFactory");
	const Wallet = await WalletFactory.deploy(WalletImp.target);
	await Wallet.waitForDeployment();
    console.log("Wallet deployed at:", Wallet.target);
    console.log("Transaction Hash (WalletFactory):", Wallet.deploymentTransaction()?.hash);


    const maxSupply = 100;
    const DemoNFT = await ethers.getContractFactory("DemoNFT");
	const DNFT = await DemoNFT.deploy(maxSupply);
	await DNFT.waitForDeployment();
    console.log("DNFT Token deployed at:", DNFT.target);
    console.log("Transaction Hash (DemoNFT):", DNFT.deploymentTransaction()?.hash);
}
export default func;
func.tags = ["WalletDeploy"];

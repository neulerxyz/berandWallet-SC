import { ethers, upgrades } from "hardhat";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const [deployer] = await ethers.getSigners();

	const WalletFactory = await ethers.getContractFactory("WalletFactory");
	const Wallet = await WalletFactory.deploy("0x7B5118fD5c6480f4b29B95EE63ba4c3F33e4F3dD");
	await Wallet.waitForDeployment();
    console.log("Wallet deployed at:", Wallet.target);

}
export default func;
func.tags = ["FactoryDeploy"];

import { ethers, upgrades } from "hardhat";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const { keccak256, toUtf8Bytes } = ethers;

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
    console.log("WalletFactory deployed at:", Wallet.target);
    console.log("Transaction Hash (WalletFactory):", Wallet.deploymentTransaction()?.hash);

    // const maxSupply = 100;
    // const benefit = "free latte";
    // const owner = deployer.address;
    // const redemptionProcess = "Present your NFT at the coffee shop and scan the QR code to claim your free latte.";
    // const expirationTimestamp = Math.floor(new Date("2024-12-31").getTime() / 1000); // End of this year as a Unix timestamp
    // const terms = "one NFT per user";
    // const coupon = keccak256(toUtf8Bytes("giveMeAFreeDrinkBera"));  // Hash of the secret message

    // // Deploying the DemoNFT contract
    // const DemoNFT = await ethers.getContractFactory("DemoNFT");
    // const DNFT = await DemoNFT.deploy(
    //     maxSupply,
    //     benefit,
    //     owner,
    //     redemptionProcess,
    //     expirationTimestamp,
    //     terms,
    //     coupon
    // );

    // console.log("DemoNFT deployed to:", DNFT.target);
}
export default func;
func.tags = ["WalletDeploy"];

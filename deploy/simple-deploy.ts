import { ethers } from "hardhat";

async function main() {
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // // Get the contract factory for SimpleContract
  // const SimpleContract = await ethers.getContractFactory("DemoNFT");

  // // Deploy the contract
  // const simpleContract = await SimpleContract.deploy(100);

  // // Wait for the contract deployment to complete
  // await simpleContract.waitForDeployment();
  // Log the deployed contract address
  //console.log("SimpleContract deployed at:", simpleContract.target);
  
  const maxSupply = 100;
  const DemoNFT = await ethers.getContractFactory("DemoNFT");
	const DNFT = await DemoNFT.deploy(maxSupply);
	await DNFT.waitForDeployment();
  console.log("DNFT Token deployed at:", DNFT.target);
  console.log("Transaction Hash (DemoNFT):", DNFT.deploymentTransaction()?.hash);

  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

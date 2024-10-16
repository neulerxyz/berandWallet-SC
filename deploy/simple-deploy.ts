import { ethers } from "hardhat";

const { keccak256, toUtf8Bytes } = ethers;

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
  const benefit = "free latte";
  const owner = deployer.address;
  const redemptionProcess = "Present your NFT at the coffee shop and scan the QR code to claim your free latte.";
  const expirationTimestamp = Math.floor(new Date("2024-12-31").getTime() / 1000); // End of this year as a Unix timestamp
  const terms = "one NFT per user";
  const coupon = keccak256(toUtf8Bytes("giveMeAFreeDrinkBera"));  // Hash of the secret message

  // Deploying the DemoNFT contract
  const DemoNFT = await ethers.getContractFactory("DemoNFT");
  const DNFT = await DemoNFT.deploy(
      maxSupply,
      benefit,
      owner,
      redemptionProcess,
      expirationTimestamp,
      terms,
      coupon
  );

  console.log("DemoNFT deployed to:", DNFT.target);
  console.log("DNFT Token deployed at:", DNFT.target);
  console.log("Transaction Hash (DemoNFT):", DNFT.deploymentTransaction()?.hash);

  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-deploy";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
};

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {},
    berachainbArtio: {
      url: process.env.RPC_URL || "",
      chainId: Number(process.env.CHAIN_ID),
      accounts:
        process.env.WALLET_PRIVATE_KEY !== undefined ? [process.env.WALLET_PRIVATE_KEY] : [],
    }
  },
  etherscan: {
    apiKey: {
      // Is not required by blockscout. Can be any non-empty string
      berachainbArtio: process.env.BLOCK_EXPLORER_API_KEY,
    },
    customChains: [
      {
        network: process.env.NETWORK_NAME,
        chainId: Number(process.env.CHAIN_ID),
        urls: {
          apiURL: process.env.BLOCK_EXPLORER_API_URL,
          browserURL: process.env.BLOCK_EXPLORER_URL,
        }
      }
    ]
  },
  sourcify: {
    enabled: false,
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 40000,
  },
  gasReporter: {
    enabled: true,
    excludeContracts: ["mocks", "tests"],
    include: ["../node_module/@openzeppelin/contracts-upgradeable"],
  },
};
export default config;

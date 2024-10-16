const { ethers } = require("ethers");

async function interactWithContract() {
    const provider = new ethers.JsonRpcProvider("https://bartio.rpc.berachain.com");

    // Address of the deployed contract
    const contractAddress = "0x8C9ADa27E05199ADeD706711e5f79b8C3ca7cc04";

    // Contract ABI (since it's a simple contract, we only need to read the `contractAddress` variable)
    const abi = [
        "function contractAddress() public view returns (address)"
    ];

    // Create a contract instance
    const contract = new ethers.Contract(contractAddress, abi, provider);

    // Call the contract to get its own stored address
    const address = await contract.contractAddress();
    console.log("Stored contract address:", address);
}

interactWithContract();

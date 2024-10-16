const { ethers } = require("ethers");

async function checkContractCode() {
    const provider = new ethers.JsonRpcProvider("https://bartio.rpc.berachain.com");
    const contractAddress = "0x8C9ADa27E05199ADeD706711e5f79b8C3ca7cc04"; // Replace with your contract address

    // Fetch the code at the contract address
    const code = await provider.getCode(contractAddress);

    if (code === "0x") {
        console.log("No contract deployed at this address.");
    } else {
        console.log("Contract code exists at this address.");
        console.log("Contract Bytecode:", code);
    }
}

checkContractCode();

//0x1db024FBd0edF0157D733be089cF56b3E7DE1fb1
//0x5d3A4239886BBe5cD3563a5bc9C8EdF6C8a9C493
//0xa0fB7CD514fA5A53dFEd9a9133438B5377CfF755
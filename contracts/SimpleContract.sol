// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleContract {
    // A public state variable to store the contract's own address
    address public contractAddress;

    // Constructor to initialize the contract address upon deployment
    constructor() {
        contractAddress = address(this);
    }
}

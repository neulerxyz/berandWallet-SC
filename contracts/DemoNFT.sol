// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/INFTMintable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DemoNFT is ERC721, INFTMintable {
    uint256 public nextTokenId;  // This keeps track of the next token ID to mint
    uint256 public maxSupply;
    mapping(address => bool) public hasMinted;

    constructor(uint256 _maxSupply) ERC721("DemoNFT", "DNFT") {
        maxSupply = _maxSupply;
    }

    // Implementing the mintNFT function from INFTMintable interface
    function mintNFT(address to) external override {
        require(!hasMinted[to], "Address has already minted");
        require(nextTokenId < maxSupply, "Max supply reached");

        // Mint the NFT with the current nextTokenId
        _mint(to, nextTokenId);  
        nextTokenId++;  // Increment tokenId for the next mint
        hasMinted[to] = true;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/INFTMintable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract DemoNFT is ERC721URIStorage, INFTMintable, Ownable {
    uint256 public nextTokenId;  // This keeps track of the next token ID to mint
    uint256 public maxSupply;
    mapping(address => bool) public hasMinted;
    bytes32 internal coupon;
    // Campaign-specific metadata
    struct Campaign {
        string benefit;
        string redemptionProcess;
        uint256 expirationTimestamp;
        string terms;
    }
    Campaign public campaign;

    event NFTMinted(address indexed to, uint256 tokenId, string tokenURI);
    event Redeemed(address indexed redeemer, uint256 tokenId);

    constructor(
        uint256 _maxSupply,
        string memory _benefit,
        address _owner,
        string memory _redemptionProcess,
        uint256 _expirationTimestamp,
        string memory _terms,
        bytes32 _coupon
    ) 
        ERC721("DemoNFT", "DNFT") 
        Ownable(_owner)
    {
        maxSupply = _maxSupply;
        campaign = Campaign({
            benefit: _benefit,
            redemptionProcess: _redemptionProcess,
            expirationTimestamp: _expirationTimestamp,
            terms: _terms
        });
        coupon = _coupon;
    }

    function mintNFT(address to) internal {
        require(!hasMinted[to], "Address has already minted");
        require(nextTokenId < maxSupply, "Max supply reached");
        _mint(to, nextTokenId);
        emit NFTMinted(to, nextTokenId, tokenURI(nextTokenId));
        nextTokenId++;
        hasMinted[to] = true;
    }

    function mintWish(string memory secretMessage) external override {
        require(keccak256(abi.encodePacked(secretMessage)) == coupon, "Invalid secret message");
        mintNFT(msg.sender);  // Mint if the hashes match
    }

    function redeem(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(block.timestamp < campaign.expirationTimestamp, "Campaign expired");
        _burn(tokenId);
        emit Redeemed(msg.sender, tokenId);
    }

    function updateCampaign(
        string memory _benefit,
        string memory _redemptionProcess,
        uint256 _expirationTimestamp,
        string memory _terms
    ) external onlyOwner {
        campaign.benefit = _benefit;
        campaign.redemptionProcess = _redemptionProcess;
        campaign.expirationTimestamp = _expirationTimestamp;
        campaign.terms = _terms;
    }
}

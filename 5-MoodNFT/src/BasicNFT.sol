// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 tokenId => string tokenURI) private s_tokenURIs;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function mint(string calldata tokenUri) external {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenURIs[s_tokenCounter] = tokenUri;
        ++s_tokenCounter;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenURIs[tokenId];
    }
}

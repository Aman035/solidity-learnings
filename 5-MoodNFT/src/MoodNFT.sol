// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/* Imports */
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    /* Errors */
    error MoodNFT__NonOwnerCannotFlipMood();
    
    /* Type Declarations */
    enum Mood {
        SAD,
        HAPPY
    }

    /* State Variables */
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    mapping(uint256 tokenId => Mood) private s_tokenIdToMood;

    /* Events */

    /* Modifiers */

    /* Constructor */
    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    /* External Functions */

    function mint() external {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        ++s_tokenCounter;
    }

    function flipMood(uint256 tokenId) external {
        if(ownerOf(tokenId) != msg.sender) {
            revert MoodNFT__NonOwnerCannotFlipMood();
        }
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    /* Internal Functions */

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /* Getters */

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_happySvgImageUri;

        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        }

        /**
         * 1. Create JSON metadata
         * 2. Base64 encode JSON metadata
         * 3. Concatenate baseURI + base64 encoded JSON metadata ( so it can be displayed in browser )
         * 4. Convert this whole bytes to string
         */

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    abi.encodePacked(
                        '{"name":"',
                        name(),
                        '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                        '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                        imageURI,
                        '"}'
                    )
                )
            )
        );
    }

    function getHappySvgImageUri() external view returns (string memory) {
        return s_happySvgImageUri;
    }

    function getSadSvgImageUri() external view returns (string memory) {
        return s_sadSvgImageUri;
    }

    function getTokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }
}

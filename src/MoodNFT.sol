//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    error MoodNFT__CannotChangeMoodSinceNowOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    string private s_freePalestineImageUri;

    enum Mood {
        HAPPY,
        SAD,
        FREEDOM
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri,
        string memory freePalestineImageUri
    ) ERC721("MoodNFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
        s_freePalestineImageUri = freePalestineImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.FREEDOM;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function changeMood(uint256 tokenId, uint256 newMood) public {
        if (
            !_isAuthorized(ownerOf(tokenId), msg.sender, tokenId) &&
            ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNFT__CannotChangeMoodSinceNowOwner();
        }

        s_tokenIdToMood[tokenId] = Mood(newMood);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        } else imageURI = s_freePalestineImageUri;

        return
            string(
                abi.encodePacked( // we could've been using string.concat() here instead of abi.encodePack()
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "A dynamic NFT.", "attributes": [{"trait type": "courage", "value": 100}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}

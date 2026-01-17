// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NftCollection is ERC721, Ownable {

    bool private _paused;
    uint256 private _tokenIdCounter;
    string private _baseTokenURI;

    constructor() ERC721("NftCollection", "NFTC") Ownable(msg.sender) {
        _paused = false;
        _tokenIdCounter = 0;
    }

    // =========================
    // Pause control
    // =========================

    function pauseMinting() external onlyOwner {
        _paused = true;
    }

    function unpauseMinting() external onlyOwner {
        _paused = false;
    }

    // =========================
    // Minting
    // =========================

    function mint(address to) external onlyOwner {
        require(!_paused, "Minting paused");
        require(to != address(0), "Zero address");

        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;

        _safeMint(to, tokenId);
    }

    // =========================
    // Metadata
    // =========================

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI_) external onlyOwner {
        _baseTokenURI = baseURI_;
    }

    // ❗ NO _exists CHECK NEEDED IN OZ v5
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return super.tokenURI(tokenId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract should implement ERC-721-compatible interface for NFTs
// It must track ownership, balances, approvals, and support safe transfers
contract NftCollection {

    // State variables:
    // string public name;
    // string public symbol;
    // uint256 public maxSupply;
    // uint256 public totalSupply;

    // Mappings:
    // tokenId => owner address
    // owner address => balance
    // tokenId => approved address
    // owner => operator approvals

    // =========================
    // Access control
    // =========================

    address private _admin;

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Not admin");
        _;
    }

    // =========================
    // Pause state
    // =========================

    bool private _paused;

    function pauseMinting() external onlyAdmin {
        _paused = true;
    }

    function unpauseMinting() external onlyAdmin {
        _paused = false;
    }

    // =========================
    // Metadata
    // =========================

    // Base URI for token metadata
    string private _baseTokenURI;

    // =========================
    // CONSTRUCTOR (IMPORTANT)
    // =========================

    constructor() {
        _admin = msg.sender;   // deployer becomes admin
        _paused = false;       // minting unpaused by default
    }

    // =========================
    // Optional metadata
    // =========================

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(tokenId > 0, "Token does not exist");

        return string(
            abi.encodePacked(_baseTokenURI, _uintToString(tokenId))
        );
    }

    function _uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

    // Internal helper functions for minting, transferring, approvals
}

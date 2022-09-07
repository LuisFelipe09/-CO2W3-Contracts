// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract BaseToken is ERC1155 {
    uint256 public constant NFT = 0;
    uint256 public constant FT = 1;

    /*        
        ERC1155 uri shows the metadata of the token, we should replice de {id} for 0 or 1
        [{
            "name": "NFT Token for the project",
            "description": "This represents the NFT"            
        },
        {
            "name": "Project name",
            "description": "This represents the NFT"
        }]

    */
    constructor(uint256 totalSupply, address _address, string memory _JSON_URL) ERC1155(_JSON_URL) {
        _mint(_address, FT, totalSupply, "");
        _mint(_address, NFT, 1, "");
    }
}
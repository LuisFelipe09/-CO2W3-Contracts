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
    // JSON_URL se recibe por parametro y se asigna al ERC1155
    constructor(uint256 totalSupply, address _address, string memory _JSON_URL) ERC1155(_JSON_URL) {
        // Se mintean los tokens fungibles y se envian al address asignada, en este caso msg.sender
        _mint(_address, FT, totalSupply, "");
        // Se mintea el NFT
        _mint(_address, NFT, 1, "");
    }
}
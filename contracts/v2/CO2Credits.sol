// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "./CO2Project.sol";
import "./CO2Certificate.sol";

contract CO2Credits is ERC1155, Ownable, ERC1155Supply, CO2Project {

    CO2Certificate private _certificado;

    constructor() ERC1155("") {
       _certificado = new CO2Certificate();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        internal
        override 
    {
        _mint(account, id, amount, data);
    }

    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal override {
        super._burn(from, id, amount);
        _certificado.safeMint(from);
    }
/*
    function createCertificate(uint256 id , uint256 amount)
    public 
    {
        _certificado.safeMint(msg.sender);
        safeTransferFrom(msg.sender, address(_certificado), id, amount, "");
    }
*/

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}

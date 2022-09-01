// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";

contract CO2W3 is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _projectIdCounter;

    mapping(uint256 => uint256) public tokenDNA;
    mapping(uint256 => uint256) public projectMaxSupply;
    mapping(uint256 => Counters.Counter) public projectIdCounter;

    constructor() ERC721("CO2W3", "CO2W3") {}

    function mint(uint256 id,uint256 companyId) public {
        uint256 currentToken = _tokenIdCounter.current();

        require(companyId == tokenDNA[id], "That project doesn't exists");

        uint256 currentProject = projectIdCounter[id].current();
        require(currentProject < projectMaxSupply[id], "No C02W3 available to this project");

        _safeMint(msg.sender, currentToken);
        projectIdCounter[id].increment();
        _tokenIdCounter.increment();
    }

    function createCharcoalProject(uint256 companyId, uint256 _maxSupply) public {
        uint256 currentProject = _projectIdCounter.current();

        projectMaxSupply[currentProject] = _maxSupply;
        tokenDNA[currentProject] = companyId; //Validate if there is necesary add deterministicPseudoRandomDNA
        _projectIdCounter.increment();
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721 Metada: URI query for nonexistent token"
        );

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{"name": "CO2W3 #',
                tokenId.toString(),
                '",  "description":"CO2W3 representa un bono de carbon emitido y verificado a su portador"}'
            )
        );

        return
            string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    //Override required from ERC721Enumerable.sol
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

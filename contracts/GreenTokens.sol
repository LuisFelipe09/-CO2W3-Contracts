// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./BaseToken.sol";

contract GreenTokens is AccessControl {

    bytes32 public constant ADMIN = keccak256("ADMIN");
    // PROJECT CREATOR
    bytes32 public constant CREATOR = keccak256("CREATOR");

    using Counters for Counters.Counter;
    Counters.Counter private _projectIdCounter;    

    struct Project {        
        string projectName;
        uint256 tokenSupply;
        address creator;
        BaseToken tokens; // Direction of the contract ERC1155
    }
        
    mapping(uint256 => Project) public project;

    constructor () {
        _grantRole(ADMIN, msg.sender);        
    }

    modifier onlyAdmin(){
        require( hasRole( ADMIN, msg.sender ), "Esta funcion solo puede ser utilizada por el ADMIN" );
        _;
    }

    modifier onlyCreator(){
        require( hasRole( CREATOR, msg.sender ), "Esta funcion solo puede ser utilizada por el CREATOR" );
        _;
     }

    function _addRoll(address account) public onlyAdmin() {        
        _grantRole(CREATOR, account);
    }

    function createProject(string memory _projectName, uint256 _tokenSupply, string memory _JSON_URL) public onlyCreator() returns (uint256) {

        uint256 currentToken = _projectIdCounter.current();
        BaseToken token = new BaseToken(_tokenSupply, msg.sender, _JSON_URL);
        project[currentToken] = Project(_projectName, _tokenSupply, msg.sender, token);
        _projectIdCounter.increment();
        
        return currentToken;
    }
}

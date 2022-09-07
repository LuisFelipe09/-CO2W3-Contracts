// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./BaseToken.sol";

contract GreenTokens is AccessControl {
    // Dos roles, el admin que es quien despliega el contrato, y quen da 
    // el roll de CREATOR para quien crea los proyectos
    bytes32 public constant ADMIN = keccak256("ADMIN");
    // PROJECT CREATOR
    bytes32 public constant CREATOR = keccak256("CREATOR");

    using Counters for Counters.Counter;
    Counters.Counter private _projectIdCounter;    

    // La estructura de un proyecto
    struct Project {        
        string projectName; // Nombre del proyecto
        uint256 tokenSupply; // Cantidad de bonos emitidos
        address creator; // Quien creo el proyecto
        BaseToken tokens; // Dirección del contrato ERC1155 desplegado dinamicamente
    }
    
    // Un mapping con un indice => struct del proyecto
    mapping(uint256 => Project) public project;

    constructor () {
        // Asignamos el roll ADMIN a quien desplego el contrato
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

    // Función para agregar roles de CREATOR
    function _addRoll(address account) public onlyAdmin() {        
        _grantRole(CREATOR, account);
    }

    /*
        La función createProject recibe los datos necesarios para la creación
        del proyecto y el despliegue del contrato ERC1155
    */
    function createProject(string memory _projectName, uint256 _tokenSupply, string memory _JSON_URL) public onlyCreator() returns (uint256) {

        // Proyecto actual
        uint256 currentToken = _projectIdCounter.current();
        // Creación dinamica del contrato ERC1155, supply, creator, JSON URL de la metadata
        BaseToken token = new BaseToken(_tokenSupply, msg.sender, _JSON_URL);
        // Asignación del indice del proyecto con el proyecto
        project[currentToken] = Project(_projectName, _tokenSupply, msg.sender, token);
        _projectIdCounter.increment();
        
        return currentToken;
    }
}

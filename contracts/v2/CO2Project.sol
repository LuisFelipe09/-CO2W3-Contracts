// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

contract CO2Project {
    using Counters for Counters.Counter;
    struct ProjectInfoRequest {
       address projectOwner; 
       uint256 amount;
    }

    event ProjectCreate(address indexed from, uint256 projectId, string indexed name, string jsonUri);

    event ApprovalForAll(uint256 indexed projectId, address indexed operator, bool approved);

     mapping(address => uint256) private _projects;
     mapping(uint256 => string) private _projectsname;
     mapping(uint256 => string) private _projectsURI;
     mapping(uint256 => mapping(address => bool)) private _operatorApprovals;
     mapping(uint256 => ProjectInfoRequest) private _pendingRequests;

     Counters.Counter private _projectIdCounter;

    function createProject(
      string memory name,
      string memory jsonUri
    ) public {
        require(msg.sender != address(0), "Project: address zero is not valid ");
        require(_projects[msg.sender] > 0 , "Project: The project exists");

        uint256 projectId = _projectIdCounter.current();
        _projectIdCounter.increment();
        _projects[msg.sender] = projectId;
        _projectsname[projectId] = name;
        _projectsURI[projectId] = jsonUri;

        emit ProjectCreate(msg.sender, projectId, name, jsonUri);
     }

     function setApprovalForAll(
        uint256 projectId,
        address operator,
        bool approved
    ) public  {
        require(_projects[msg.sender] > 0 , "Project: The project exists");

        _operatorApprovals[projectId][operator] = approved;

        emit ApprovalForAll(projectId, operator, approved);
    }

    function CreditsIssuanceRequest(uint256 amount) public
    {
        uint256 projectId = _projects[msg.sender];

        require(projectId > 0, "Project: No have a project registger");

        _pendingRequests[projectId] =  ProjectInfoRequest(msg.sender, amount);

    }

    function ApproveCreditIssuance(uint256 projectId) public {
        require( _operatorApprovals[projectId][msg.sender] , "Project: No permits for approval");
        require(_pendingRequests[projectId].amount > 0, "Project: No have amount for approve");

        ProjectInfoRequest memory projectInfoRequest = _pendingRequests[projectId];
        delete _pendingRequests[projectId];

        mint(projectInfoRequest.projectOwner, projectId, projectInfoRequest.amount, "");
    }

    function mint(
      address account,
      uint256 id, 
      uint256 amount, 
      bytes memory data
    ) internal  virtual {}
}

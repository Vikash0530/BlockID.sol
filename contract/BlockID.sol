// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BlockID
 * @dev A decentralized identity management system that allows users to register,
 * verify, and retrieve their digital identities securely on the blockchain.
 */
contract BlockID {
    struct Identity {
        string name;
        string email;
        bool isVerified;
    }

    mapping(address => Identity) private identities;
    address public owner;

    event IdentityRegistered(address indexed user, string name, string email);
    event IdentityVerified(address indexed user);
    event IdentityUpdated(address indexed user, string name, string email);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new identity
    function registerIdentity(string memory _name, string memory _email) public {
        require(bytes(identities[msg.sender].name).length == 0, "Identity already registered");
        identities[msg.sender] = Identity(_name, _email, false);
        emit IdentityRegistered(msg.sender, _name, _email);
    }

    /// @notice Verify a user identity (only owner can verify)
    function verifyIdentity(address _user) public onlyOwner {
        require(bytes(identities[_user].name).length > 0, "Identity not found");
        identities[_user].isVerified = true;
        emit IdentityVerified(_user);
    }

    /// @notice Retrieve a user identity
    function getIdentity(address _user) public view returns (string memory, string memory, bool) {
        Identity memory id = identities[_user];
        require(bytes(id.name).length > 0, "Identity not found");
        return (id.name, id.email, id.isVerified);
    }

    /// @notice Allow a user to update their own information
    function updateIdentity(string memory _name, string memory _email) public {
        require(bytes(identities[msg.sender].name).length > 0, "Identity not registered");
        identities[msg.sender].name = _name;
        identities[msg.sender].email = _email;
        emit IdentityUpdated(msg.sender, _name, _email);
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AccessController
/// @notice Simple role-based access control for YieldLoop / Veridic.
/// @dev This contract defines two roles:
///      - admin: can manage roles and critical configuration
///      - minter: can mint/burn LOOP (via LoopToken's onlyMinter)
contract AccessController {
    // ------------------------------------------------------------------------
    // Roles
    // ------------------------------------------------------------------------
    mapping(address => bool) private _admins;
    mapping(address => bool) private _minters;

    // ------------------------------------------------------------------------
    // Events
    // ------------------------------------------------------------------------
    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);
    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    // ------------------------------------------------------------------------
    // Modifiers
    // ------------------------------------------------------------------------
    modifier onlyAdmin() {
        require(_admins[msg.sender], "AccessController: not admin");
        _;
    }

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    /// @notice Deploy with an initial admin.
    /// @param initialAdmin The address granted admin rights at deployment.
    constructor(address initialAdmin) {
        require(initialAdmin != address(0), "AccessController: zero admin");
        _admins[initialAdmin] = true;
        emit AdminAdded(initialAdmin);
    }

    // ------------------------------------------------------------------------
    // View functions (for external contracts like LoopToken)
    // ------------------------------------------------------------------------

    /// @notice Returns true if `account` is an admin.
    function isAdmin(address account) external view returns (bool) {
        return _admins[account];
    }

    /// @notice Returns true if `account` is a minter.
    function isMinter(address account) external view returns (bool) {
        return _minters[account];
    }

    // ------------------------------------------------------------------------
    // Admin management
    // ------------------------------------------------------------------------

    /// @notice Add a new admin.
    /// @dev Only an existing admin can add another admin.
    function addAdmin(address account) external onlyAdmin {
        require(account != address(0), "AccessController: zero address");
        require(!_admins[account], "AccessController: already admin");
        _admins[account] = true;
        emit AdminAdded(account);
    }

    /// @notice Remove an admin.
    /// @dev An admin can remove another admin. Consider protecting against
    ///      removing the last admin in a production deployment.
    function removeAdmin(address account) external onlyAdmin {
        require(_admins[account], "AccessController: not admin");
        _admins[account] = false;
        emit AdminRemoved(account);
    }

    // ------------------------------------------------------------------------
    // Minter management
    // ------------------------------------------------------------------------

    /// @notice Grant minter role to an account (e.g., YieldLoopCore).
    function addMinter(address account) external onlyAdmin {
        require(account != address(0), "AccessController: zero address");
        require(!_minters[account], "AccessController: already minter");
        _minters[account] = true;
        emit MinterAdded(account);
    }

    /// @notice Revoke minter role from an account.
    function removeMinter(address account) external onlyAdmin {
        require(_minters[account], "AccessController: not minter");
        _minters[account] = false;
        emit MinterRemoved(account);
    }
}

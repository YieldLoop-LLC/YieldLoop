// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CycleRegistry
/// @notice Read-optimized registry for YieldLoop cycles, for use by frontends
///         and analytics tools.
/// @dev This contract is intentionally simple and separate from YieldLoopCore.
///      In a future integration, an authorized operator (or YieldLoopCore itself)
///      can call `registerCycle` and `updateCycleOnClose` to maintain an
///      easily queryable index of cycle summaries.
contract CycleRegistry {
    // ------------------------------------------------------------------------
    // Roles
    // ------------------------------------------------------------------------
    address public owner;
    mapping(address => bool) public operators; // addresses allowed to write

    // ------------------------------------------------------------------------
    // Data structures
    // ------------------------------------------------------------------------
    struct CycleSummary {
        address user;
        bytes32 cycleId;
        uint256 startTime;
        uint256 endTime;
        uint256 S;
        uint256 E;
        uint256 F;
        uint256 P_verified;
        bytes32 proofHash;
        bool closed;
    }

    // cycleId => summary
    mapping(bytes32 => CycleSummary) public cycles;

    // per-user index of cycleIds
    mapping(address => bytes32[]) private _userCycles;

    // ------------------------------------------------------------------------
    // Events
    // ------------------------------------------------------------------------
    event OwnerUpdated(address indexed newOwner);
    event OperatorUpdated(address indexed operator, bool allowed);
    event CycleRegistered(
        bytes32 indexed cycleId,
        address indexed user,
        uint256 startTime,
        uint256 S
    );
    event CycleUpdated(
        bytes32 indexed cycleId,
        uint256 endTime,
        uint256 E,
        uint256 F,
        uint256 P_verified,
        bytes32 proofHash
    );

    // ------------------------------------------------------------------------
    // Modifiers
    // ------------------------------------------------------------------------
    modifier onlyOwner() {
        require(msg.sender == owner, "CycleRegistry: not owner");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "CycleRegistry: not operator");
        _;
    }

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(address _owner) {
        require(_owner != address(0), "CycleRegistry: zero owner");
        owner = _owner;
        emit OwnerUpdated(_owner);
    }

    // ------------------------------------------------------------------------
    // Owner / operator management
    // ------------------------------------------------------------------------
    function setOwner(address _owner) external onlyOwner {
        require(_owner != address(0), "CycleRegistry: zero owner");
        owner = _owner;
        emit OwnerUpdated(_owner);
    }

    function setOperator(address op, bool allowed) external onlyOwner {
        operators[op] = allowed;
        emit OperatorUpdated(op, allowed);
    }

    // ------------------------------------------------------------------------
    // Write functions (for YieldLoopCore or external operator)
    // ------------------------------------------------------------------------

    /// @notice Register a new cycle when it starts.
    /// @dev Intended to be called by YieldLoopCore or a trusted bot.
    function registerCycle(
        bytes32 cycleId,
        address user,
        uint256 startTime,
        uint256 S
    ) external onlyOperator {
        require(user != address(0), "CycleRegistry: zero user");
        require(cycles[cycleId].user == address(0), "CycleRegistry: exists");

        CycleSummary memory summary = CycleSummary({
            user: user,
            cycleId: cycleId,
            startTime: startTime,
            endTime: 0,
            S: S,
            E: 0,
            F: 0,
            P_verified: 0,
            proofHash: bytes32(0),
            closed: false
        });

        cycles[cycleId] = summary;
        _userCycles[user].push(cycleId);

        emit CycleRegistered(cycleId, user, startTime, S);
    }

    /// @notice Update an existing cycle when it closes.
    /// @dev Intended to mirror data from YieldLoopCore.
    function updateCycleOnClose(
        bytes32 cycleId,
        uint256 endTime,
        uint256 E,
        uint256 F,
        uint256 P_verified,
        bytes32 proofHash
    ) external onlyOperator {
        CycleSummary storage summary = cycles[cycleId];
        require(summary.user != address(0), "CycleRegistry: unknown cycle");
        require(!summary.closed, "CycleRegistry: already closed");

        summary.endTime = endTime;
        summary.E = E;
        summary.F = F;
        summary.P_verified = P_verified;
        summary.proofHash = proofHash;
        summary.closed = true;

        emit CycleUpdated(cycleId, endTime, E, F, P_verified, proofHash);
    }

    // ------------------------------------------------------------------------
    // View helpers
    // ------------------------------------------------------------------------

    /// @notice Get all cycleIds associated with a user.
    function getUserCycles(address user) external view returns (bytes32[] memory) {
        return _userCycles[user];
    }

    /// @notice Get a summary for a given cycleId.
    function getCycleSummary(bytes32 cycleId) external view returns (CycleSummary memory) {
        return cycles[cycleId];
    }
}

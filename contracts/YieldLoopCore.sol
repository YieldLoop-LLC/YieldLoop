// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title YieldLoopCore
/// @notice Core contract for managing user deposits and cycle lifecycle.
contract YieldLoopCore {
    address public proofEngine;
    address public feeRouter;
    address public loopToken;

    uint256 public cycleLengthSeconds = 30 days;
    uint256 public minDeposit; // e.g. 50 USDC equivalent, set by admin.

    struct Cycle {
        address user;
        uint256 startTime;
        uint256 endTime;
        uint256 S;
        uint256 E;
        uint256 F;
        uint256 P_verified;
        bytes32 proofHash;
        bool closed;
    }

    mapping(bytes32 => Cycle) public cycles; // cycleId => Cycle

    event CycleStarted(
        bytes32 indexed cycleId,
        address indexed user,
        uint256 S,
        uint256 startTime
    );

    event CycleClosed(
        bytes32 indexed cycleId,
        uint256 E,
        uint256 F,
        uint256 P_verified,
        bytes32 proofHash
    );

    constructor(
        address _proofEngine,
        address _feeRouter,
        address _loopToken
    ) {
        proofEngine = _proofEngine;
        feeRouter = _feeRouter;
        loopToken = _loopToken;
    }

    /// @notice Start a new YieldLoop cycle for the caller.
    /// @dev For now this assumes S = `amount` and skips actual token transfers.
    function startCycle(uint256 amount) external returns (bytes32 cycleId) {
        require(amount >= minDeposit, "Deposit too small");

        // TODO: transfer in funds (e.g. ERC20) and handle allowances.
        // For this scaffold, we just treat `amount` as S.

        cycleId = keccak256(
            abi.encodePacked(msg.sender, block.timestamp, amount)
        );

        cycles[cycleId] = Cycle({
            user: msg.sender,
            startTime: block.timestamp,
            endTime: 0,
            S: amount,
            E: 0,
            F: 0,
            P_verified: 0,
            proofHash: bytes32(0),
            closed: false
        });

        emit CycleStarted(cycleId, msg.sender, amount, block.timestamp);
    }

    /// @notice Called by an authorized bot/controller to close a cycle
    /// @dev In final form, this should call ProofEngine to compute/verify P and proofHash.
    function closeCycle(
        bytes32 cycleId,
        uint256 E,
        uint256 F,
        uint256 P_verified,
        bytes32 proofHash
    ) external {
        // TODO: add access control (e.g. only a trusted operator/multisig)
        Cycle storage c = cycles[cycleId];
        require(!c.closed, "Already closed");
        require(c.user != address(0), "Unknown cycle");

        c.endTime = block.timestamp;
        c.E = E;
        c.F = F;
        c.P_verified = P_verified;
        c.proofHash = proofHash;
        c.closed = true;

        emit CycleClosed(cycleId, E, F, P_verified, proofHash);

        // TODO:
        // - Call FeeRouter to allocate fees.
        // - Mint LOOP tokens to user for P_verified.
        // - Handle withdrawal vs compounding logic at the end of the cycle.
    }
}

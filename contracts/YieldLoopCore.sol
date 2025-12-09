// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IProofEngine
/// @notice Minimal interface for the Veridic ProofEngine contract.
interface IProofEngine {
    function computeProof(
        uint256 S,
        uint256 E,
        uint256 F,
        uint256 t
    ) external pure returns (uint256 P, bytes32 proofHash);
}

/// @title IFeeRouter
/// @notice Minimal interface for the FeeRouter contract.
interface IFeeRouter {
    function routeFees(uint256 totalFee) external;
}

/// @title ILoopToken
/// @notice Minimal interface for the LoopToken minting contract.
interface ILoopToken {
    function mint(address to, uint256 amount) external;
}

/// @title YieldLoopCore
/// @notice Core contract for managing user deposits and cycle lifecycle.
/// @dev This is a scaffold. It assumes:
///      - S (starting amount) is passed in at cycle start
///      - E (ending amount) and F (fees/friction) are passed in at close
///      - ProofEngine computes P and proofHash
///      - LoopToken mints P to the user *only after* proof is computed
///      Real integrations will also wire in ERC20 transfers, strategies, etc.
contract YieldLoopCore {
    // ------------------------------------------------------------------------
    // External modules
    // ------------------------------------------------------------------------
    IProofEngine public proofEngine;
    IFeeRouter public feeRouter;
    ILoopToken public loopToken;

    // ------------------------------------------------------------------------
    // Configuration
    // ------------------------------------------------------------------------
    uint256 public cycleLengthSeconds = 30 days;
    uint256 public minDeposit; // abstract units for now (e.g. 1e18 = 1 token)

    // ------------------------------------------------------------------------
    // Data structures
    // ------------------------------------------------------------------------
    struct Cycle {
        address user;
        uint256 startTime;
        uint256 endTime;
        uint256 S;           // starting value
        uint256 E;           // ending value
        uint256 F;           // total friction/fees
        uint256 P_verified;  // verified profit
        bytes32 proofHash;   // Veridic proof hash
        bool closed;
    }

    mapping(bytes32 => Cycle) public cycles; // cycleId => Cycle

    // ------------------------------------------------------------------------
    // Events
    // ------------------------------------------------------------------------
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

    event ProfitMinted(
        bytes32 indexed cycleId,
        address indexed user,
        uint256 P_verified
    );

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(
        address _proofEngine,
        address _feeRouter,
        address _loopToken
    ) {
        require(_proofEngine != address(0), "YieldLoopCore: zero ProofEngine");
        require(_feeRouter != address(0), "YieldLoopCore: zero FeeRouter");
        require(_loopToken != address(0), "YieldLoopCore: zero LoopToken");

        proofEngine = IProofEngine(_proofEngine);
        feeRouter = IFeeRouter(_feeRouter);
        loopToken = ILoopToken(_loopToken);
    }

    // ------------------------------------------------------------------------
    // Core functions
    // ------------------------------------------------------------------------

    /// @notice Start a new YieldLoop cycle for the caller.
    /// @dev For now this assumes S = `amount` and skips actual token transfers.
    ///      In a full implementation, this would:
    ///        - transfer in the user's deposit (ERC20 or native)
    ///        - record deposit asset and amount
    function startCycle(uint256 amount) external returns (bytes32 cycleId) {
        require(amount >= minDeposit, "YieldLoopCore: deposit too small");

        // TODO: transfer in funds (e.g. ERC20) and handle allowances.

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

    /// @notice Close a cycle with final values and mint profit to the user.
    /// @dev In a real deployment this should be restricted to a trusted operator
    ///      (e.g. only a strategy/bot controller, or a multisig).
    ///      Here it's left open as a scaffold.
    /// @param cycleId The cycle identifier
    /// @param E The ending value for the user's position
    /// @param F The total friction / fees incurred for this cycle
    function closeCycle(
        bytes32 cycleId,
        uint256 E,
        uint256 F
    ) external {
        // TODO: add access control (e.g. onlyOperator modifier)
        Cycle storage c = cycles[cycleId];
        require(c.user != address(0), "YieldLoopCore: unknown cycle");
        require(!c.closed, "YieldLoopCore: already closed");

        c.endTime = block.timestamp;
        c.E = E;
        c.F = F;

        // Compute verified profit and proof hash using the ProofEngine
        (uint256 P_verified, bytes32 proofHash) = proofEngine.computeProof(
            c.S,
            c.E,
            c.F,
            block.timestamp
        );

        c.P_verified = P_verified;
        c.proofHash = proofHash;
        c.closed = true;

        emit CycleClosed(cycleId, E, F, P_verified, proofHash);

        // Route fees via FeeRouter (if any)
        if (F > 0) {
            feeRouter.routeFees(F);
        }

        // Mint profit to the user via LoopToken, if any profit exists
        if (P_verified > 0) {
            loopToken.mint(c.user, P_verified);
            emit ProfitMinted(cycleId, c.user, P_verified);
        }

        // TODO: handle user principal withdrawal vs compounding logic.
        //       For now this contract only tracks values and mints LOOP.
    }

    // ------------------------------------------------------------------------
    // Admin / config setters (optional for later)
    // ------------------------------------------------------------------------

    /// @notice Set minimum deposit threshold.
    /// @dev In a full system this should be restricted (e.g. onlyAdmin).
    function setMinDeposit(uint256 _minDeposit) external {
        // TODO: add access control
        minDeposit = _minDeposit;
    }

    /// @notice Update external module addresses.
    /// @dev In a real deployment, protect these with admin/multisig.
    function setModules(
        address _proofEngine,
        address _feeRouter,
        address _loopToken
    ) external {
        // TODO: add access control
        require(_proofEngine != address(0), "YieldLoopCore: zero ProofEngine");
        require(_feeRouter != address(0), "YieldLoopCore: zero FeeRouter");
        require(_loopToken != address(0), "YieldLoopCore: zero LoopToken");

        proofEngine = IProofEngine(_proofEngine);
        feeRouter = IFeeRouter(_feeRouter);
        loopToken = ILoopToken(_loopToken);
    }
}

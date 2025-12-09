// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProofEngine
/// @notice On-chain implementation of the Veridic Proof-of-Profit rule.
contract ProofEngine {
    event ProofComputed(
        bytes32 indexed proofHash,
        uint256 S,
        uint256 E,
        uint256 F,
        uint256 P
    );

    /// @notice Compute verified profit P = max(E - S - F, 0) and proofHash.
    /// @dev This is the canonical Veridic equation on-chain.
    function computeProof(
        uint256 S,
        uint256 E,
        uint256 F,
        uint256 t
    ) public pure returns (uint256 P, bytes32 proofHash) {
        if (E > S + F) {
            P = E - S - F;
        } else {
            P = 0;
        }

        proofHash = keccak256(abi.encodePacked(S, E, F, P, t));
    }

    /// @notice Verify provided P and proofHash matches recomputed values.
    /// @dev Used by external contracts or off-chain agents to validate proofs.
    function verifyProof(
        uint256 S,
        uint256 E,
        uint256 F,
        uint256 P,
        uint256 t,
        bytes32 proofHash
    ) external pure returns (bool) {
        (uint256 expectedP, bytes32 expectedHash) = computeProof(S, E, F, t);
        return (expectedP == P && expectedHash == proofHash);
    }
}

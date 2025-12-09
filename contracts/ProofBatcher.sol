// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProofBatcher
/// @notice Utility contract for batch computation and verification of Veridic proofs.
/// @dev This does NOT store any state; it just exposes batch helpers around the
///      same equation used in ProofEngine:
///           P = max(E - S - F, 0)
contract ProofBatcher {
    /// @notice Compute proofs for multiple cycles in a single call.
    /// @param S_list Array of starting values
    /// @param E_list Array of ending values
    /// @param F_list Array of friction/fee values
    /// @param t_list Array of timestamps
    /// @return P_list Array of verified profits for each cycle
    /// @return hash_list Array of proof hashes for each cycle
    function computeBatchProofs(
        uint256[] calldata S_list,
        uint256[] calldata E_list,
        uint256[] calldata F_list,
        uint256[] calldata t_list
    ) external pure returns (uint256[] memory P_list, bytes32[] memory hash_list) {
        uint256 len = S_list.length;
        require(
            len == E_list.length &&
            len == F_list.length &&
            len == t_list.length,
            "ProofBatcher: length mismatch"
        );

        P_list = new uint256[](len);
        hash_list = new bytes32[](len);

        for (uint256 i = 0; i < len; i++) {
            (uint256 P, bytes32 h) = _computeSingle(
                S_list[i],
                E_list[i],
                F_list[i],
                t_list[i]
            );
            P_list[i] = P;
            hash_list[i] = h;
        }
    }

    /// @notice Verify a batch of provided proofs.
    /// @dev Returns an array of booleans indicating validity of each proof.
    function verifyBatchProofs(
        uint256[] calldata S_list,
        uint256[] calldata E_list,
        uint256[] calldata F_list,
        uint256[] calldata P_list,
        uint256[] calldata t_list,
        bytes32[] calldata hash_list
    ) external pure returns (bool[] memory valid) {
        uint256 len = S_list.length;
        require(
            len == E_list.length &&
            len == F_list.length &&
            len == P_list.length &&
            len == t_list.length &&
            len == hash_list.length,
            "ProofBatcher: length mismatch"
        );

        valid = new bool[](len);

        for (uint256 i = 0; i < len; i++) {
            (uint256 expectedP, bytes32 expectedHash) = _computeSingle(
                S_list[i],
                E_list[i],
                F_list[i],
                t_list[i]
            );
            valid[i] = (expectedP == P_list[i] && expectedHash == hash_list[i]);
        }
    }

    // ------------------------------------------------------------------------
    // Internal helpers
    // ------------------------------------------------------------------------

    function _computeSingle(
        uint256 S,
        uint256 E,
        uint256 F,
        uint256 t
    ) internal pure returns (uint256 P, bytes32 proofHash) {
        if (E > S + F) {
            P = E - S - F;
        } else {
            P = 0;
        }

        proofHash = keccak256(abi.encodePacked(S, E, F, P, t));
    }
}

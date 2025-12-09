# YieldLoop + Veridic Smart Contracts Documentation (v0.1)

This document explains the purpose, structure, and interactions of each smart contract in the YieldLoop + Veridic system.

This is the authoritative developer reference for the on-chain components.

---

# 1. Contract Overview

The system consists of the following contracts:

| Contract             | Purpose |
|----------------------|---------|
| `YieldLoopCore`      | Orchestrates cycles, computes outputs, mints LOOP tokens |
| `ProofEngine`        | Computes verified profit + proof hashes |
| `LoopToken`          | ERC-20 token minted **only** from verified profit |
| `AccessController`   | Defines minters and admins |
| `FeeRouter`          | Splits friction/fees into system buckets |
| `ProofBatcher`       | Batch profit/hash computation & verification |
| `CycleRegistry`      | Frontend-friendly index of cycles and summaries |

Each contract is modular and replaceable.

---

# 2. YieldLoopCore

The heart of the engine.

## Responsibilities
- Starts cycles (records S)
- Closes cycles (records E and F)
- Calls ProofEngine to compute:
  - `P_verified`  
  - `proofHash`
- Mints LOOP to user (through LoopToken)
- Routes fees via FeeRouter
- Emits events for analytics
- (Optionally) updates CycleRegistry

## Key Storage
mapping(bytes32 => Cycle)

Cycle struct:
- `user`
- `S` (starting amount)
- `E` (ending amount)
- `F` (friction)
- `P_verified`
- `proofHash`
- `startTime`
- `endTime`
- `closed`

## Key Functions
### `startCycle(uint256 amount)`
Creates a new cycle.

### `closeCycle(bytes32 cycleId, uint256 E, uint256 F)`
Finalizes a cycle:
- Calls ProofEngine
- Mints LOOP
- Routes fees
- Emits events

## Notes
- Real implementation will include ERC-20 transfers  
- Access control should be added later for “onlyOperator”

---

# 3. ProofEngine

Implements the **Veridic Law of Verified Profit**.

## Responsibilities
- Compute verified profit:
  \[
  P = \max(E - S - F, 0)
  \]
- Compute: proofHash = keccak256(S, E, F, P, t)

- Verify a provided proof pair `(P, proofHash)`

## Key Functions
### `computeProof(S, E, F, t)`
Returns:
- `P`
- `proofHash`

### `verifyProof(S, E, F, P, t, proofHash)`
Returns `true` iff both P and hash match re-computed values.

## Notes
- Stateless  
- Pure math  
- Cannot be gamed because YieldLoopCore controls inputs

---

# 4. LoopToken

The system token representing **verified profit only**.

## Responsibilities
- Standard ERC-20 balance/transfer behavior
- Minting restricted to minters defined in AccessController
- Burning also restricted to minters

## Key innovations
- **Mint-on-proof-only** model  
- Prevents inflation unrelated to real value  
- Keeps token supply tied to *actual proven profit*

## Key Functions
### `mint(address to, uint256 amount)`
Restricted to a minter contract (e.g., YieldLoopCore).

### `burn(address from, uint256 amount)`
Also restricted.

### `setAccessController(address)`
Admins only.

---

# 5. AccessController

Manages roles:

- `admin`
- `minter`

## Admins
- Can add/remove other admins
- Can assign or revoke minters

## Minters
- Allowed to mint LOOP via LoopToken
- Expected default minter is **YieldLoopCore**

## Key Functions
### `addAdmin(address)`
### `removeAdmin(address)`
### `addMinter(address)`
### `removeMinter(address)`
### `isAdmin(address)`
### `isMinter(address)`

---

# 6. FeeRouter

Splits and routes friction `F`.

## Responsibilities
- Accept total fee amount
- Break into sub-components:
- Dev ops
- Marketing/growth
- System deposit fund
- Impact pool
- Emit events
- (Later) perform ERC-20 transfers

## Key Functions
### `routeFees(uint256 totalFee)`
Emits calculated splits.

### `setBps(...)`
Adjust fee ratios.

### `setWallets(...)`
Update receiving addresses.

---

# 7. ProofBatcher

Utility for computing/verifying many proofs at once.

## Useful for:
- Off-chain agents
- Indexer services
- Testing
- Audits
- Dashboard calculations

## Key Functions
### `computeBatchProofs(S[], E[], F[], t[])`
Returns:
- `P[]`
- `proofHash[]`

### `verifyBatchProofs(...)`
Returns boolean array of matches vs expected.

---

# 8. CycleRegistry

Provides clean data for UI + analytics.

## Responsibilities
- Register a new cycle
- Update a cycle when it closes
- Store summaries
- Allow lookup by user or cycleId

## Key Functions
### `registerCycle(cycleId, user, startTime, S)`
### `updateCycleOnClose(cycleId, endTime, E, F, P, hash)`
### `getUserCycles(address)`
### `getCycleSummary(cycleId)`

## Notes
- Purely informational  
- No financial authority  
- Helpful for indexing

---

# 9. Contract Interactions Summary
YieldLoopCore
→ ProofEngine (compute P, proofHash)
→ LoopToken (mint P_verified)
→ FeeRouter (route F)
→ CycleRegistry (index updates)

AccessController governs permissions:
- YieldLoopCore must be a minter in LoopToken
- Admins maintain operator lists

---

# 10. Security Notes

- Minting restricted by AccessController
- Profit must be computed via ProofEngine
- No trusted user can mint tokens arbitrarily
- Fee routing split is transparent
- Cycle data is immutable once closed

---

# End of CONTRACTS.md

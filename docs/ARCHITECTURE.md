# YieldLoop + Veridic Architecture Overview (v0.1)

This document provides a high-level technical overview of the YieldLoop Proof Engine ecosystem.  
It explains core modules, data flows, and how the system enforces the Veridic Law of Verified Profit.

---

# 1. System Overview

YieldLoop is a cycle-based financial engine that:

1. Accepts a deposit `S`
2. Executes a strategy (off-chain or on-chain)
3. Produces an ending value `E`
4. Accounts for system friction `F`
5. Computes verified profit `P` using:

\[
P = \max(E - S - F, 0)
\]

6. Generates a `proofHash = H(S, E, F, P, t)`
7. Mints LOOP tokens equal to `P_verified`
8. Routes fees according to configurable splits

All recognized profit in the system is **provably verified**, not declared.

---

# 2. Core Components

## 2.1 YieldLoopCore
Responsible for:

- Cycle creation
- Recording S, E, F
- Calling ProofEngine
- Minting LOOP tokens
- Routing fees to FeeRouter

It is the “conductor” of the Veridic engine.

---

## 2.2 ProofEngine

A deterministic implementation of the Veridic profit law.  
It:

- Computes verified profit
- Computes the cryptographic proof hash
- Validates provided proofs

It is the canonical reference for all downstream systems.

---

## 2.3 LoopToken (Profit-Minted Token)

An ERC-20 token with the restriction:

> Only a minter authorized via AccessController may mint.

And YieldLoopCore only mints after verified profit exists.

Therefore:

**Every LOOP token in circulation represents actual verifiable profit.**

---

## 2.4 AccessController

Controls who can:

- Mint LOOP tokens
- Burn LOOP tokens
- Modify system modules later

This ensures the minting authority cannot be abused.

---

## 2.5 FeeRouter

Splits friction `F` into system-defined buckets:

- Dev ops
- Marketing/growth
- System deposit fund
- Impact/civic allocation

Percentages are configurable and not part of the patent claims.

---

## 2.6 CycleRegistry

A read-optimized index of:

- Per-cycle summaries
- Per-user histories
- Proof hashes
- Verified profit outputs

Useful for frontends, explorers, and analytics dashboards.

---

## 2.7 ProofBatcher (optional utility)

A helper contract that batches:

- Proof computation
- Proof verification

This is valuable for:

- Off-chain actors
- Indexers
- Testing
- Monitoring

---

# 3. Data Flow Diagram (Logical)

User
↓ deposit S
YieldLoopCore
↓ record S
↓ strategy execution (external)
↓ receive E, F
ProofEngine
↓ computes (P, proofHash)
YieldLoopCore
↓ mint P LOOP via LoopToken
↓ route F via FeeRouter
↓ update registry via CycleRegistry
User receives LOOP (verified profit)

---

# 4. Trust Model

The system is designed so that:

- Profit must be mathematically verified
- LOOP cannot be minted without a valid proof
- Fees cannot be misallocated (FeeRouter enforces splits)
- Admin roles cannot mint tokens themselves
- ProofEngine cannot be bypassed

**All_paths_to_profit → go through Veridic verification.**

---

# 5. Extensibility

The architecture is modular:

- You can swap ProofEngine versions  
- You can upgrade YieldLoopCore rules  
- You can change token naming/symbol  
- You can route fees differently  
- You can decentralize AccessController  
- You can add zk-proofs to ProofEngine later  

Nothing is hard-coded.

---

# 6. Implementation Status

Contracts completed:

- LoopToken
- AccessController
- YieldLoopCore (integrated)
- ProofEngine
- FeeRouter
- ProofBatcher
- CycleRegistry

Documentation completed:

- Academic summary
- Patent notes
- API specs
- Roadmap

The architecture is fully defined for developers to begin end-to-end implementation.

---

# End of ARCHITECTURE.md

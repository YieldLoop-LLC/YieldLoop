# YieldLoop Cycle Lifecycle & State Transition Flow (v0.1)

This document explains the complete lifecycle of a YieldLoop cycle — from deposit to closing — including data movement, proof generation, minting logic, fee routing, registry updates, and final user outputs.

It is intended to serve as a blueprint for developers, auditors, analysts, and academic reviewers.

---

# 1. High-Level Summary

A YieldLoop cycle consists of:

1. **Deposit (S)** — the starting value  
2. **Execution** — the trading/yield strategy (off-chain or hybrid)  
3. **Result (E)** — the ending value  
4. **Friction (F)** — fees/overhead  
5. **Verified Profit (P)** using the Veridic equation  
6. **Proof Hash (H)** that binds S, E, F, P, and timestamp  
7. **Minting LOOP tokens** equal to verified profit  
8. **Routing friction** through FeeRouter  
9. **Registry update** for UI + analytics  

Everything flows through **ProofEngine**, ensuring immutable verification.

---

# 2. State Definitions

Each cycle moves through the following states:

| State | Description |
|-------|-------------|
| `CREATED` | User initiated a cycle, S is recorded |
| `RUNNING` | External strategy executing |
| `AWAITING_CLOSE` | Strategy finished; inputs E and F are available |
| `CLOSED` | Verified, finalized, profit minted, fees routed |
| `ARCHIVED` (optional) | Moved to long-term indexing via CycleRegistry |

Only **YieldLoopCore** decides state transitions.

---

# 3. Full Lifecycle

## 3.1 Cycle Start — Recording S

**Triggered by:**  
- User deposit  
- Bot execution  
- External event  

**Data stored:**  
- `cycleId = keccak256(user, startTime, nonce)`  
- `S`  
- `startTime`  

**Validation:**  
- User address must be valid  
- Amount must be above system minimum  

**Events:**  

CycleStarted(cycleId, user, S, startTime)

**Optional:**  
CycleRegistry is updated here via `registerCycle()`.

The cycle now enters **RUNNING**.

---

# 4. Strategy Execution (Off-Chain or Hybrid)

During RUNNING:

- External execution engine manages trades / yield strategies  
- YieldLoopCore only waits for final values  
- Off-chain engine returns:
  - Ending value **E**
  - Friction/fees **F**  

This phase is not on-chain and not trust-critical *because verification happens later*.

The Proof Engine ensures **no false data can result in minting**.

---

# 5. Cycle Close — Verification Phase

Closing a cycle requires:

### Inputs
- `cycleId`
- `E` — ending value  
- `F` — friction  
- `t` — timestamp  

### Steps in YieldLoopCore

#### 1) Retrieve S  
Cycle was created earlier and S is immutable.

#### 2) Call ProofEngine.computeProof(S, E, F, t)
Returns:

- Verified profit `P_verified`
- `proofHash`

This step applies the canonical Veridic Equation:

\[
P = \max(E - S - F, 0)
\]

If E ≤ S + F  
→ Profit is 0  
→ No LOOP tokens are minted  

#### 3) Mint LOOP to the user  
YieldLoopCore calls:

loopToken.mint(user, P_verified)

This is only possible because AccessController gave YieldLoopCore the *minter* role.

#### 4) Route Friction  

feeRouter.routeFees(F)


FeeRouter outputs events, and later can transfer ERC-20 assets.

#### 5) Store result  
Cycle data is updated:

- `E`
- `F`
- `P_verified`
- `proofHash`
- `endTime`
- `closed = true`

#### 6) Emit event  

CycleClosed(cycleId, E, F, P_verified, proofHash)

#### 7) Registry (optional but recommended)
Call:

cycleRegistry.updateCycleOnClose(…)

This produces UI-friendly summaries.

---

# 6. Full State Transition Diagram

    +-------------+
    |   CREATED   |
    +-------------+
           |
           v
    +-------------+
    |   RUNNING   |
    +-------------+
           |
           | strategy returns E, F
           v
    +-------------------+
    | AWAITING_CLOSE    |
    +-------------------+
           |
           | ProofEngine.computeProof()
           v
    +-------------+
    |   CLOSED    |
    +-------------+
           |
           | (optional)
           v
    +-------------+
    |  ARCHIVED   |
    +-------------+

    ---

# 7. Detailed Data Flow

User
↓ S
YieldLoopCore
↓ store S
Strategy Engine (external)
↓ return (E, F)
YieldLoopCore
↓ ProofEngine.computeProof(S, E, F, t)
↓ (P_verified, proofHash)
↓ LoopToken.mint(user, P_verified)
↓ FeeRouter.routeFees(F)
↓ CycleRegistry.update(…)
User receives LOOP
System logs proof

---

# 8. Developer Notes & Integration Rules

### 8.1 Immutable S  
Once a cycle is started, S cannot change.

### 8.2 Strategy execution MUST NOT write to blockchain  
Only final values E and F enter the Proof Engine.

### 8.3 All profit must be verified  
No minting occurs unless ProofEngine agrees.

### 8.4 End-of-cycle is atomic  
Closing a cycle should complete:
- Verification  
- Minting  
- Fee routing  
- Registry update  

As a single transaction for safety.

### 8.5 Off-chain executors must record:  
- All trades  
- All gas usage  
- Internal log of how E and F were derived  

This supports auditability.

---

# 9. Future Extensions

- Zero-knowledge proof version of ProofEngine  
- Governance-controlled fee splits  
- Multi-strategy cycle support  
- Multi-chain deployment  
- Rollup-native optimizations  
- Reputation scoring via consistent cycle participation  

---

# End of CYCLE_FLOW.md

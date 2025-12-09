# YieldLoop Integration Guide – System, Engine, and Frontend Integration (v0.1)

This document explains how to integrate external systems — dashboards, bots, analytic engines, off-chain strategy modules, or full applications — with the YieldLoop + Veridic architecture.  
It covers how contracts are meant to interoperate, how external modules fetch data, and how developers build logic around cycles, proofs, and token minting.

---

# 1. Integration Overview

YieldLoop is designed as a **modular system**, not a monolithic app.

External products can integrate with:

- `YieldLoopCore` — for cycle lifecycle actions  
- `ProofEngine` — for verification or simulation  
- `LoopToken` — for balance and supply info  
- `CycleRegistry` — for UI and analytics  
- `ProofBatcher` — for batch verification workflows  

This guide explains how.

---

# 2. Core Contracts & How External Systems Use Them

## 2.1 YieldLoopCore

External systems typically call:

### **`startCycle()`**
Used by:

- User-facing deposit interfaces  
- Automated trading bots  
- Backend orchestration  

Inputs:
- `S` (starting value)  
- user address inferred via `msg.sender` or operator role  

Output:
- `cycleId` event emission  
- New cycle stored  

---

### **`closeCycle()`**
Used by:

- Off-chain strategy engine  
- Trading bot  
- Backend service  

Inputs:
- `cycleId`  
- `E` — ending value  
- `F` — friction  

YieldLoopCore:

1. Calls `ProofEngine`  
2. Mints LOOP  
3. Routes friction via FeeRouter  
4. Updates registry  

This is the most important integration point.

---

## 2.2 ProofEngine

External systems use this for:

- Off-chain simulation  
- Expected profit calculation  
- Validating raw data before sending to contract  
- Matching UI numbers to on-chain behavior  

Useful functions:

### `computeProof(S, E, F, t)`
Computes:

- Verified profit  
- Proof hash  

### `verifyProof(S, E, F, P, t, proofHash)`
Confirms correctness.

External developers use these for:

- Confidence checks  
- Testing strategy models  
- Verifying dashboard data

---

## 2.3 LoopToken

### Key reads:
- `totalSupply()`
- `balanceOf(user)`
- `minter` address via AccessController

External systems use this for:

- Portfolio dashboards  
- Token analytics  
- Cycle-to-profit visualization  

---

## 2.4 CycleRegistry

This is the **primary frontend data source**.

Exposes clean access to:

### `getUserCycles(address user)`
Returns all cycleIds.

### `getCycleSummary(cycleId)`
Returns:

- S, E, F  
- P_verified  
- proofHash  
- startTime, endTime  
- closed flag  

Perfect for:

- Wallet dashboards  
- Dune dashboards  
- Analytics frontends  
- Mobile apps  

---

## 2.5 ProofBatcher

Useful for:

- Batch recomputation  
- Off-chain data integrity checks  
- Indexer nodes  
- ZK/rollup compatible implementations  

Function calls:

### `computeBatchProofs()`
### `verifyBatchProofs()`

---

# 3. Building an External Strategy Engine (Off-Chain Logic)

A typical integration flow for an off-chain strategy engine looks like this:

---

## Step 1 — Listen for cycle creation

Subscribe to: CycleStarted(user, cycleId, S, startTime)

Then begin trading/yield operations.

---

## Step 2 — Execute strategy externally

This may involve:

- DEX trading  
- Yield aggregation  
- Arbitrage bots  
- Grid trading  
- Lending  
- Any complex portfolio  

Store the raw operations in a local database.

---

## Step 3 — Compute ending value E and friction F

Friction may include:

- Gas  
- Slippage  
- Fees  
- Spread losses  
- Operational overhead  
- Risk adjustments  

---

## Step 4 — Validate using ProofEngine before sending on-chain

Off-chain: (P, hash) = computeProof(S, E, F, t)

If P is wrong → fix inputs.  
If hash differs → investigate error.

External systems MUST validate before calling closeCycle.

---

## Step 5 — Close cycle on-chain

Call: closeCycle(cycleId, E, F)

YieldLoopCore will:

- Recompute via ProofEngine  
- Mint LOOP  
- Route fees  
- Update CycleRegistry  

The off-chain engine can then:

- Log results  
- Update dashboards  
- Trigger next cycle  

---

# 4. Frontend Integration

The simplest frontend reads:

- All open and closed cycles via CycleRegistry  
- LOOP balance via LoopToken  
- Profit verification via ProofEngine  
- Events from YieldLoopCore  

Minimum calls per user: 
registry.getUserCycles(user)
registry.getCycleSummary(cycleId)
balance = loopToken.balanceOf(user)

This supports:

- Historical charts  
- Performance summaries  
- Per-cycle proof verification  
- Visualizations of P, S, E, F  
- Floor price graphs  
- Token supply graphs  

---

# 5. Backend Integration (Node Service or Cloud Worker)

A backend bot typically:

1. Listens to new cycles  
2. Runs trading/yield models  
3. Computes E and F  
4. Calls ProofEngine locally  
5. Sends closeCycle transaction  
6. Pushes updates to dashboards  

---

# 6. Dashboard & Analytics Integration

Common data sources:

### Cycle Registry  
- Perfect for charts  
- Consistent format  
- Proof hashes included  

### ProofBatcher  
- Great for recalculating many cycles at once  

### LoopToken  
- Total supply = cumulative verified profit  

Useful analytics:

- Real-world ROI  
- Verified profit charts  
- Token inflation curve  
- Cycle duration analytics  
- Per-user performance analysis  

---

# 7. Error Handling & Safety

### If a strategy engine provides incorrect E or F  
ProofEngine will catch it → cycle closes with P = 0.

### If ProofEngine returns P = 0  
No LOOP minted.  
Cycle still closes.  
Everything remains consistent.

### If operator tries to close an unknown cycle  
Reverted.

### If duplicate close  
Reverted.

### If operator tries to mint manually  
LoopToken will reject minting.

### If operator passes mismatched proof  
ProofEngine rejects.  
YieldLoopCore reverts.

---

# 8. Multi-Chain Integration

The architecture supports deployment on:

- Ethereum  
- Base  
- Arbitrum  
- BNB Chain  
- Avalanche  
- Cosmos rollups  
- Custom appchains  

Cross-chain LOOP supply can be synchronized via:

- Canonical mint/burn bridges  
- Anytrust verification  
- ZK bridges  
- Shared registry indexes  

---

# 9. Future Integrations

This guide will extend to cover:

- Oracle integrations  
- ZK-proof-enabled versions of ProofEngine  
- Multi-cycle batching logic  
- Group-cycle verification  
- Algorithmic cycle curation  
- On-chain strategy modules  

---

# End of INTEGRATION_GUIDE.md

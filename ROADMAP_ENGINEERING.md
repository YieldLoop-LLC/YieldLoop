# YieldLoop / Veridic – Engineering Roadmap

This roadmap is for engineers, not marketers. It describes how we get from theory and docs to a running, verifiable Proof-of-Profit engine.

Phases overlap. Timelines are flexible. Dependencies are not.

---

## Phase 1 – Foundations & Repo Structure (CURRENT)

**Goals**
- Clean, navigable repo structure.
- Core concepts captured in machine- and human-readable form.
- Clear direction for contributors, academics, and devs.

**Deliverables**
- `/docs` with whitepaper links and this roadmap.
- `/contracts` folder with Solidity stubs.
- `/simulation` folder with notebooks and specs.
- `/api` folder with API spec.
- `/academic` and `/patent` prep documents.
- Contribution guides and issue templates.

**Status**
- In progress.

---

## Phase 2 – Simulation & Modeling

**Goal:** Prove the stability and behavior of the Veridic / YieldLoop model under many conditions before we deploy any real capital.

**Key Concepts**
- Core profit equation: `P = max(E - S - F, 0)`.
- Proof-of-Profit via ProofHash.
- System deposit loop.
- Yield-to-Impact allocation.
- Entropy reduction via verification density.

**Tasks**
1. Build Python simulation engine:
   - Model N users, M cycles.
   - Randomized returns, costs, and friction.
   - Apply Veridic constraints and Proof-of-Profit.
2. Run scenarios:
   - Bull, bear, sideways markets.
   - High fees vs low fees.
   - Honest vs dishonest reporting.
3. Metrics:
   - Stability over time.
   - Frequency and magnitude of drawdowns.
   - Effective “entropy” vs verification density.
4. Outputs:
   - CSVs for each run.
   - Charts: cumulative profit, system health, entropy proxy.
   - Summary report in `/simulation/RESULTS.md`.

**Success Criteria**
- No “phantom profit” in verified simulations.
- System converges to stable behavior in most conditions.
- Edge cases are identified and documented.

---

## Phase 3 – Proof Engine Library (Off-Chain)

**Goal:** Implement the Veridic / Proof-of-Profit logic as a reusable library.

**Tasks**
1. Create a small Proof Engine library (e.g. TypeScript or Python) that:
   - Accepts S, E, F.
   - Computes P with Veridic rules.
   - Produces ProofHash = H(S || E || F || P || t).
2. Define interfaces for:
   - Verification calls (internal and external).
   - Logging and audit trails.
   - Error handling when proofs fail.
3. Add tests:
   - Known good/known bad cycles.
   - Cross-checks with simulation results.

**Success Criteria**
- Deterministic, quick verification.
- Minimal complexity.
- Easy to port into smart contracts later.

---

## Phase 4 – Smart Contract MVP (On-Chain Core)

**Goal:** Bring the Proof Engine on-chain and connect it to a simple vault model.

**Contracts (in `/contracts`)**
- `YieldLoopCore.sol` – user deposits, cycle management.
- `ProofEngine.sol` – on-chain P calculation and ProofHash storage.
- `FeeRouter.sol` – routing Dev/Marketing/System/Impact allocations.
- `LoopToken.sol` (LOOP) – minting on verified profit.
- `ImpactVault.sol` – holds Yield-to-Impact funds (Loop Lab or similar).
- `Governance.sol` – config & parameter control (initially admin/multisig).

**Tasks**
1. Implement MVP logic without bells and whistles:
   - Single asset (e.g. ETH or USDC).
   - Single strategy placeholder.
   - Manual “cycle close” function for testing.
2. Add events:
   - `CycleClosed`, `ProofCreated`, `LoopMinted`, `FeesAllocated`.
3. Hardcode simple safety constraints first:
   - Max drawdown per cycle.
   - Minimum fee transparency.
4. Basic test suite (Hardhat/Foundry).

**Success Criteria**
- End-to-end test from deposit → cycle close → profit verification → LOOP mint → fee routing.
- No unverified profit can be distributed.

---

## Phase 5 – Strategy Integration (Real Trading, Controlled)

**Goal:** Connect the on-chain proof flow to off-chain trading logic in a controlled, auditable way.

**Tasks**
1. Define a Strategy Adapter model:
   - Off-chain bot executes trades.
   - Reports S, E, F back on-chain.
   - On-chain contracts verify via ProofEngine.
2. Implement at least one real strategy:
   - Simple spot or perps strategy on major pairs.
   - Tight risk parameters.
3. Logging:
   - Every off-chain trade is logged with a local hash.
   - Every on-chain proof can be mapped back.

**Success Criteria**
- Real-world trades produce auditable, on-chain proofs.
- No path to “fake” P without failing verification.

---

## Phase 6 – Frontend & API

**Goal:** Make the system useable and inspectable by humans.

**Tasks**
1. `/api/API_SPEC.md` – finalize endpoints for:
   - User cycles.
   - System health.
   - Proofs and hashes.
2. Build a basic frontend:
   - Deposit, view cycles, view proofs.
   - Visual “Veridic Health” indicators.
3. Public dashboards:
   - On-chain data → Dune, etc.
   - Mirror internal metrics from simulation to live.

**Success Criteria**
- A user can:
  - Deposit.
  - See what the system is doing.
  - See proof that profit is real.

---

## Phase 7 – Governance & Scaling

**Goal:** Transition from “founder-driven” to “rules-driven” without breaking safety.

**Tasks**
1. Implement parameter control mechanisms:
   - Multisig at first.
   - Later NFT / governance-weighted voting.
2. Document governance:
   - What can be changed.
   - What is immutable.
3. Scaling:
   - New assets and new strategies.
   - Chain expansion.

**Success Criteria**
- A clear, auditable change log.
- No single actor can quietly break Veridic constraints.

---

## Phase 8 – Audit, Academic Testing, & Launch

**Goal:** Before going big, the system must be beaten up by outsiders.

**Tasks**
1. Smart contract audits.
2. Academic collaboration:
   - Provide simulation data.
   - Provide formal model to researchers.
3. Public beta with hard limits.

**Success Criteria**
- Clean audit reports.
- At least one academic analysis or working paper.
- No catastrophic failures in beta.

---

This roadmap will evolve as we learn. The one constant: **profit is never real until it is proven.**

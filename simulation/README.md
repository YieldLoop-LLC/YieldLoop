# YieldLoop / Veridic Simulation Suite

This folder contains tools for testing the behavior of the Veridic / YieldLoop model in a controlled environment before deployment.

## Objectives

- Test the Proof-of-Profit law under many different conditions.
- Observe stability, drawdowns, and “entropy” (uncertainty) over time.
- Identify parameter ranges that lead to stable vs unstable behavior.
- Generate datasets suitable for academic analysis and dashboards.

## Core Concepts

- `S` = Starting balance or system state.
- `E` = Ending balance.
- `F` = Total friction: fees, losses, slippage, etc.
- `P` = Profit, defined as `P = max(E - S - F, 0)`.
- `ProofHash` = Cryptographic hash of `(S, E, F, P, t)`.
- `α` = Yield-to-Impact fraction.
- `System entropy proxy` = Simple measure of instability (e.g. volatility of P over rolling windows, or variance between claimed vs verified profit).

## Files

- `simulate_yieldloop.py` – main script/notebook base for running cycle simulations.
- `scenarios.yaml` – configuration presets for different test scenarios.
- `RESULTS.md` – summary of key runs and findings.
- `/data` – raw CSV outputs from simulation runs.

## Example Experiments

1. **Honest vs Dishonest Reporting**
   - Scenario A: P computed from E, S, F using Veridic formula.
   - Scenario B: P “claimed” independently with random inflation.
   - Measure divergence and system collapse in B over time.

2. **Different Fee Structures**
   - Low vs high friction (F).
   - Observe how much friction the system can tolerate before users stop gaining.

3. **Shock Events**
   - Sudden 30–50% drawdown.
   - Check how quickly (or if) the system re-stabilizes with Proof-of-Profit intact.

4. **Verification Density**
   - Vary frequency and granularity of verification.
   - Measure impact on “entropy” and perceived stability.

## Outputs

Each run should produce:

- `cycles_<scenario>_<timestamp>.csv` – per-cycle data:
  - cycle_id
  - S, E, F, P
  - alpha (impact fraction)
  - user_return
  - system_return
  - impact_allocation
  - proof_hash
- Simple plots:
  - cumulative user wealth
  - cumulative system deposit
  - impact generated
  - volatility of P

All of this backs up the claim that **verified systems behave more stably than unverified ones.**

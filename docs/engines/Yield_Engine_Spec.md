# YieldLoop — Yield Engine Specification
Version 1.1  
Category: Engine Architecture / Strategy Modules / Guardrails  
Status: Final  

This document defines the behavior of the YieldLoop Yield Engine using the **three approved strategies for v1**:

1. **Stablecoin Staking**  
2. **Yield Farming (Blue-Chip LPs Only)**  
3. **DCA Trading (Blue-Chip Assets Only)**  

The Yield Engine is composed of:

- Strategy Modules  
- The Guardrail Engine  
- The 30-Day Cycle System  
- The Veridic Profit Engine (for post-cycle verification)

---

# 1. Overview

The Yield Engine is the automated execution system that allocates user deposits across one or more approved strategies based on user-defined or AI-optimized settings.

Properties:

- **Chain-agnostic**  
- **Non-custodial**  
- **Guardrail-protected** (via Guardrail Engine)  
- **Strategy-modular**  
- **Deterministic and auditable**  

The Guardrail Engine is always active and cannot be disabled by users or AI.

---

# 2. Supported Strategies (v1)

YieldLoop v1 includes exactly **three** strategy modules.

## 2.1 Stablecoin Staking Module

### Supported assets:
- USDT  
- USDC  
- BUSD (if chain supports)  
- Other audited stablecoins approved by governance  

### Behavior:
- Converts allocated portion of deposit into chosen stablecoin  
- Stakes into a reputable, audited yield source  
- Accrues APR linearly  
- Auto-harvests if required  
- No IL exposure  
- Near-zero volatility risk  

### User-configurable settings:
- Allocation %  
- Stablecoin choice  

---

## 2.2 Yield Farming Module (Blue-Chip LPs Only)

### Supported LP pairs:
- BTC/USDT  
- ETH/USDC  
- BNB/USDT  
- ATOM/USDC (if Cosmos)  
- OSMO/USDC (if Osmosis)  

### Supported DEX protocols:
- PancakeSwap  
- Uniswap v3  
- Osmosis  
- Balancer (chain-dependent)

### Behavior:
- Deposits allocated funds into LP  
- Harvests rewards at configured intervals  
- Auto-compounds (optional)  
- Rebalances LP exposure as required  
- Monitors IL and TVL conditions  

### User-configurable settings:
- Allocation %  
- LP pair selection  
- Auto-harvest frequency  
- Auto-rebalance toggle  

---

## 2.3 DCA Trading Module (Blue-Chip Assets Only)

### Supported assets:
- BTC  
- ETH  
- BNB  
- ATOM  
- SOL (where supported)  

### Behavior:
- Splits allocated funds into periodic buy slices  
- Executes buys at selected interval  
- Smooths entry into volatile markets  
- Optional take-profit and stop-loss per asset  
- Unused funds can sit in stable staking between DCA events  

### User-configurable settings:
- Allocation %  
- DCA interval (daily/weekly/etc.)  
- Amount per interval  
- Optional stop-loss  
- Optional take-profit  

---

# 3. Strategy Allocation Logic

For each deposit, the user (or AI) defines an allocation distribution across the three modules:

Example:

| Strategy             | Allocation |
|----------------------|------------|
| Stablecoin Staking   | 40%        |
| Yield Farming        | 30%        |
| DCA Trading          | 30%        |

Constraints:

- Sum of all allocations = **100%** of net invested funds  
- Any module may be 0–100% (within risk tier rules)  

Users can choose:

- 100% Stable Staking (Ultra Low Risk)  
- 100% DCA (Medium Risk)  
- 100% Yield Farming (Medium/High within safeguards)  

---

# 4. Engine Execution Flow

High-level, deterministic flow:

1.	User signs strategy parameters (off-chain / no gas)
	2.	User submits deposit transaction (on-chain)
	3.	NetInvested = DepositAmount - (DepositFee + AIFee)
	4.	Yield Engine allocates NetInvested across the three strategies
	5.	Guardrail Engine validates every allocation and order
	6.	Strategies operate autonomously for 30 days
	7.	Guardrail Engine monitors risk conditions continuously
	8.	At day 30:
a. Compute S, E, F
b. P = max(E - S - F, 0)
c. Veridic Engine generates ProofHash
	9.	LOOP minted only if P > 0
	10.	Rewards distributed according to user’s compounding choice

The **Guardrail Engine is invoked both at step 4 (pre-execution) and during step 6 (live monitoring).**

---

# 5. Guardrail Engine (Core Safety Subsystem)

The **Guardrail Engine** is the safety layer that:

- Validates every strategy configuration before execution  
- Monitors live positions and trades  
- Enforces global and per-strategy risk constraints  
- Triggers safe fallbacks when conditions are violated  

It is a **core part of the Yield Engine**, not a separate or optional feature.

## 5.1 Guardrail Engine Responsibilities

1. **Pre-Execution Validation**
   - Check allocations sum to 100%  
   - Validate risk tier against chosen strategies  
   - Validate all assets are on the whitelist  
   - Validate DEX, farm, and staking sources are approved  
   - Reject any trade or configuration outside safe bounds  

2. **Live Monitoring**
   - Monitor portfolio drawdown  
   - Monitor IL for farming  
   - Monitor liquidity and TVL  
   - Monitor slippage and price gaps  
   - Monitor execution frequency  

3. **Enforcement Actions**
   - Halt a strategy module  
   - Move funds to stable staking  
   - Prevent new trades in a module  
   - Trigger alerts/logs for admins  

Guardrail Engine decisions are deterministic and fully logged.

---

## 5.2 Global Guardrails

These rules apply to **all** strategies:

- No leverage or margin  
- No borrowing against assets  
- Only whitelisted assets, farms, and DEXs allowed  
- Maximum per-cycle drawdown threshold applied  
- Per-module trade frequency limits enforced  
- Fallback to stable staking if engine instability detected  

---

## 5.3 Strategy-Specific Guardrail Rules

### Stablecoin Staking:
- Only audited / governance-approved stablecoins  
- Minimum protocol security level (no known exploits)  
- APY must fall within configured safe range  

**If any condition fails:**
- Do not stake  
- Or withdraw to user’s stable balance within YieldLoop vault  

---

### Yield Farming:
- LP pair must be on whitelist  
- LP TVL must exceed minimum threshold  
- IL estimate must be under configured maximum  
- APR anomalies (sudden spikes) flagged and may halt entry  

**If IL or TVL risk thresholds are exceeded:**
- Exit LP position  
- Route funds to stable staking  

---

### DCA Trading:
- Asset must be blue-chip and whitelisted  
- Slippage must be under threshold  
- DCA interval must not exceed configured maximum/minimum bounds  
- Buy sizes must be under per-trade maximum  

**If DCA cannot execute safely:**
- Skip interval and keep funds in stable staking  
- Log event for diagnostics  

---

## 5.4 Guardrail Engine State Transitions (Simplified)

The **Guardrail Engine is invoked both at step 4 (pre-execution) and during step 6 (live monitoring).**

[CHECK_CONFIG] → valid? → [READY]
↓ no
[REJECT_CONFIG]

[READY] → start cycle → [RUNNING]

[RUNNING] – violation detected –> [FALLBACK]
[RUNNING] – no violation, cycle complete –> [COMPLETED]

[FALLBACK] → move funds to stable staking → [RUNNING] or [COMPLETED]

---

# 6. AI Optimization (Optional)

AI is allowed to **suggest**:

- Allocation percentages  
- DCA interval and amount  
- LP selection (within whitelist)  
- Relative weighting of staking vs. farming vs. DCA  
- Drawdown/volatility preferences (within limits)  

AI cannot:

- Bypass the Guardrail Engine  
- Add new assets not on whitelist  
- Use leverage or margin  
- Modify cycle length  

### AI Fee:
- Deducted from deposit at cycle creation  
- Recommended end-user fee: **$1.00 per optimization**  

### Implementation:
- Use o3-mini for numeric optimization  
- Use GPT-4.1 for text summaries and explanations  

---

# 7. 30-Day Cycle Behavior

Each deposit starts its own independent **30-day cycle**:

- Strategy cannot be changed mid-cycle  
- User cannot withdraw early  
- New deposits create new cycles  
- Guardrail Engine continuously protects capital  

At the end of the cycle, funds and P are evaluated via Veridic.

---

# 8. End-of-Cycle Profit Verification (Veridic)

At day 30:

S = Starting Value
E = Ending Value
F = Friction Costs
P = max(E - S - F, 0)

- If **P > 0**:
  - Profit is verified  
  - LOOP is minted  
  - Verified Floor increases permanently  

- If **P = 0**:
  - No LOOP minted  
  - No inflation  
  - Floor remains unchanged  

---

# 9. Reward Distribution

User chooses at deposit time:

- **Withdraw All**  
- **50% Compound / 50% Withdraw**  
- **Compound All**  

LOOP rewards follow the Veridic Proof Engine outcome and user’s compounding preference.

---

# END OF FILE

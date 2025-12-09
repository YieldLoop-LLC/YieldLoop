# YieldLoop — Yield Engine Specification
Version 1.0  
Category: Engine Architecture / Strategy Modules  
Status: Final  

This document defines the complete behavior of the YieldLoop Yield Engine using the **three approved strategies for v1**:

1. **Stablecoin Staking**  
2. **Yield Farming (Blue-Chip LPs Only)**  
3. **DCA Trading (Blue-Chip Assets Only)**  

All strategies operate under the YieldLoop 30-Day Cycle System and integrate with the Veridic Profit Engine for post-cycle verification.

---

# 1. Overview

The Yield Engine is the automated execution system that allocates user deposits across one or more approved strategies based on user-defined settings or AI-optimized settings.  

The engine is:

- **Chain-agnostic**  
- **Non-custodial**  
- **Guardrail-protected**  
- **Strategy-modular**  
- **Fully deterministic**  
- **Bounded by user-approved parameters**  

No strategy may execute outside approved risk bands or safety limits.

---

# 2. Supported Strategies (v1)

YieldLoop v1 includes exactly **three** strategy modules:

## 2.1 Stablecoin Staking Module
The safest and simplest strategy.

### Supported assets:
- USDT  
- USDC  
- BUSD (if chain supports)  
- Other audited stables permitted by governance  

### Behavior:
- Converts allocated portion of deposit into chosen stablecoin  
- Stakes into a reputable, audited platform  
- Accrues APR linearly  
- Auto-harvest performed if required by protocol  
- No IL exposure  
- No volatility risk  

### User-configurable settings:
- Allocation %  
- Stablecoin selection  

Stablecoin staking forms the “risk floor” of the Yield Engine.

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
- Balancer (if chain-appropriate)

### Behavior:
- Deposits into selected LP pair  
- Auto-harvests rewards  
- Auto-compounds (if enabled)  
- Rebalances LP exposure as required  
- Monitors IL and TVL conditions  

### User-configurable settings:
- Allocation %  
- LP pair selection  
- Auto-harvest frequency  
- Auto-rebalance toggle  

### Guardrails:
- IL exceeds safe threshold → farm pauses  
- LP pair must be whitelisted  
- Minimum TVL required to enter farm  

---

## 2.3 DCA Trading Module (Blue-Chip Assets Only)

### Supported assets:
- BTC  
- ETH  
- BNB  
- ATOM  
- SOL (if chain supports)  

### Behavior:
- Allocated portion of deposit is divided into periodic buy intervals  
- Executes purchases at scheduled time  
- Smooths entry into volatile markets  
- Optional take-profit and stop-loss settings  
- Stablecoins not used for DCA remain in low-risk staking  

### User-configurable settings:
- Allocation %  
- DCA interval (daily/weekly/etc.)  
- Amount per interval  
- Stop-loss (optional)  
- Take-profit (optional)  

### Guardrails:
- Cannot DCA into non-whitelisted assets  
- Minimum liquidity required  
- Max slippage threshold enforced  

---

# 3. Strategy Allocation Logic

Each deposit includes a user-defined or AI-defined **allocation distribution** across the three modules.

Example:

| Strategy | Allocation |
|----------|------------|
| Stablecoin Staking | 40% |
| Yield Farming | 30% |
| DCA Trading | 30% |

Total allocation must equal **100%** of net invested funds.

No module is required—users may choose any combination including:

- 100% Stable Staking (Ultra Low Risk)  
- 100% DCA (Medium Risk)  
- 100% Yield Farming (Medium/High Risk within safeguards)  

---

# 4. Engine Execution Flow

Below is the deterministic operational flow for all cycles: 
1.	User signs strategy parameters (no gas)
	2.	User submits deposit transaction (gas)
	3.	Deposit amount – (Deposit Fee + AI Fee) = Net Invested Value
	4.	Engine allocates funds across the three modules
	5.	Modules operate autonomously for 30 days
	6.	All trades, rewards, and adjustments are logged
	7.	Guardrails enforce safety constraints
	8.	At day 30:
a. Engine calculates S, E, F
b. P = max(E - S - F, 0)
c. Veridic generates ProofHash
	9.	LOOP minted only if P > 0
	10.	Rewards are distributed according to user’s compounding choice

---

# 5. Guardrail System

The Yield Engine cannot violate guardrail rules under any conditions.

## 5.1 Universal Guardrails  
- No leverage  
- No borrowing  
- No non-whitelisted assets  
- No high-volatility assets  
- All modules enforce max drawdown thresholds  
- Stablecoin exposure guaranteed if fallback activated  

## 5.2 Strategy-Specific Guardrails

### Stablecoin Staking:
- Reject unstable or unaudited stablecoins  
- Reject protocols with known exploits  
- APY capped within safe ranges  

### Yield Farming:
- IL > predefined threshold → exit to stablecoin staking  
- LP TVL < required minimum → halt entry  
- APR anomaly protection  

### DCA:
- Slippage threshold cannot be bypassed  
- Must use blue-chip assets only  
- Buy intervals must follow approved timing rules  

---

# 6. AI Optimization (Optional)

AI may optimize:

- Allocation %  
- DCA interval + amount  
- LP selection  
- Staking vs. farming weighting  
- Drawdown tolerance  
- Auto-rebalance settings  

### AI Fee:
Deducted from deposit upon cycle creation.

### Model Recommendations:
- o3-mini for numerical optimization  
- GPT-4.1 for reasoning + summaries  

Cost to protocol: ~$0.01–$0.12 per optimization  
Recommended end-user fee: **$1.00**

---

# 7. 30-Day Cycle Behavior

A deposit initiates a **single-user cycle** lasting exactly 30 days.

Cycle is:

- Immutable  
- Non-editable  
- Non-extractable  
- Fully documented  
- Isolated from other cycles  

Users may only withdraw or redeposit after cycle completion.

---

# 8. End-of-Cycle Profit Verification (Veridic)

S = Starting Value
E = Ending Value
F = Friction Costs
P = max(E - S - F, 0)

- If P > 0 → LOOP minted  
- If P = 0 → no minting, no inflation  

The system’s Verified Floor increases permanently only when P > 0.

---

# 9. Reward Distribution

User selects one:

- **Withdraw All**  
- **50% Compound**  
- **Compound All**  

Rewards are distributed in LOOP tokens.

---

# END OF FILE

# YieldLoop + Veridic System Glossary  
### *The Floor Engine Framework*

---

## A. CORE SYSTEM TERMS

### 1. Floor Engine
A novel investment mechanism where **verified trading surplus is continuously converted into a rising intrinsic redemption floor** for a native token. The floor is mathematically protected from decreasing.

### 2. Floor Price (Intrinsic Floor)
Minimum redeemable value of LOOP.

**Equation:**  
`Floor = Backing Pool / Circulating LOOP Supply`

### 3. Backing Pool
Capital backing LOOP. Grows through verified surplus, system deposits, and token burns.

### 4. Verified Surplus
Real trading profit after friction. Enables minting, backing growth, and floor increases.

### 5. System Deposit
Portion of verified surplus allocated directly to the backing pool.

### 6. LOOP Token
Deflationary, floor-backed token minted only from verified surplus.

### 7. Burn / Redemption Function
LOOP can be redeemed at the intrinsic floor. Burning reduces supply and increases the floor.

### 8. Compound All
100% of net profit remains in trading.

### 9. 50/50 Compound Strategy
Half of verified profit compounds; half converts to LOOP.

### 10. Drawdown Cap
Max allowable loss per cycle:  
`Bₜ₊₁ ≥ Bₜ · (1 – d)`

### 11. Safeguard Pause
Automatic trading halt during extreme volatility or anomalies.

---

## B. VERIDIC FRAMEWORK TERMS

### 12. Proof of Profit (PoP)
`P = max(E – S – F, 0)`

Ensures only real profit is counted.

### 13. Friction (F)
Trading costs: gas, spread, slippage.

### 14. Verification Density
% of all flows covered by PoP.

### 15. ProofHash
`H(S ∥ E ∥ F ∥ P ∥ timestamp ∥ anonymizedID)`

Ensures data integrity.

### 16. Impact Allocation (I)
`I = α · P`

### 17. Unified Veridic Equation
`S + (1 – α)P + I = E – F`

---

## C. INTEGRATED FLOOR ENGINE EQUATIONS

### 18. LOOP Minting Formula
`L = γ · P`  
(if P > 0; else L = 0)  
No inflation without verified surplus.

### 19. Backing Pool Growth
`Bₜ₊₁ = Bₜ + System_Deposit + Burn_Value`

### 20. Intrinsic Floor Growth
`Floorₜ = Bₜ / Supplyₜ`

### 21. User Net Profit Per Cycle
`User_Profit = 0.75 · P`  
`Bₜ₊₁ = Bₜ + 0.75P`

### 22. 50/50 Strategy Allocation
- Compounding: `0.375P`  
- LOOP: `0.375P`

### 23. Maximum Loss Bound
`Bₜ₊₁ ≥ Bₜ · (1 – d)`

### 24. Redemption Floor Enforcement
`Redeem_Value = Floorₜ`

---

## D. TAXONOMIC DEFINITIONS

### 25. Floor-Bound Asset
Has a provable redemption minimum.

### 26. Rising-Floor Asset
Floor value never decreases.

### 27. Performance-Backed Asset
Minted only from verified surplus.

### 28. Deflationary Floor Token
Supply decreases while backing increases.

### 29. Floor Engine System
A system converting verified surplus into rising intrinsic value.

---

## E. OPTIONAL ADVANCED TERMS

### 30. Floor Shock Absorption
Redemptions strengthen the floor via supply reduction.

### 31. Backing-to-Supply Ratio (BTS)
`BTS = Backing Pool / Supply`

### 32. Floor Hardening
Rate at which the intrinsic floor increases per cycle.

### 33. Dynamic Floor Equilibrium
Steady-state between surplus, supply, and backing growth.

---

*Glossary Complete.*

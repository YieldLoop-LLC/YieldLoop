# LOOP Token Model & Economic Specification (v0.1)

This document defines the LOOP token, its minting restrictions, economic guarantees, inflation boundaries, and its relationship to the Veridic Proof Engine.  
It explains how LOOP derives value, why its inflation is mathematically constrained, and how the token functions as a “proof-minted asset” rather than a speculative or governance token.

---

# 1. Token Identity

**Token Name:** LOOP  
**Symbol:** LOOP  
**Standard:** ERC-20  
**Minting Model:** Profit-backed (Veridic Verified Profit)  
**Governance:** None (LOOP is not a governance token)

LOOP is minted *only* when the system produces **verified, mathematically-proven profit**.

---

# 2. Core Principle: Profit-Minted Token

LOOP is the first token whose supply is legally and mathematically constrained by an economic law:

\[
P = \max(E - S - F, 0)
\]

Where:

- **P** = verified profit  
- **E** = ending value of the cycle  
- **S** = starting value  
- **F** = friction  

Minting is restricted:

> YieldLoopCore can only mint LOOP equal to `P_verified`, and only after ProofEngine confirms the result.

No P → No minting.  
Negative profit → No minting.  
Fake profit → Rejected by ProofEngine.

This is the entire foundation of LOOP’s supply integrity.

---

# 3. Minting Rules (On-Chain Guarantees)

The following conditions must all be true before a single LOOP token can be minted:

1. **YieldLoopCore** must call `ProofEngine.computeProof()`
2. The ProofEngine must return `P_verified > 0`
3. The returned proofHash must match recomputation
4. YieldLoopCore must hold the **minter role** in AccessController
5. LoopToken’s `mint()` is restricted to minters only
6. The cycle must not be closed already

These constraints prevent:

- Arbitrary minting  
- Privileged inflation  
- Minting based on declared or approximated profit  
- Minting from bad data  

This model ensures LOOP is **mathematically controlled inflation**, not discretionary inflation.

---

# 4. Token Supply Behavior

## 4.1 Supply increases only when real profit is generated
LOOP supply growth is strictly tied to the verified profit of all cycles across all users.

Total supply increases by:

\[
\Delta supply = \sum P_i
\]

Where each \( P_i \) is a verified profit from one cycle.

## 4.2 No premature inflation  
Supply does *not* inflate according to:

- Expectations  
- Projections  
- Governance proposals  
- Market sentiment  
- Oracle conditions

Only **proof-backed economic activity**.

## 4.3 No deflation from burns unless explicitly permitted  
Burning is allowed only for addresses with the minter role.  
This ensures:

- Controlled supply reduction  
- No accidental user burns  
- Governance cannot arbitrarily destroy supply

---

# 5. Value Relationship

LOOP is tied to **cycle-level verified profit**, not:

- TVL  
- Market cap  
- Speculation  
- Volatility  
- Liquidity conditions

Thus:

### LOOP = tokenized verified profit  
### Every LOOP token represents *profit that actually happened*

This gives LOOP real value anchoring:

- No LOOP exists that was not earned  
- Supply cannot outrun economic performance  
- Token value is backed by historical cycle performance

---

# 6. Inflation Boundaries & Safety

### 6.1 Worst-case inflation  
Worst-case minting happens if:

- A cycle makes extremely large profit  
- All profit is verified  
- LOOP mints proportionally  

### 6.2 Best-case inflation  
Best-case inflation occurs when:

- Return cycles are modest  
- Friction offsets gains  
- Many cycles yield no mint  

In these scenarios, LOOP supply grows extremely slowly.

### 6.3 Inflation as a function of system efficiency  
Higher strategy performance → higher LOOP inflation  
Lower strategy performance → lower LOOP inflation

Unlike normal tokens:

> LOOP inflation is an economic performance indicator.

---

# 7. Token Utility

### 7.1 Proof-of-Profit asset  
LOOP embodies realized profit, making it:

- Backed  
- Auditable  
- Cryptographically verified  
- Resistant to manipulation  

### 7.2 Exchangeable asset  
LOOP may be used for trading, swapping, staking (future), or liquidity provisioning.

### 7.3 Veridic ecosystem token  
Designed for long-term integration into:

- YieldLoop products  
- Proof-based financial instruments  
- Veridic ESG/Impact reward systems  
- Proof-of-Impact economies  

---

# 8. Security & Abuse Prevention

## 8.1 No one can increase supply except YieldLoopCore
And YieldLoopCore can only do so under strict verification rules.

## 8.2 The ProofEngine prevents fraudulent inflation  
Any of these would fail verification:

- Fake E  
- Fake F  
- Wrong S  
- Altered timestamp  
- Wrong P  
- Wrong hash  

## 8.3 AccessController prevents unauthorized parties from minting  
Only addresses explicitly granted the minter role (typically just YieldLoopCore) may mint.

---

# 9. Token Economics vs. Traditional Tokens

| Property | Traditional Tokens | LOOP |
|---------|--------------------|------|
| Supply growth | Discretionary | Mathematical, verified |
| Inflation source | Governance or policy | Profit only |
| Backing | None or partial | Verified profit history |
| Minting authority | Many actors | Single core engine |
| Minting conditions | Policy-driven | Proof-driven |
| Speculation dependency | High | Lower |

LOOP is one of the first tokens to operate under a **formal economic law** rather than human decision-making.

---

# 10. Future Extensions

Future versions may include:

- Zero-knowledge proofs of profit  
- Multi-token reward models  
- Inflation smoothing  
- Collateralized LOOP deposits  
- Cross-chain LOOP supply synchronization  
- Multi-chain LOOP-backed derivatives  

---

# End of TOKEN_MODEL.md

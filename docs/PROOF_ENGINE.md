# Veridic Proof Engine – Mathematical & Technical Specification (v0.1)

This document describes the mathematical law, computation rules, and hashing process used by the Veridic Proof Engine inside YieldLoop.

It defines **how verified profit is computed** and **how proof hashes guarantee immutability, auditability, and cryptographic integrity.**

---

# 1. The Veridic Law of Verified Profit

At the heart of the system is a conservation rule:

\[
P = \max(E - S - F, 0)
\]

Where:

- **S** — starting value of the cycle  
- **E** — ending value after strategy execution  
- **F** — friction (fees, losses, system overhead)  
- **P** — *verified* profit  

This equation enforces:

- No speculative or declared profit  
- Profit must be provably generated  
- Profit cannot be negative  
- Profit cannot be gamed by inflating values  

This is the **canonical version** of the profit law.

---

# 2. Proof Hash Construction

After computing `P`, the system constructs a cryptographic proof:

\[
\text{proofHash} = H(S \parallel E \parallel F \parallel P \parallel t)
\]

Where:

- `H` is Keccak-256  
- `||` means concatenation  
- `t` is a timestamp  
- All fields are encoded using `abi.encodePacked`  

This produces a unique, immutable fingerprint of the cycle.

Changing **any** value changes the hash.

---

# 3. Why the ProofHash Matters

The system uses the proof hash to guarantee:

### ✔ Immutability  
Once stored, no actor can alter S, E, F, or P without invalidating the hash.

### ✔ Auditability  
An auditor can recompute P and hash from raw values and confirm authenticity.

### ✔ Transparency  
Users can independently verify:

- Their profit  
- The equation  
- The inputs  
- The resulting hash  

### ✔ Restriction on Token Minting  
LoopToken will only mint tokens when YieldLoopCore supplies:

- A valid P  
- A matching proofHash  

Thus:

> **Every LOOP token is backed by a valid proof.**

---

# 4. `computeProof` Function Specification

Pseudo-code equivalent to the Solidity implementation: 
function computeProof(S, E, F, t):
if E > S + F:
P = E - S - F
else:
P = 0

proofHash = keccak256(encode(S, E, F, P, t))
return (P, proofHash)

This logic is:

- Deterministic  
- Pure (no state access)  
- Immutable  
- Verifiable off-chain  

---

# 5. `verifyProof` Function Specification

To verify a proof:
function verifyProof(S, E, F, P, t, proofHash):
(expectedP, expectedHash) = computeProof(S, E, F, t)

This guarantees:

- P was not altered  
- Hash was not altered  
- Inputs were not altered  

If anything mismatches, verification fails.

---

# 6. Example (Illustrative Only)

Given:
S = 1000
E = 1080
F = 20
t = 1700000000

Then:

P = max(1080 - 1000 - 20, 0)
P = 60

ProofHash:
keccak256(S, E, F, P, t)

This matches the Solidity `computeProof` output.

---

# 7. Off-Chain vs On-Chain Implementations

The Proof Engine can be implemented:

### **On-Chain**
- Pure Solidity logic  
- Immutable  
- Cheap (low complexity)  
- Fully transparent  

### **Off-Chain**
- Python / Rust / JavaScript  
- Used for analytics, simulation, dashboards  
- Must match on-chain equation exactly  

### **Hybrid**
- Off-chain compute engine  
- On-chain final verification  

YieldLoopCore always trusts **only the canonical on-chain version**.

---

# 8. Security Properties

## 8.1 Profit cannot be faked  
To fake profit, an attacker must fake:

- S  
- E  
- F  
- P  
- proofHash  

But YieldLoopCore and ProofEngine recompute these, so mismatches are rejected.

## 8.2 Minting is tightly bound  
LoopToken only mints through YieldLoopCore, and that contract only mints after:

- ProofEngine confirms P  
- hash is valid  

## 8.3 Deterministic fairness  
The system cannot accidentally mint more or less than intended.

---

# 9. Alignment With Veridic Theory

This engine enforces:

- Verified profit only  
- Entropy reduction through validation  
- Proof-backed token inflation  
- Immutable history  

The Proof Engine is the **mathematical enforcement mechanism** behind the Veridic economic model.

---

# End of PROOF_ENGINE.md

# SECTION 2 — FULL USER EXPERIENCE (Depositor Persona)

This section defines the complete user-facing experience for the YieldLoop platform from the perspective of a depositor (“the user”). It outlines the emotional tone, the functional flow, and the screen-by-screen UX goals. The purpose is to ensure the end user experiences simplicity, clarity, and trust at every step.

---

# 1. User Persona Definition

**The Depositor**  
A retail or semi-professional user who:

- Wants simplified DeFi exposure  
- Wants to avoid complexity of yield, arbitrage, or strategy design  
- Expects transparency and verification  
- Wants to understand but not be overwhelmed  
- Trusts data over hype  

Their journey must be:  
**Simple → Safe → Verified → Rewarding**

---

# 2. User Emotional Tone

The UI should feel:

- Clean  
- Minimal  
- Friendly  
- “No thinking required”  
- Focused on *verified results*, not speculation  

The user should never feel:

- Rushed  
- Confused  
- Exposed to hidden risk  
- Required to understand technical details  

---

# 3. High-Level User Flow

Landing Page
↓
Connect Wallet
↓
Start New Cycle
↓
Select Deposit + Risk Level
↓
Review Proposed Strategy
↓
Approve & Begin Cycle
↓
Cycle Running (Live View)
↓
Cycle Closed → Proof Ready
↓
View Proof → LOOP Minted
↓
Portfolio Dashboard Updates

This is a **closed-loop journey**, repeated every 30 days.

---

# 4. Core Screens & Detailed UX

## 4.1 User Dashboard (Home After Login)

**Purpose:** Show the user everything that matters *at a glance*.

**Displays:**
- Current LOOP balance  
- Total verified profit earned  
- Active cycle status  
- Historical performance (simple graph)  
- Button: **Start New Cycle**  
- Button: **View All Cycles**  

Design tone:  
**Like a clean banking app, not a trading terminal.**

---

## 4.2 Start Deposit / Begin Cycle Flow

A guided wizard with the following steps:

### Step 1 — Enter Deposit Amount
- User inputs amount
- System checks:
  - Min deposit  
  - Wallet balance  
  - Network comfort (gas, RPC health)

### Step 2 — Choose Risk Level
Options:
- Ultra Low  
- Low  
- Medium  
- High  
- Unrestricted (advanced toggle)

Each includes:
- Simple explanation  
- Approximate strategy types  
- Safety warnings  

### Step 3 — System Generates Proposed Strategy
This page shows:

- “You are depositing: X”
- “Your cycle will follow this strategy: …”
- A bulleted explanation of:
  - Yield sources  
  - Arbitrage opportunities  
  - Risk profile  
  - No guaranteed return  
  - Proof verification at end  

**Button: APPROVE STRATEGY**

User cannot skip this.

### Step 4 — Approval & Confirmation
Wallet pops up → user approves.

UI shows:

- “Your cycle has begun”
- Cycle ID
- Timer until next phase

---

## 4.3 Cycle Viewer (Running Cycle)

Shows:

- Status: RUNNING  
- Start amount (S)  
- Countdown until cycle close  
- (Optional) Strategy summary  
- Links to help articles explaining the process  

User sees **no technical noise** — the focus is reassurance.

---

## 4.4 Cycle Closure View

When a cycle ends:

- Banner: “Your cycle is complete”
- Summary card:
  - S (start)
  - E (end)
  - F (friction)
  - **P (verified profit)**
- “View Proof” button  
- “Add LOOP to wallet” button  

---

## 4.5 Proof Viewer

This is your **signature UX moment** — the Veridic experience.

Shows:

- S, E, F, P  
- ProofHash  
- Timestamp  
- Formula preview:  
  `P = max(E - S - F, 0)`  
- “Verify this proof yourself” with expandable instructions  
- JSON export button  
- Link to GitHub / Explorer  

The viewer must feel:
**Transparent, scientific, immutable.**

---

## 4.6 Historical Cycles

Displays a table:

| Cycle | S | E | F | P | Status | Proof |
|------|---|---|---|---|--------|-------|

Filter by:

- Date  
- Risk  
- Profit outcome (profit = 0, profit > 0)  

---

## 4.7 LOOP Token Wallet View

Shows:

- Current LOOP balance  
- LOOP transaction history (mints only)  
- Value chart  
- Link to LOOP token page  
- Explanation of “profit-minted token economics”

---

# 5. User Support Screens

## 5.1 FAQ
Plain-language explanations of:

- How cycles work  
- How proofs work  
- Why LOOP minting is tied to profit  
- What happens if P = 0  

## 5.2 Error Handling Pages
Examples:

- “Strategy engine temporarily unavailable”  
- “Cycle cannot be closed yet”  
- “Proof validation mismatch — cycle halted (admin notified)”  

---

# 6. Summary of User Experience Philosophy

The user should always understand:

- What they did  
- What is happening  
- What they received  
- Why they received it  

But they should never have to understand:

- Smart contracts  
- Arbitrage theory  
- Price impact  
- Technical indicators  
- How the strategy engine works  

The UI wraps all complexity in a layer of **absolute clarity**.

---

End of SECTION 2

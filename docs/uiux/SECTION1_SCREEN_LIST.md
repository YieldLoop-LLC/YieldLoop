# SECTION 1 — COMPLETE SCREEN LIST (ALL PERSONAS)

This section lists all major screens/routes in the YieldLoop + Veridic product,
grouped by access level and persona.

The goal is to give designers and developers a clear map of the user interface
surface area before visual design begins.

---

## 1. Public Screens

These are visible without connecting a wallet or logging in.

- **Landing Page**
  - High-level explanation of YieldLoop + Veridic
  - Call-to-action buttons: “Connect Wallet”, “View Docs”, “Learn Veridic”

- **About Veridic**
  - Explains the Veridic Law of Verified Profit
  - Links to academic/technical papers and GitHub

- **Token Info**
  - LOOP token explanation
  - High-level inflation model (profit-minted only)
  - Links to explorer and docs

- **Public Proof Explorer (Read-Only)**
  - Selected public cycles
  - Example proofs
  - Educational view of S/E/F/P and proof hashes

- **Documentation Hub**
  - Links to whitepaper, GitHub, API docs, academic docs
  - Links to Veridic student resources

---

## 2. User Screens (Depositor Persona)

Accessible after wallet connection.

- **User Dashboard**
  - Overview of:
    - LOOP balance
    - Active cycles
    - Total verified profit
    - Historical performance summary

- **Deposit / Start Cycle Flow**
  - Step-by-step wizard:
    1. Choose deposit asset/amount
    2. Choose risk level
    3. Review proposed strategy
    4. Approve transaction

- **Cycle Viewer**
  - View a specific cycle’s:
    - Status (RUNNING, CLOSED, etc.)
    - S (starting value)
    - Projected behavior (high-level)
    - Timeline

- **Proof Viewer (Per Cycle)**
  - S, E, F, P, timestamp
  - Proof hash
  - “Verify this proof” button with instructions

- **Historical Cycles List**
  - Paginated list of all user cycles
  - Filters by date, result, strategy type

- **Token / Balance View**
  - LOOP balance
  - Token transfer history (on-chain view)
  - Links to external explorer

---

## 3. Admin Screens (Operator Persona)

Restricted to authorized admin/operator addresses.

- **Admin Dashboard**
  - System-level metrics:
    - Total cycles
    - Cycles by state
    - Total P minted
    - Total fees routed
    - Last error / alert

- **Cycle Control Panel**
  - View all active/incoming cycles
  - Tools for:
    - Manually closing a cycle (if needed)
    - Pausing new cycle creation
    - Triggering fail-safe behaviors

- **Proof Validation Panel**
  - Inspect specific cycles:
    - S, E, F, P, t
    - Submitted vs recomputed proof hash
  - PASS/FAIL indicators

- **Access Control Manager**
  - View/add/remove:
    - Admin addresses
    - Minter/Operator addresses
  - Warnings on dangerous changes

- **Fee Router Configuration**
  - Set/update:
    - Basis point allocations
    - Recipient addresses
  - Simulate a fee distribution

- **System Health & Logs**
  - Contract version info
  - Heartbeat of external strategy engine(s)
  - Error log summaries
  - Upcoming upgrade notes

---

## 4. Academic / Veridic Student Screens

Focused on exploration, validation, and learning.

- **Academic Dashboard (Veridic Hub)**
  - Quick access to:
    - Proof Engine explorer
    - Simulation tools
    - Data explorer (CycleRegistry)
    - Batch proof verifier
    - Educational materials

- **Proof Engine Explorer**
  - Manual input fields:
    - S, E, F, t
  - Outputs:
    - P (verified profit)
    - proofHash
  - Visual graph of relationships

- **Simulation Sandbox**
  - Run hypothetical cycles (not real funds)
  - Vary S/E/F over ranges
  - Display charts of P vs. inputs
  - Export result sets (CSV/JSON)

- **Cycle Registry Browser**
  - Query real cycles:
    - By time range
    - By strategy type (if tagged)
    - By performance profile
  - Download anonymized data

- **Batch Proof Verifier**
  - Upload CSV of S/E/F/P/t/proofHash
  - Recompute and show:
    - Valid rows
    - Failed rows
  - Export validation report

- **Veridic Learning Module**
  - Stepwise explanation of:
    - P = max(E - S - F, 0)
    - Profit region vs zero-profit region
  - Interactive sliders and graphs

---

## 5. Internal / Utility Screens (Optional Future)

Not required at MVP, but useful later.

- **Notification Center**
  - For both admins and users
  - Cycle events, warnings, system messages

- **API Key Management (If external dev API is added)**
  - Issue/revoke keys
  - Track usage

- **Audit / Export Center**
  - Generate data exports for:
    - Legal
    - Accounting
    - Academic partners

---

This screen list acts as the baseline scope for UI/UX design and can be refined over time as the product evolves.

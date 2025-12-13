┌───────────────┐
│   User Wallet │
│───────────────│
│ Deposit       │
│ Profit Pref   │
│ Withdraw Req  │
└───────┬───────┘
        │
        ▼
┌──────────────────────────┐
│   Cycle Manager          │
│──────────────────────────│
│ 30-Day Fixed Cycle       │
│ Cycle Open / Close       │
│ Start & End Recording    │
└─────────┬────────────────┘
          │
          ▼
┌──────────────────────────┐
│   Strategy Engine        │
│──────────────────────────│
│ Grid Trading (BTC/ETH)   │
│ Stablecoin Staking       │
│ Yield Farming            │
│ Guardrails Active        │
└─────────┬────────────────┘
          │
          ▼
┌──────────────────────────┐
│   Verification Layer     │
│──────────────────────────│
│ Friction Aggregation     │
│ Surplus Calculation     │
│ Proof Hash Generation   │
│ Binary Outcome Gate     │
└─────────┬────────────────┘
          │
          ▼
┌──────────────────────────┐
│   Economic Router        │
│──────────────────────────│
│ User Settlement          │
│ Fee Distribution         │
│ LOOP Mint / Backing      │
└─────────┬────────────────┘
          │
          ▼
┌──────────────────────────┐
│   UI / Audit Surface     │
│──────────────────────────│
│ Cycle Reports            │
│ Proof Hash Display       │
│ Receipts & History       │
└──────────────────────────┘

Diagram 1: YieldLoop System Overview

This diagram illustrates the end-to-end architecture of the YieldLoop protocol.
All user capital flows through a fixed 30-day cycle, bounded strategy execution,
and a mandatory verification layer before any economic action may occur.

No fees, minting, backing allocation, or settlement may execute without a valid
cycle proof hash produced by the Verification Layer.

This structure enforces proof-based finance by design.

# YieldLoop Engine Diagram (Core 4 + Rebalance + Veridic Layer)

```
┌───────────────────────────────────────────┐
│          USER DEPOSIT & SIGNATURE         │
└───────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                   STRATEGY ROUTER                           │
│  Allocates capital across the 5 Safe Engines                │
│  Enforces config, risk level, and safety rules              │
└─────────────────────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         THE FIVE SAFE ENGINES                           │
├─────────────────────────────────────────────────────────────────────────┤
│  1. YIELD FARMING                                                       │
│     • PCS/Biswap blue-chip and stable pairs                             │
│     • Earns real swap fees and rewards                                  │
│                                                                         │
│  2. GRID TRADING                                                        │
│     • Buy-low/sell-high micro-harvesting                                │
│     • Tight-band volatility capture                                     │
│                                                                         │
│  3. STABLECOIN STAKING                                                  │
│     • A++ grade audited platforms                                       │
│     • Low-volatility baseline income                                    │
│                                                                         │
│  4. SAME-CHAIN DEX ARBITRAGE                                            │
│     • PancakeSwap ↔ Biswap                                              │
│     • No leverage, micro-spread capture                                 │
│                                                                         │
│  5. AUTOMATED REBALANCING                                               │
│     • Maintains BTC/ETH/BNB/stable weighting                            │
│     • Reduces drift and volatility                                      │
└─────────────────────────────────────────────────────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────────────────────┐
│                  ENGINE OUTPUT ROUTER (EOR)               │
│      Consolidates results and calculates verified profit  │
└───────────────────────────────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────────────┐
│                      VERIDIC VERIFICATION LAYER                      │
│        Verifies S, E, F, and P(v) and generates ProfitHash           │
└──────────────────────────────────────────────────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────────────────────┐
│              LOOP GENERATION (PROFIT → VALUE)             │
│         LOOP minted only from verified profit             │
└───────────────────────────────────────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────────────────────┐
│               FEE DISTRIBUTION (VERIFIED PROFIT)          │
│     Owner share • Growth pool • War chest • Profit pool   │
│                Buyback + permanent staking                │
└───────────────────────────────────────────────────────────┘
                   │
                   ▼
┌───────────────────────────────────────────────────────────┐
│                 USER DASHBOARD + PROOF REPORTS            │
│       Cycle summary • Profit • LOOP • ProofHash           │
└───────────────────────────────────────────────────────────┘
```

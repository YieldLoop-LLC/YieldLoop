# YieldLoop / Veridic API Specification (v0.1)

This document describes the initial REST/JSON API for interacting with the YieldLoop Proof Engine and accessing verifiable data.

This API can be implemented as:
- A separate backend service connected to on-chain contracts, or
- A thin wrapper around direct contract calls.

---

## Authentication

- Public read endpoints: no auth required.
- Write / user-specific endpoints: JWT / API key / wallet signature (TBD).
- All responses are JSON.

---

## Endpoints

---

# 1. Health & Metadata

## GET /v1/health

Returns basic service status.

**Response**
```json
{
  "status": "ok",
  "network": "base-mainnet",
  "block_height": 12345678,
  "version": "0.1.0"
}

GET /v1/config

Returns current global configuration and system parameters.

{
  "fee_rates": {
    "performance": 0.25,
    "dev_share": 0.10,
    "marketing_share": 0.05,
    "system_deposit_share": 0.05,
    "impact_share": 0.05
  },
  "alpha_impact": 0.05,
  "min_deposit": "50.0",
  "cycle_length_days": 30,
  "veridic_equation": "P = max(E - S - F, 0)"
}

GET /v1/users/{wallet}/cycles

List all cycles associated with a user.

[
  {
    "cycle_id": "0xabc...",
    "status": "closed",
    "start_block": 12345000,
    "end_block": 12375000,
    "asset": "USDC",
    "S": "1000.00",
    "E": "1080.00",
    "F": "20.00",
    "P_verified": "60.00",
    "impact_allocated": "3.00",
    "proof_hash": "0x123...",
    "tx_hash": "0x456..."
  }
]

GET /v1/cycles/{cycle_id}

Fetch detailed information for a single cycle.

{
  "cycle_id": "0xabc...",
  "user": "0xUser...",
  "S": "1000.00",
  "E": "1080.00",
  "F": "20.00",
  "P_verified": "60.00",
  "impact_allocated": "3.00",
  "system_deposit_gain": "17.00",
  "dev_fee": "24.00",
  "marketing_fee": "12.00",
  "network": "base-mainnet",
  "start_block": 12345000,
  "end_block": 12375000,
  "proof_hash": "0x123...",
  "proof_engine_contract": "0xProof...",
  "tx_hash": "0x456...",
  "loop_minted": "60.00",
  "loop_redeemed": "0.00"
}

GET /v1/proofs/{proof_hash}

Retrieve the record corresponding to a given proof hash.

{
  "proof_hash": "0x123...",
  "S": "1000.00",
  "E": "1080.00",
  "F": "20.00",
  "P_verified": "60.00",
  "timestamp": "2025-01-01T00:00:00Z",
  "cycle_id": "0xabc...",
  "user": "0xUser...",
  "contract_address": "0xProof...",
  "tx_hash": "0x456..."
}

POST /v1/proofs/verify

Verify a set of values against a proof hash.

{
  "S": "1000.00",
  "E": "1080.00",
  "F": "20.00",
  "P": "60.00",
  "t": 1700000000,
  "proof_hash": "0x123..."
}

{
  "valid": true,
  "message": "Proof matches computed ProofHash.",
  "equation": "P = max(E - S - F, 0)"
}


GET /v1/system/summary

High-level system metrics.

{
  "total_users": 1234,
  "total_cycles": 9876,
  "total_verified_profit": "452345.32",
  "total_impact_funded": "22617.27",
  "system_deposit_balance": "125000.00",
  "loop_supply": "8123456.78",
  "verification_density": 0.99,
  "approx_entropy_proxy": 0.05
}

GET /v1/system/timeseries?metric=verified_profit&interval=day

Returns time series data for a given metric.


Final Notes

This spec will evolve.
The core rule of this API and the entire YieldLoop system is:

Nothing is ever called profit unless it is proven.

---

## ✅ That is the entire file.  
Copy all of it into: api/API_SPEC.md
Commit it.  
Done.

---

When you're ready:

**Next patch**

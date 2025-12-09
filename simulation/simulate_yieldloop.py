import numpy as np
import pandas as pd
from dataclasses import dataclass
from hashlib import sha256
from typing import List, Dict

@dataclass
class CycleParams:
    n_users: int = 100
    n_cycles: int = 120
    base_return_mean: float = 0.01
    base_return_std: float = 0.03
    fee_rate: float = 0.0025
    alpha_impact: float = 0.05  # fraction of verified profit to impact pool
    dishonest_prob: float = 0.0  # probability a cycle attempts to over-report

def proof_of_profit(S: float, E: float, F: float) -> float:
    """Veridic profit definition."""
    return max(E - S - F, 0)

def proof_hash(S: float, E: float, F: float, P: float, t: int) -> str:
    payload = f"{S:.8f}|{E:.8f}|{F:.8f}|{P:.8f}|{t}"
    return sha256(payload.encode("utf-8")).hexdigest()

def run_simulation(params: CycleParams) -> pd.DataFrame:
    # Start each user with 1.0 unit
    balances = np.ones(params.n_users)
    system_deposit = 0.0
    impact_pool = 0.0

    rows = []

    for cycle in range(params.n_cycles):
        # Simulate raw returns for each user
        raw_returns = np.random.normal(
            loc=params.base_return_mean,
            scale=params.base_return_std,
            size=params.n_users
        )

        for user_id in range(params.n_users):
            S = float(balances[user_id])

            gross_E = S * (1 + raw_returns[user_id])
            F = gross_E * params.fee_rate
            E = gross_E - F

            # Optional dishonest attempt (Scenario B)
            dishonest = np.random.rand() < params.dishonest_prob
            if dishonest:
                # Over-report profit by some percentage
                claimed_E = E * np.random.uniform(1.1, 1.5)
                P_claimed = proof_of_profit(S, claimed_E, F)
                # But Veridic engine still uses real E
                P_verified = proof_of_profit(S, E, F)
            else:
                P_claimed = None
                P_verified = proof_of_profit(S, E, F)

            # Yield-to-Impact
            impact = params.alpha_impact * P_verified
            user_profit_after_impact = P_verified - impact

            # Update balances
            balances[user_id] = S + user_profit_after_impact
            system_deposit += F  # simple placeholder: all fees → system_deposit
            impact_pool += impact

            phash = proof_hash(S, E, F, P_verified, cycle)

            rows.append({
                "cycle": cycle,
                "user_id": user_id,
                "S": S,
                "E": E,
                "F": F,
                "P_verified": P_verified,
                "P_claimed": P_claimed,
                "impact": impact,
                "user_balance": balances[user_id],
                "system_deposit": system_deposit,
                "impact_pool": impact_pool,
                "dishonest": dishonest,
                "proof_hash": phash,
            })

    return pd.DataFrame(rows)

if __name__ == "__main__":
    params = CycleParams()
    df = run_simulation(params)
    # Make sure the /simulation/data directory exists before running this
    df.to_csv("data/cycles_baseline.csv", index=False)
    print(df.head())

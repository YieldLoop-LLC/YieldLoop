Inputs: S, E, F, t
                 +-----------------------+
                 |     Proof Engine      |
                 |  P = max(E-S-F, 0)    |
                 |  H = keccak(S,E,F,P,t)|
                 +-----------+-----------+
                             |
                             v
                +------------+--------------+
                |  Verified Profit (P)      |
                |  Proof Hash (H)           |
                +------------+--------------+

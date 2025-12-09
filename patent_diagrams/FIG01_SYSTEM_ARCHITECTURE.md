+----------------------+
|      User Wallet     |
+----------+-----------+
           |
           | S (deposit)
           v
+----------------------+          +----------------------+
|    YieldLoop Core    |<-------->|   Access Controller  |
| (cycle orchestration)|          | (roles/permissions)  |
+----+---------+-------+          +----------+-----------+
     |         |                             |
     |calls    |calls                        |
     v         v                             v
+----+------------------+         +-----------------------+
|     Proof Engine      |         |      Loop Token       |
| (compute P, hash)     |         | (mint restricted)     |
+----+------------------+         +-----------+-----------+
     |                                      |
     | P, proofHash                         |
     v                                      |
+----+------------------+                   |
|      Fee Router       |-------------------+
| (split friction F)    |
+----+------------------+
     |
     |
     v
+----+------------------+
|     Cycle Registry    |
| (read/index layer)    |
+-----------------------+

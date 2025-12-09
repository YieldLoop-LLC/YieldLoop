# Contributing to YieldLoop / Veridic

Thank you for your interest in contributing to the YieldLoop + Veridic project.  
This repository is a hybrid research + engineering effort, and we welcome contributions
that improve clarity, correctness, or functionality.

---

# 1. Project Structure

This repo contains:

- `contracts/` — Solidity smart contract scaffolds  
- `api/` — API specifications and interface definitions  
- `academic/` — academic papers, theoretical summaries  
- `patent/` — patent preparation notes (public-safe content only)  
- `docs/` — general documentation  
- `.github/` — templates and contribution guidelines  

Please place changes in the appropriate directory.

---

# 2. Branching Model

Use the following:

- `main` — stable version  
- `dev` — active development  
- Feature branches:
  - `feature/<your-feature-name>`  
  - Example: `feature/add-proof-batching`  

Pull requests should target **dev**, not main.

---

# 3. Coding Standards

### Solidity
- Follow the latest Solidity style guide.
- Include NatSpec comments for all public/external functions.
- Avoid hardcoded addresses, percentages, constants.
- All state changes should emit events.
- No business logic tied to fixed tokenomics; use configurable parameters.

### Markdown / Docs
- Use clear, concise language.
- Technical claims must be verifiable or marked as theoretical.
- Do not include confidential or patent-sensitive details.

---

# 4. Pull Request Standards

Your PR **must include**:

1. Clear description of the change  
2. Why this change is necessary  
3. Files affected  
4. Any risks or breaking changes  
5. Test or validation notes (if applicable)  

PRs without explanation may be rejected.

---

# 5. Issues

When submitting an issue:

- Use **Issue Templates** if available.
- Provide steps to reproduce.
- Include expected vs actual behavior.
- Reference related files or lines if known.

---

# 6. Intellectual Property

All contributions:

- Must be original  
- Must not violate third-party IP  
- Are contributed under the project license (MIT unless updated)  
- May be incorporated into future patent filings  

If you are unsure, open an issue for discussion.

---

# 7. Security Disclosure

If you discover a vulnerability:

**Do not** open a public issue.

Instead email: founder@yieldloop.io

Provide:

- Description of vulnerability  
- How it can be reproduced  
- Suggested fix (if known)  

We follow responsible disclosure principles.

---

# 8. Roadmap (High-Level)

Contributions are especially welcome in:

- Proof batching  
- Multi-cycle aggregation  
- Off-chain computation modules  
- Formal verification of the ProofEngine  
- Frontend integration  
- Analytics dashboards  
- Testing frameworks  

---

Thank you for contributing to the YieldLoop + Veridic ecosystem.  
Your work helps build the world’s first **proof-verified economic engine**.


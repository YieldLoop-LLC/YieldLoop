# Security Policy

The YieldLoop + Veridic project takes security seriously.  
This repository contains smart contracts, economic engines, and verification logic that may eventually control user funds.  
Please follow the guidelines below for reporting vulnerabilities responsibly.

---

# 1. Supported Versions

We currently support security reports for:

- `main` branch  
- `dev` branch  
- Any tagged release version  

Experimental feature branches may not be actively monitored.

---

# 2. How to Report a Vulnerability

If you find a security issue, **DO NOT** open a public GitHub issue.

Instead, please report privately via email: founder@yieldloop.io

Include:

- A clear description of the vulnerability  
- Steps to reproduce  
- Impact assessment (what could happen if exploited)  
- Suggested fix (if known)  
- Any relevant environment details (network, branch, commit hash)

We follow responsible disclosure practices and will respond promptly.

---

# 3. What to Expect After Reporting

Once we receive your report:

1. We confirm receipt within 72 hours.  
2. We investigate the issue.  
3. If valid, we work on a patch or mitigation.  
4. We may request additional details from you.  
5. After a fix is deployed, we may publicly credit you (optional).  

All communication remains confidential until the issue is resolved.

---

# 4. Scope

Security researchers may examine:

- Smart contracts in `contracts/`  
- API specifications in `api/`  
- Documented algorithms  
- The ProofEngine logic  
- Token issuance constraints  
- Fee routing logic  

Not in scope:

- Phishing simulations  
- Social engineering attacks  
- Attacks requiring physical access  
- Issues in unrelated infrastructure not owned by YieldLoop/Veridic  

---

# 5. Responsible Disclosure Guidelines

Please:

- Do not exploit the vulnerability beyond what is necessary to demonstrate it.  
- Do not access user data.  
- Do not violate laws or breach terms of service.  
- Give us reasonable time to fix the issue before public disclosure.  

We appreciate ethical security research and will treat it with respect.

---

# 6. Rewards / Acknowledgments

At this stage, YieldLoop does not offer monetary bug bounties.  
However, we:

- Publicly acknowledge researchers (optional)  
- May offer future incentives as the project grows  

Thank you for helping secure the first **proof-verified economic engine**.


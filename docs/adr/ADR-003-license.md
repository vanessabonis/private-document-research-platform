# ADR-003: License

- **Status:** Accepted
- **Date:** 2026-10-01

## Context

This repository is a personal portfolio proof of concept. It is public, and its history is permanent: anything released under a license cannot be taken back for the copies already distributed.

Two goals pull in different directions:

- **Portfolio goal:** anyone, including recruiters and engineers, must be able to read the code, clone it and run it locally to evaluate the work.
- **Possible future sale:** the project might become something worth selling or building a product on. A license that lets anyone use the code commercially would weaken that option.

The project plan (`docs/PROJECT_PLAN.md`, section 2) asks for a deliberate license decision on Day 1 instead of defaulting to a permissive license.

## Decision

License the repository under **PolyForm-Noncommercial-1.0.0** (SPDX identifier).

- The full official text is in `LICENSE`, unmodified.
- The `Required Notice:` line the license asks to be preserved is in `NOTICE`: `Required Notice: Copyright 2026 Vanessa Bonifacio`.
- The copyright holder remains the only party who can grant other licenses (for example a commercial license) because the license is non-exclusive and does not transfer ownership.

In practice: reading, running, studying and modifying the code for noncommercial purposes is allowed (personal study, hobby projects, research, educational and other noncommercial organizations). Commercial use requires a separate agreement with the copyright holder.

## Consequences

Positive:

- The code is public and inspectable, which serves the portfolio goal.
- Commercial reuse by third parties is not permitted, which keeps a future sale or commercial license possible.
- PolyForm licenses are short, written in plain language and include a patent license and a 32-day cure period for violations.

Negative (be aware of these):

- **It is not open source.** It does not meet the OSI Open Source Definition, because it restricts a field of use. The project must not be described as "open source". Use "source-available" instead.
- **Evaluation by a company is a gray area.** The license permits personal research and testing "without any anticipated commercial application" and use by noncommercial organizations. A company that wants to try the code to evaluate the author or the project may not clearly fall under a permitted purpose. Some reviewers may avoid running it for that reason.
- **Reduced adoption and contributions.** Many developers and companies avoid non-OSI licenses. Outside contributors would need to agree on terms (for example a contributor license agreement) before their code can be included in a possible commercial offering. Until then, outside contributions should not be accepted without that discussion.
- **Enforcement is hard.** The license has no technical enforcement. Detecting and acting on commercial misuse depends on the copyright holder.
- **Irrevocable for existing copies.** Anyone who already received the code keeps their noncommercial rights under these terms. A future change of license only affects new releases.
- **Tooling friction.** GitHub and some license scanners will not show a standard open source license badge for it. The "noncommercial" boundary is also open to interpretation in edge cases.
- This is not legal advice. Before any real sale or commercial licensing, the license choice and the ownership of all contributions should be reviewed by a lawyer.

## Alternatives considered

### MIT

Very short permissive license, OSI approved, most familiar to reviewers and easiest for anyone to adopt.

- Pros: maximum visibility and adoption, no friction for recruiters, easy to accept contributions.
- Cons: anyone can use, modify and sell the code with only an attribution requirement. It gives no patent grant. A future sale of the code itself would have little exclusivity.
- Not chosen because it gives up the commercial option for the sake of portfolio simplicity.

### Apache-2.0

Permissive, OSI approved, includes an explicit patent grant and a clear contribution clause.

- Pros: strong credibility, patent protection, well understood by companies.
- Cons: same commercial openness as MIT. Longer text and a NOTICE requirement.
- Not chosen for the same reason as MIT. It would be the choice if the goal were adoption and community over a future sale.

### Source-available / noncommercial (chosen family)

Other options in this family exist, for example Business Source License (BUSL-1.1), which restricts production use until a change date, or custom noncommercial terms.

- Pros: keeps the code visible while reserving commercial rights.
- Cons: not OSI open source, less familiar to reviewers, and custom terms require legal review. BUSL is aimed at production use by software vendors and adds a conversion date that is not needed for a POC.
- PolyForm Noncommercial was preferred in this family because it is standardized, short, written in plain language and drafted by lawyers.

### Private core with a reduced public version

Keep the full implementation private and publish only a smaller version (for example the ingestion and retrieval parts) under a permissive license.

- Pros: strongest protection of what might be sold, and the public part can still use MIT or Apache-2.0.
- Cons: the portfolio shows less of the work (for example the privacy gateway and audit log, which are the most distinctive parts). It means maintaining two code bases or a split, and the public project is harder to demonstrate end to end. It also conflicts with the plan's goal of a complete public repository with a demo.
- Not chosen because the main portfolio value is the complete, runnable system.

## Revisit

Revisit this decision if the project gains outside contributors, if the commercial option is dropped (then a permissive license becomes the simpler choice), or if the evaluation gray area above turns out to block real reviewers.

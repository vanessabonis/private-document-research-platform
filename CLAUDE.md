# CLAUDE.md

Instructions for Claude when working in this repository.

## Project

`private-document-research-platform` is a personal proof of concept for private research and document analysis over a confidential document collection, sending external LLM APIs only the minimum context required. Work in progress (started October 2026).

Source of truth for scope, process and checklist: `docs/PROJECT_PLAN.md`.

Planned stack: Java 21, Spring Boot, Maven, PostgreSQL with pgvector, Ollama (local embeddings), Anthropic API (answer generation), Docker Compose.

## Communication

- Talk to the user in Brazilian Portuguese. Keep technical terms in English.
- Everything written to the repository (code, comments, commit messages, docs, issues, pull requests) is in English.
- Be concise and practical. Do not use em dashes.
- Be honest and critical: point out design flaws, scope creep, security risks and weak spots. Do not agree just to be agreeable.
- The user must be able to explain and defend every line. Explain the reasoning and trade-offs behind decisions instead of only handing over code. For non-trivial changes, summarize what changed and why.

## Hard rules

- Public or synthetic data only. Never use code, data or material from the user's employer or its clients.
- No secrets in git. API keys only through environment variables. Never read, print or commit `.env` files.
- Never put real documents, personal data or API keys in tests, fixtures, logs or examples.
- Do not log document content, prompts that contain document text, or secrets.
- Stay in scope. Work only on the story the user names. Do not create files, add dependencies or refactor code that was not requested. Mention out-of-scope ideas instead of implementing them.
- Do not commit, push or open pull requests unless the user asks.

## Architecture rules (apply as the code appears)

- Every outbound LLM call goes through the egress gateway. No other class calls an LLM provider directly.
- Send the minimum context: a limited number of chunks within a token budget. PII is masked before anything leaves the machine.
- Every outbound call is recorded in the audit log (when, who, which chunks), without secrets.
- Document text is untrusted input. It must never change instructions, tools or permissions (prompt injection).
- Retrieval is filtered by the permissions of the user asking.
- Answers cite document and page, and the system refuses to answer when the retrieved context is insufficient.

## Workflow

- Conventional Commits: `feat:`, `fix:`, `docs:`, `test:`, `chore:`.
- Branches: `feat/E2-S3-hybrid-search` (epic, story, short name). Keep pull requests small.
- Definition of Done: merged to `main` through a pull request, tests cover the core logic, CI is green, docs updated if behavior changed, no secrets or real data, board and `docs/PROJECT_PLAN.md` updated.
- Meaningful trade-offs get a short ADR in `docs/adr/` (`ADR-NNN-title.md` with context, decision and consequences). Suggest an ADR whenever a decision deserves one.
- Before saying work is done, run the build and the tests and report the result. Never claim something works without running it.

## Daily log and checklist

When the user asks to fill the log, close the day or update the plan (and only then), do the following:

1. **Ground it in facts.** Check `git status`, today's `git log` and the diff summary. Do not invent work that did not happen.
2. **Update `docs/PROJECT_PLAN.md`.** Tick an acceptance criterion only when it is verifiably done (the file exists, the test passes, the command works). Tick a story only when all of its criteria are ticked. Update the "Last updated" line.
3. **Create or update `docs/log/YYYY-MM-DD.md`** using this template:

   ```
   Date:
   Sprint / Story:
   Done today:
   Decisions (ADR needed?):
   Blockers:
   Tomorrow's slice:
   Hours: plan __ build __ study __ wrap __
   ```

   - Fill "Done today", "Decisions" and "Blockers" from the session and the git history.
   - Propose "Tomorrow's slice" from the plan and label it as a proposal.
   - Leave "Hours" for the user. Ask for anything that cannot be known from the code, such as study topic, hours or blockers that are not visible in the repository.
4. On the last day of a sprint, offer to draft `docs/retros/sprint-N.md` from the retro template in `docs/PROJECT_PLAN.md`.
5. Show a short summary of the changes. Do not commit unless asked. Remind the user to replace `docs/PROJECT_PLAN.md` in their Claude Project knowledge and to paste the log in the project chat.

# Project Plan: Private Document Research Platform (POC)

> Working title: `TBD` (decide on Day 1)
> Start: Thu, Oct 1, 2026 | Budget: 5h/day | Target: public repo + demo video by Oct 31, 2026
> This file is the source of truth. Update the checkboxes here and mirror them on the GitHub Projects board.
> Last updated: Thu, Oct 1, 2026 (Day 1)

---

## 1. Product goal

Deliver a functional, secure proof of concept of a private research and document-analysis platform. It runs over a confidential document collection, sends external LLM APIs only the minimum context required, and can be demoed, tested and understood by someone who is not the author.

**Success criteria**

- [ ] Two workflows work end to end: (1) cited Q&A over a private collection, (2) document analysis with suggested edits
- [ ] A written and enforced policy of what may and may not be sent to an external API
- [ ] Retrieval quality measured on an evaluation set, results published in the repo
- [ ] Security review completed, findings and fixes documented
- [ ] Runs locally with one command (Docker Compose)
- [ ] Public README, architecture docs, ADRs, demo video

**Non-goals (out of scope)**

Multi-tenant SaaS, billing, model fine-tuning, mobile app, real client data, production-grade high availability, OCR for scanned documents (stretch only).

---

## 2. Ground rules

- **Public or synthetic data only.** Never use data, code or material from an employer or its clients.
- **English everywhere:** code, commits, docs, issues, README, demo.
- **Honest positioning.** This is a personal POC built on public documents. No claims of domain expertise. Describe what was built and what was measured.
- **License is a deliberate decision (Day 1, ADR-003).** Permissive licenses (MIT/Apache-2.0) allow anyone to reuse the code. If a future sale is possible, consider a source-available or noncommercial license, or keep a private core and publish a reduced public version.
- **Decisions go in ADRs.** Every meaningful trade-off gets a short Architecture Decision Record in `docs/adr/`.
- **No secrets in git.** API keys only via environment variables. Secret scanning on from Day 1.
- **LLM tools are practical instruments.** Use AI assistance for speed, but you must be able to explain and defend every line in the repo.

---

## 3. Process (changes)
- No fixed calendar: this is a hobby project. Work flows by priority.
- WIP limit of 1: one story and one open branch at a time.
- A work day keeps the Plan / Build / Study / Wrap format, with hours chosen per day.
- Retro at each milestone instead of each sprint.
- Milestones replace sprints. Each one must be demonstrable in 2 minutes.

---

## 4. Milestones
| Milestone | Goal | Stories |
| --- | --- | --- |
| M1 Ingest | One PDF ingested and retrievable by a SQL query | E0-S3 (reduced), E1-S1 to E1-S4 |
| M2 Ask | `POST /ask` returns an answer with verifiable citations | E2-S1 to E2-S6 |
| M3 Egress (minimum showable) | Nothing leaves the machine without passing the gateway, audit log proves it. README and a short video | E3-S1 to E3-S4, E3-S6, E3-S7 |
| M4 Use | Both workflows work in the browser, quality measured | E3-S5, E4, E5, E6-S1 to E6-S3 |
| M5 Launch | Security review, docs, deploy guide, packaging | E6-S4 to E6-S7, E7 |

Capacity per sprint: about 21h of build, 6h of study, 3h planning and 3h wrap-up (about 33h with the buffer day not counted).

---

## 5. Epics

| ID | Epic |
|---|---|
| E0 | Foundation and setup |
| E1 | Document ingestion and indexing |
| E2 | Retrieval and cited answers (workflow 1) |
| E3 | Privacy and security controls |
| E4 | Document analysis and editing (workflow 2) |
| E5 | Web application |
| E6 | Quality, security review and documentation |
| E7 | Launch and career packaging |

---

## 6. Sprint backlog and checklist

### Sprint 1 (Oct 1 to 7): Foundation and ingestion

**Study (about 6h):** RAG fundamentals, embeddings and chunking strategies, pgvector and PostgreSQL full-text search, Spring AI overview.

- [x] **E0-S1 \[M\] Repo and governance (1.5h):** repo created, LICENSE, README skeleton, issue and PR templates, board, labels
- [x] **E0-S2 \[M\] Scope and ADRs (2h):** one-page scope; ADR-001 local hybrid retrieval; ADR-002 domain and corpus; ADR-003 license
- [ ] **E0-S3 \[M\] Corpus (1.5h):** reduced first: 3 to 5 public documents to unblock parsing, rest of the corpus (20 to 50) later; `samples/` folder, `SOURCES.md` with URL and license of each
- [x] **E0-S4 \[M\] Dev environment (4h):** Docker Compose with PostgreSQL + pgvector and Ollama, embedding model pulled, Spring Boot skeleton with health endpoint, config profiles (ADR-004)
- [x] **E0-S5 \[M\] CI and security baseline (2h):** GitHub Actions build and test, Dependabot, secret scanning, CodeQL
- [ ] **E1-S1 [M] Parsing (2h):** Apache Tika extraction for PDF, DOCX, TXT with metadata (title, source, page)
    - [ ] Apache Tika extracts text from PDF, DOCX and TXT
    - [ ] Metadata captured: title, source, page
    - [ ] Unit tests with sample files
- [ ] **E1-S2 [M] Chunking (3h):** configurable size and overlap, page references preserved, unit tests
    - [ ] Chunk size and overlap are configurable
    - [ ] Page references preserved in each chunk
    - [ ] Unit tests cover edge cases
- [ ] **E1-S3 [M] Embeddings and storage (3h):** schema (documents, chunks, embeddings), Flyway migrations, batch ingestion command
    - [ ] Schema for documents, chunks and embeddings, managed by Flyway
    - [ ] Batch ingestion command
    - [ ] One PDF ingested and retrievable by a SQL query
- [ ] **E1-S4 [S] Idempotent ingestion (2h):** content hash to skip unchanged files, progress logging
    - [ ] Content hash used to skip unchanged files
    - [ ] Progress logging during ingestion

**Sprint goal check:** one PDF ingested and retrievable by a SQL query.

### Sprint 2 (Oct 8 to 14): Retrieval and cited answers

**Study (about 6h):** hybrid search and Reciprocal Rank Fusion, reranking basics, grounded-answer prompt design, Anthropic Messages API, retrieval metrics (recall@k, MRR).

- [ ] **E2-S1 [M] Vector search endpoint (2h)**
- [ ] **E2-S2 [M] Full-text search endpoint (2h)**
- [ ] **E2-S3 [M] Hybrid ranking (3h):** RRF fusion, compared against each method alone
- [ ] **E2-S4 [M] LLM client abstraction (3h):** provider interface, Anthropic implementation, OpenAI stub, timeouts, retries, config
- [ ] **E2-S5 [M] Grounded answers with citations (4h):** response includes document and page for each claim; refuses when context is insufficient
- [ ] **E2-S6 [M] Initial evaluation set (3h):** 10 questions with expected source passages, script that reports recall@k
- [ ] Reserve (4h): carry-over from Sprint 1

**Sprint goal check:** `POST /ask` returns an answer with verifiable citations.

### Sprint 3 (Oct 15 to 21): Privacy, security and analysis

**Study (about 6h):** OWASP Top 10 for LLM applications, prompt injection, PII detection (regex and NER), threat modeling (STRIDE), Spring Security basics.

- [ ] **E3-S1 [M] Data egress policy v1 (2h):** `docs/DATA_POLICY.md` with data classes and what may be sent externally
- [ ] **E3-S2 [M] Egress gateway (3h):** single choke point for every outbound LLM call, minimal context builder (max chunks, token budget)
- [ ] **E3-S3 [M] PII masking (3h):** detect and mask before sending, mapping kept locally, tests
- [ ] **E3-S4 [M] Audit log (2h):** every outbound call recorded (when, who, which chunks), no secrets stored
- [ ] **E3-S5 [M] Authentication and authorization (3h):** login, roles, per-collection access, retrieval filtered by permission
- [ ] **E3-S6 [M] Prompt injection defenses (2h):** document text treated as untrusted, tests with malicious documents
- [ ] **E3-S7 [M] Threat model (2h):** `docs/THREAT_MODEL.md`
- [ ] **E4-S1 [M] Document analysis (3h):** summary and key points extraction with structured output
- [ ] **E4-S2 [C] Suggested edits (3h):** proposed changes shown as a diff, never applied automatically

**Sprint goal check:** an outbound call without passing through the gateway is impossible by design, and the audit log proves it.

### Sprint 4 (Oct 22 to 28): Web app and quality

**Study (about 5h):** RAG evaluation approaches, frontend basics for the chosen stack, security review checklist.

- [ ] **E5-S1 [M] UI skeleton (2h):** login, collection selector
- [ ] **E5-S2 [M] Search and Q&A screen (4h):** answers with citations and a source viewer
- [ ] **E5-S3 [M] Document analysis screen (3h):** select document, results, diff view
- [ ] **E5-S4 [C] Admin view (2h):** ingestion status, audit log
- [ ] **E6-S1 [M] Evaluation set to 25 to 30 questions (3h):** report with recall@k, MRR and a manual groundedness check
- [ ] **E6-S2 [S] Tuning (2h):** chunk size and top-k compared, results recorded
- [ ] **E6-S3 [M] Integration tests (3h):** main flows covered
- [ ] **E6-S4 [M] Security review pass (3h):** SAST, dependency and secret scans, manual checklist, findings logged in `docs/SECURITY_REVIEW.md`

**Sprint goal check:** a non-technical person can run both workflows in the browser.

### Launch (Oct 29 to 31)

- [ ] **E6-S5 [M] Fix security findings (3h)**
- [ ] **E6-S6 [M] Deployment guide (3h):** one-command run verified on a clean machine or VM
- [ ] **E6-S7 [M] Documentation (3h):** final README, architecture diagram, ADRs reviewed, limitations and next steps
- [ ] **E7-S1 [M] Demo video (2h):** 3 to 5 minutes, English
- [ ] **E7-S2 [M] GitHub packaging (1h):** pinned repo, topics, badges, screenshots
- [ ] **E7-S3 [M] Resume and LinkedIn (2h):** project entry, 3 resume bullet variants, announcement post
- [ ] **E7-S4 [C] Write-up (1h):** short article on the egress gateway design

---

## 7. Career packaging notes

- Describe it as a **personal proof of concept**, not a client product.
- Lead with engineering outcomes you measured, for example retrieval recall on your evaluation set, number of enforced privacy controls, one-command deploy.
- Name tools as practical instruments (Spring Boot, pgvector, Ollama, Anthropic API), not as buzzwords.
- Do not claim domain expertise in the corpus area. State it plainly: "validated on public documents."
- Keep the repo clean enough that a reviewer can run it in 10 minutes.

---

## 8. Risks and cut order

| Risk | Mitigation |
|---|---|
| Scope creep | MoSCoW labels, Sprint goal check each Day 1 |
| Weak hardware for local embeddings | Smaller embedding model, fewer documents |
| API cost | Spending cap, cheaper model during development |
| Burnout from 5h every day | Day 7 of each sprint is buffer and rest |
| Domain gap | Public corpus, honest positioning |
| Corpus licensing | `SOURCES.md` records source and license of every file |

**Cut order if behind:** (1) E4-S2 suggested edits, (2) E5-S4 admin view, (3) OpenAI implementation, (4) per-collection access control (keep simple roles). **Never cut:** egress gateway, audit log, evaluation set, README.

---

## 9. Daily log template

```
Date:
Sprint / Story:
Done today:
Decisions (ADR needed?):
Blockers:
Tomorrow's slice:
Hours: plan __ build __ study __ wrap __
```

---

## 10. Sprint retro template

```
Sprint:
Goal met? (yes/partial/no):
What worked:
What did not:
Carry-over to next sprint:
One change for next sprint:
```
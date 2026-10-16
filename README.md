# Private Document Research Platform (working title: TBD)

A personal proof of concept for private research and document analysis over a confidential document collection. Indexing and retrieval run locally, and an external LLM API receives only the minimum context required for each answer.

![Build status](https://img.shields.io/badge/build-not%20configured-lightgrey)

> **Status:** work in progress (started October 2026). Built and validated on public or synthetic documents only. The status badge above is a placeholder until CI exists (E0-S5).

## Planned workflows

1. **Cited Q&A:** ask a question over a private document collection and get an answer that cites document and page. The system refuses to answer when the retrieved context is insufficient.
2. **Document analysis with suggested edits:** summarize a document, extract key points and propose edits shown as a diff. Edits are never applied automatically.

## Planned architecture (placeholder)

Subject to change. Details will be documented in `docs/` and in ADRs under [docs/adr](docs/adr).

- Local ingestion, chunking and embeddings (Ollama)
- Hybrid retrieval (vector and full-text) on PostgreSQL with pgvector
- A single egress gateway for every outbound LLM call, with PII masking and an audit log
- Java 21, Spring Boot, Maven, simple web UI, Docker Compose

## Security and privacy stance

Document text is treated as untrusted input, retrieval is filtered by the permissions of the user asking, and nothing leaves the machine without passing through the egress gateway, which sends a limited amount of masked context and records an audit entry. The formal policy will live in `docs/DATA_POLICY.md` (planned, not written yet).

## How to run

Docker Compose, coming in E0-S4.

## Roadmap

The scope, sprints and checklist are in [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md). Summary:

| Sprint | Dates | Goal |
|---|---|---|
| Sprint 1 | Oct 1 to 7 | Ingest a document and find it through the database |
| Sprint 2 | Oct 8 to 14 | Ask a question and get a cited answer through the API |
| Sprint 3 | Oct 15 to 21 | Nothing leaves the machine without passing the privacy gate; analyze a document |
| Sprint 4 | Oct 22 to 28 | Usable in a browser, with measured quality |
| Launch | Oct 29 to 31 | Security fixes, docs, deploy guide |

## Limitations

- This is a personal proof of concept, not a production system.
- It is validated on public or synthetic documents only. No real or client data is used.
- Non-goals: multi-tenant SaaS, billing, fine-tuning, mobile app, production-grade high availability.
- No claims are made about expertise in any specific document domain.

## License

Licensed under [PolyForm Noncommercial 1.0.0](LICENSE). This is a source-available license, not an open source license: noncommercial use is allowed, commercial use requires a separate agreement with the copyright holder. See [NOTICE](NOTICE) for the required notice and [ADR-003](docs/adr/ADR-003-license.md) for the reasoning and trade-offs.

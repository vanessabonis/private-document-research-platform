# private-document-research-platform

A personal proof of concept for private research and document analysis over a confidential document collection, sending external LLM APIs only the minimum context required.

> **Status:** work in progress (started October 2026). Built on public or synthetic documents only. This is a personal POC, not a production system.

## Problem

Teams that hold confidential documents want AI-assisted search and analysis, but cannot send those documents to a cloud LLM freely. This project explores an architecture where indexing and retrieval run locally and an external LLM API is called only with the minimum context needed for each answer.

## Planned workflows

1. Cited Q&A over a private document collection
2. Document analysis with suggested edits

## Planned architecture (subject to change)

- Local ingestion, chunking and embeddings
- Hybrid retrieval (vector + full-text) on PostgreSQL with pgvector
- A single egress gateway for every outbound LLM call, with PII masking and an audit log
- Spring Boot backend, simple web UI, Docker Compose

## Non-goals

Multi-tenant SaaS, billing, fine-tuning, real client data, production-grade high availability.

## Project plan

See [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md).

## License

To be decided (see ADR-003).
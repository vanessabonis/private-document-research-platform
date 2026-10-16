# Scope

## Problem

Teams that hold a confidential document collection want to search it and analyze it with an LLM, but sending whole documents to an external API is a privacy risk. This project explores a design where indexing and retrieval run locally and an external LLM API sees only the minimum context needed for each answer: a limited number of chunks within a token budget, with PII masked.

## Workflows

1. **Cited Q&A over a private collection.** The user asks a question and gets an answer that cites document and page. The system refuses to answer when the retrieved context is insufficient. Retrieval is filtered by the permissions of the user asking.
2. **Document analysis with suggested edits.** The user selects a document and gets a summary, key points and proposed edits shown as a diff. Edits are never applied automatically.

## Design constraints

- Retrieval and embeddings run locally ([ADR-001](adr/ADR-001-local-hybrid-retrieval.md)).
- Every outbound LLM call passes through one egress gateway and is recorded in an audit log.
- Document text is untrusted input and cannot change instructions, tools or permissions.
- Built and validated on a public corpus ([ADR-002](adr/ADR-002-domain-and-corpus.md)). License: [ADR-003](adr/ADR-003-license.md).

## Non-goals

- Multi-tenant SaaS
- Billing
- Model fine-tuning
- Mobile app
- Real client data
- Production-grade high availability
- OCR for scanned documents (stretch only)

## Positioning

A personal proof of concept validated on public documents, with no claim of domain expertise.

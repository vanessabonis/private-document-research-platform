# ADR-001: Local hybrid retrieval

- **Status:** Accepted
- **Date:** 2026-10-15

## Context

The platform answers questions over a confidential document collection (see [SCOPE.md](../SCOPE.md)). Answer quality needs a strong LLM, and a strong LLM today means an external API. The privacy goal is that the external provider sees as little of the collection as possible.

Two steps touch the documents: retrieval (finding relevant chunks) and generation (writing the answer from those chunks). Retrieval needs access to the whole collection. Generation needs only a few chunks per question. This asymmetry decides where the trust boundary goes.

Constraints: a single developer, consumer hardware, Java 21 and Spring Boot, one-command local run with Docker Compose.

## Decision

Retrieval and embeddings run locally. Only answer generation calls an external LLM API.

- **Storage and search:** PostgreSQL with pgvector for vector search and PostgreSQL full-text search for keyword search, in one database.
- **Fusion:** the two ranked lists are combined with Reciprocal Rank Fusion (RRF). Hybrid ranking is compared against each method alone on the evaluation set.
- **Embeddings:** generated locally with Ollama and a small embedding model, during ingestion and for each query.
- **Generation:** an external LLM API (Anthropic first) receives only the top retrieved chunks within a token budget, with PII masked, and only through the egress gateway.

## Consequences

Positive:

- The full collection and its embeddings never leave the machine.
- One database holds documents, chunks, vectors and full-text indexes, so permission filters apply to both search methods in a single place.
- Hybrid search covers both semantic matches and exact terms such as identifiers and citation numbers, where embeddings alone are weak.
- The external provider can be swapped behind one interface.

Negative (be aware of these):

- **Local embedding quality.** Small local models are weaker than hosted embedding models, especially on long or technical text. Recall may be lower. This must be measured on the evaluation set, not assumed.
- **Hardware limits.** Embedding a collection on a laptop CPU or small GPU is slow, and model size is capped by available memory. The corpus size (20 to 50 documents) is chosen with this in mind.
- **Latency.** Each query needs a local embedding call, two searches and a network call to the LLM. The first Ollama call after idle can be slow while the model loads.
- **Operational weight.** Running Ollama and PostgreSQL adds setup and failure modes compared with a single hosted service.
- **What still leaves the machine.** The question text and the selected chunks (masked) are sent to the external provider on every answer, and the provider's own retention and logging policies apply. Masking is imperfect and can miss PII. Local retrieval reduces exposure but does not remove it.
- **Embeddings are not anonymous.** They are kept local because they can leak information about the source text.

## Alternatives considered

### Fully external RAG

Use a hosted embedding API and a hosted vector store or search service, plus an external LLM.

- Pros: best embedding quality, no local hardware limit, least operational work.
- Not chosen because the whole collection would be sent to third parties, which contradicts the core goal of the project.

### Fully local LLM

Run both embeddings and answer generation locally with Ollama.

- Pros: nothing leaves the machine, so the egress gateway would have little to protect.
- Cons: models that fit consumer hardware give weaker, less reliable grounded answers and citations. Slow generation hurts the demo.
- Not chosen because the project's value is the controlled-egress design with a capable external model. A local generation provider can still be added behind the same interface later.

### Vector search only

Use pgvector without full-text search.

- Pros: simpler, one index type.
- Not chosen because exact terms (section numbers, names, defined terms) are common in legal-style documents and embeddings handle them poorly. Full-text search is cheap to add in PostgreSQL.

### Dedicated vector database

Use a separate store such as Qdrant or Weaviate.

- Pros: purpose-built features and scaling.
- Not chosen because it adds a service and splits permission filtering across two systems. At this scale pgvector is enough.

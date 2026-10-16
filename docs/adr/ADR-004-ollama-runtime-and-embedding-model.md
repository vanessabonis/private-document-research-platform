# ADR-004: Ollama runtime and embedding model

- **Status:** Accepted
- **Date:** 2026-10-15

## Context

[ADR-001](ADR-001-local-hybrid-retrieval.md) decided that embeddings are generated locally with Ollama. Two follow-up decisions are needed before any ingestion code is written:

1. Which embedding model to use.
2. How Ollama runs on the developer machine.

The first decision has a long tail. The embedding dimension becomes a column type in the database schema (E1-S3), and every stored vector and every query vector must come from the same model.

The second decision is about reproducibility versus speed. The project goal is "runs locally with one command" (Docker Compose), but the main development machine is an Apple Silicon Mac. Docker Desktop on macOS runs containers in a Linux virtual machine that cannot use the Apple GPU. Ollama inside Docker therefore runs on CPU only, while Ollama installed natively on the Mac uses the GPU through Metal.

## Decision

### Decision 1: embedding model `nomic-embed-text`

Use `nomic-embed-text` (137M parameters, **768 dimensions**), pulled through Ollama. The model name is configurable with `OLLAMA_EMBEDDING_MODEL`.

- **The dimension will be fixed in the schema in E1-S3.** The vector column will be declared with 768 dimensions. Changing the model later (or any model with a different dimension) means a schema migration and **re-embedding the whole corpus**. Vectors from different models cannot be mixed or compared.
- **The model expects task prefixes on the input text.** Use `search_document: ` for chunks at ingestion time and `search_query: ` for user questions. Without the prefixes, retrieval quality drops. The prefix handling belongs in the embedding client (E1-S3), and the evaluation (E2-S6) should confirm that it is applied.
- **Input length is limited.** Text beyond the context window is truncated by Ollama by default, so chunk size must stay well below it. The effective limit must be checked when chunking is designed (E1-S2). The model metadata reported by Ollama shows a 2048-token context.

### Decision 2: Ollama in Docker Compose by default, host Ollama as an option

- **Default (a):** Ollama runs as a service in `compose.yaml` with a pinned image tag and a named volume for models. `docker compose up -d` is the only command needed, and every developer gets the same Ollama version.
- **Option (b):** Ollama installed on the host. The application and `scripts/pull-embedding-model.sh` read the Ollama URL from `OLLAMA_BASE_URL`, so switching is a one-variable change. When using the host Ollama, start only the other services (`docker compose up -d postgres`), because the Compose service and the host Ollama would otherwise compete for the same port.

Both the Compose Ollama and the host Ollama are reached only on `localhost`. Nothing is exposed on other interfaces.

## Consequences

Positive:

- One command starts the whole environment, and the Ollama version is pinned, which supports the "reviewer can run it in 10 minutes" goal.
- `nomic-embed-text` is small (about 270 MB), fast on CPU, available in Ollama with a single pull and has a reasonable quality for its size.
- The base URL variable keeps the faster path open without changing code or Compose files.

Negative (be aware of these):

- **Lock-in to 768 dimensions.** A model change after E1-S3 costs a migration and a full re-embedding. With a 20 to 50 document corpus the re-embedding is cheap, but the migration and the evaluation results are not, so a model comparison should happen before E1-S3 closes.
- **CPU-only embeddings on Apple Silicon in Docker.** Ingestion and each query embedding are slower than with the native GPU. For a small corpus this is acceptable. For larger collections option (b) is noticeably faster.
- **Two paths to test.** Option (b) is not covered by the default setup, so it can drift. Results (for example evaluation numbers) should state which runtime produced them.
- **Different runtimes can produce slightly different vectors.** CPU and GPU numeric behavior is not identical. Do not mix vectors from two runtimes in one index without re-embedding.
- **Missing prefixes fail silently.** The model still returns vectors without them, only worse ones. This needs a test or a guard in the embedding client.
- **Model quality ceiling.** A 137M model is weaker than larger or hosted models, especially on long or very technical text. This is an accepted trade-off from ADR-001 and must be measured, not assumed.
- **Image size and first start.** The Ollama image is large and the model has to be pulled once with `scripts/pull-embedding-model.sh`. The model is stored in a named volume and survives `docker compose down` (it is removed only with `down -v`).
- **Input length limit.** The model reads at most 2048 tokens per input. Longer text is truncated silently by default, so the embedding would represent only the beginning. Chunk size (in tokens, including any task prefix) must stay below this limit. Enforced and tested in E1-S2.

## Alternatives considered

### mxbai-embed-large

Larger model (335M parameters, 1024 dimensions), usually stronger on retrieval benchmarks.

- Pros: better expected quality.
- Cons: slower on CPU, larger vectors (more storage and slower search), and a shorter input window than other options, which forces smaller chunks.
- Not chosen as the default because speed on a CPU-only container matters for a one-command demo. It remains the first candidate if the evaluation shows weak recall.

### bge-m3

Multilingual model (about 567M parameters, 1024 dimensions) with a long input window.

- Pros: long context and multilingual support.
- Cons: the largest and slowest of the options, and multilingual support is not needed because the corpus is in English.
- Not chosen because the extra cost buys features this project does not use.

### all-minilm

Very small model (about 23M parameters, 384 dimensions).

- Pros: fastest, smallest vectors, minimal hardware needs.
- Cons: short input window and clearly lower quality on long, technical text, which would hurt legal-style documents.
- Not chosen because quality is the weak point of local embeddings already (ADR-001), and this model widens the gap.

### Ollama only on the host

Skip the Compose service and require a native Ollama installation.

- Pros: GPU speed on Apple Silicon, no large image.
- Cons: not reproducible (version and OS differ per machine), more manual steps for a reviewer, and the one-command goal is lost.
- Not chosen as the default. It stays supported as option (b).

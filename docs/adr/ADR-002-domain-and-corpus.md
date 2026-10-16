# ADR-002: Domain and corpus

- **Status:** Accepted
- **Date:** 2026-10-15

## Context

The platform needs a realistic document collection to build and evaluate against. Real confidential documents cannot be used (see [SCOPE.md](../SCOPE.md). The corpus must be public, redistributable in a public repository, and verifiable by a reviewer.

The author has no professional expertise in any of the candidate domains. The domain is a test bed, not a claim of competence.

## Decision

Use **legal-style documents from U.S. federal government sources that are in the public domain** (for example federal agency guidance, regulations and similar official publications).

The corpus is selected against these criteria. The actual download and `SOURCES.md` are done in E0-S3, not here.

- **License verifiable:** each document has a stated source and a public domain status that can be checked at the source. U.S. federal government works are generally public domain, but this is checked per document, not assumed (see consequences).
- **Format:** PDF, DOCX or TXT. PDFs must have extractable text. Scanned PDFs are excluded because OCR is a non-goal.
- **Size of collection:** 20 to 50 documents.
- **No personal data:** no documents that contain names of private individuals, case files or contact details beyond official ones.
- **Layout manageable:** prefer documents of moderate length with clear page numbers, so citations by page are testable.
- **** the user question goes through the same masking before leaving the machine

## Consequences

Positive:

- Legal-style text has structure (sections, numbered clauses, defined terms, cross references) that exercises chunking, hybrid search and citations well.
- Questions with a verifiable answer in a specific page are easy to write for the evaluation set.
- Public domain material can be committed to a public repository and demoed freely.
- The embedding model and its dimension are fixed in the schema; changing them requires re-embedding the corpus

Negative (be aware of these):

- **No domain expertise.** The author cannot judge whether an answer is legally correct. The evaluation checks that an answer is grounded in the cited passage, not that it is right in a legal sense. The project must not be presented as legal tooling.
- **Corpus licensing.** "U.S. federal" does not guarantee public domain. Documents can include third-party material (images, tables, quoted text), can be produced by contractors, or can be hosted on sites with their own terms. Each document needs a recorded source URL and a license check in `SOURCES.md`. When in doubt, exclude the document.
- **Parsing risks.** Legal PDFs often use multiple columns, footnotes, headers and footers repeated on every page, and tables. Text extraction can interleave columns or merge footnotes into body text, which hurts chunking and page citations.
- **Document size.** Long documents (hundreds of pages) produce many chunks, slow local embedding and make page-level evaluation harder. A cap on length is part of the selection.
- **Possible LLM prior knowledge.** Well-known public documents may be partly memorized by the external model, which can make answers look grounded when they are not. The evaluation should include questions whose answers depend on the retrieved passage.
- **Realism gap.** Public documents are less sensitive than a real confidential collection and have different noise and structure. The privacy controls must be tested with synthetic sensitive content as well, never with real personal data.

## Alternatives considered

### Financial regulation

Public filings and regulator publications (for example securities or banking guidance).

- Pros: public and well structured, many sources.
- Cons: heavy use of tables and numbers, which are the hardest case for PDF extraction and chunking. Filings are very long. Correctness is also hard for a non-expert to judge.
- Not chosen because parsing difficulty would dominate the project and hide the retrieval and privacy work.

### Health

Public clinical guidelines or health agency publications.

- Pros: public material is abundant.
- Cons: wrong or misleading answers carry a higher risk of harm, and the author cannot validate medical content. Licensing is mixed, since many guidelines belong to journals or societies. The topic invites personal health data, which conflicts with the no-personal-data rule.
- Not chosen because of the safety risk, the licensing mix and the personal data temptation.

### Synthetic documents only

Generate fake documents with an LLM.

- Pros: no licensing question, full control over content.
- Cons: less realistic layout and noise, and generated text is too uniform for a meaningful retrieval evaluation.
- Not chosen as the main corpus. Small synthetic documents may still be used later for privacy and prompt injection tests.

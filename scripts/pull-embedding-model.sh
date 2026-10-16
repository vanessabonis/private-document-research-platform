#!/usr/bin/env bash
# Pulls the embedding model into Ollama. Safe to re-run: it does nothing if the model is present.
# Talks to the Ollama HTTP API, so it works for the Compose container and for Ollama on the host.
#
# Environment variables (defaults match .env.example):
#   OLLAMA_BASE_URL         default http://localhost:11434
#   OLLAMA_EMBEDDING_MODEL  default nomic-embed-text
set -euo pipefail

base_url="${OLLAMA_BASE_URL:-http://localhost:11434}"
model="${OLLAMA_EMBEDDING_MODEL:-nomic-embed-text}"

# Ollama lists models with an explicit tag, so compare against "<name>:latest" when no tag is given.
case "$model" in
  *:*) wanted="$model" ;;
  *)   wanted="$model:latest" ;;
esac

if ! tags="$(curl -fsS --max-time 10 "$base_url/api/tags")"; then
  echo "Cannot reach Ollama at $base_url. Is it running? (docker compose up -d)" >&2
  exit 1
fi

if printf '%s' "$tags" | grep -Fq "\"name\":\"$wanted\""; then
  echo "Model $wanted is already present at $base_url. Nothing to do."
  exit 0
fi

echo "Pulling $model from $base_url (this can take a few minutes)..."
response="$(curl -fsS "$base_url/api/pull" -d "{\"model\":\"$model\",\"stream\":false}")"

if printf '%s' "$response" | grep -Fq '"status":"success"'; then
  echo "Model $model pulled."
else
  echo "Pull did not report success: $response" >&2
  exit 1
fi

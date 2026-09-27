#!/usr/bin/env bash
#
# One-shot local dev environment setup (Document 17, Phase 0).
#
# Reproducibility baseline: documents the exact toolchain versions used so a
# fresh clone + this script produces a working build without manual
# fixing (Phase 0 exit criterion, Document 10's determinism principle
# applied to the dev environment itself).
#
# Exact versions pinned here:
#   Go      1.22.x   (see control-plane/go.mod, worker-agent/go.mod)
#   Node.js 20.x LTS (see website/package.json engines-equivalent below)
#   Docker  24.x+    (required starting Phase 4 for sandboxing; checked now
#                     so Phase 4 doesn't surprise you with a missing dep)
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

log()  { printf '\033[1;34m[setup]\033[0m %s\n' "$1"; }
fail() { printf '\033[1;31m[setup] ERROR:\033[0m %s\n' "$1" >&2; exit 1; }

REQUIRED_GO_MAJOR_MINOR="1.22"
REQUIRED_NODE_MAJOR="20"

log "Checking prerequisites..."

if ! command -v go >/dev/null 2>&1; then
  fail "Go is not installed. Install Go ${REQUIRED_GO_MAJOR_MINOR}.x from https://go.dev/dl/ and re-run this script."
fi
GO_VERSION="$(go version | grep -oE 'go[0-9]+\.[0-9]+' | sed 's/go//')"
log "Found Go ${GO_VERSION}"
if [[ "${GO_VERSION}" != "${REQUIRED_GO_MAJOR_MINOR}" ]]; then
  log "WARNING: expected Go ${REQUIRED_GO_MAJOR_MINOR}.x, found ${GO_VERSION}. Continuing, but mismatches can cause subtle build differences later."
fi

if ! command -v node >/dev/null 2>&1; then
  fail "Node.js is not installed. Install Node.js ${REQUIRED_NODE_MAJOR}.x LTS from https://nodejs.org/ and re-run this script."
fi
NODE_MAJOR="$(node -v | sed 's/v//' | cut -d. -f1)"
log "Found Node.js v$(node -v | sed 's/v//')"
if [[ "${NODE_MAJOR}" != "${REQUIRED_NODE_MAJOR}" ]]; then
  log "WARNING: expected Node.js ${REQUIRED_NODE_MAJOR}.x, found v${NODE_MAJOR}.x. Continuing, but mismatches can cause subtle build differences later."
fi

if ! command -v npm >/dev/null 2>&1; then
  fail "npm is not installed (should ship with Node.js). Re-install Node.js."
fi

if ! command -v docker >/dev/null 2>&1; then
  log "WARNING: Docker not found. Not required until Phase 4 (sandbox execution), but install it before then: https://docs.docker.com/get-docker/"
fi

if ! command -v git >/dev/null 2>&1; then
  fail "git is not installed."
fi

log "Building control-plane..."
(cd control-plane && go build -o bin/control-plane ./cmd/control-plane)
log "control-plane built -> control-plane/bin/control-plane"

log "Building worker-agent..."
(cd worker-agent && go build -o bin/worker-agent ./cmd/worker-agent)
log "worker-agent built -> worker-agent/bin/worker-agent"

log "Running control-plane unit tests..."
(cd control-plane && go vet ./... && go test ./...)

log "Running worker-agent unit tests..."
(cd worker-agent && go vet ./... && go test ./...)

log "Installing website dependencies (npm ci)..."
(cd website && npm ci)

log "Running website lint..."
(cd website && npm run lint)

log "Running website unit tests..."
(cd website && npm test)

log "Building website..."
(cd website && npm run build)

log ""
log "Setup complete. All three components built and tested successfully."
log "Next: see docs/phase-completion/phase-0.md for the manual test checklist."

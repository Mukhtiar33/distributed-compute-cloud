# Compute Cloud

A secure, trustworthy distributed compute platform built on idle personal
machines. Full architecture and rationale lives in [`/docs`](./docs)
(Documents 00–18). Build execution follows [Document 17](./docs/17-build-plan-phases-cicd.md)
phase by phase.

## Repository Layout

```
/control-plane        Go module: Control Plane (API gateway, scheduler, core, DB migrations)
/worker-agent          Go module: Worker Agent binary source
/proto                 Shared .proto definitions (control-plane <-> worker-agent)
/website               Next.js consumer/provider-facing site
/docs                  Documents 00-18 (architecture, source of truth)
/.github/workflows     CI/CD (ci.yml, security-tests.yml, release.yml)
/scripts               Local dev tooling (setup.sh, etc.)
```

This layout is fixed by [Document 18 §2](./docs/18-tech-stack-decision.md) and
must not change across phases.

## Current Phase

**Phase 0 — Foundations & Repo Skeleton.** No functional behavior yet:
Control Plane and Worker Agent binaries start, log, and exit cleanly; the
website is a static shell. See
[`docs/phase-completion/phase-0.md`](./docs/phase-completion/phase-0.md)
for exit criteria and manual test steps.

## Quick Start

```bash
./scripts/setup.sh
```

See the Phase 0 completion doc for exact commands to run and verify each
component.

## Tech Stack

Go 1.22 (Control Plane + Worker Agent), gRPC+mTLS (internal protocol), REST
(consumer-facing API), PostgreSQL, Docker (sandboxing), Next.js (website).
Full rationale: [Document 18](./docs/18-tech-stack-decision.md).

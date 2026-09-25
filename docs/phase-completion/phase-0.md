# Phase 0 Completion — Foundations & Repo Skeleton

Status: **Complete, verified locally.** Maps to Document 17, "Phase 0 —
Foundations & Repo Skeleton."

## 1. What Was Built (mapped to Document 17 deliverables)

| Document 17 Deliverable | What was built |
|---|---|
| Monorepo: `control-plane/`, `worker-agent/`, `website/`, `docs/` | Created exactly per Document 18 §2's fixed layout. |
| Local dev environment reproducible via a single setup script | `scripts/setup.sh` — checks Go 1.22, Node 20, Docker (warns only, not required until Phase 4), builds both Go binaries, runs `go vet`/`go test` for both, runs website lint/test/build. Documents exact pinned toolchain versions in its header comment. |
| Website shell: static pages only, "Download Worker Agent" placeholder | `website/app/page.tsx` — static landing page, disabled "Download Worker Agent" button and disabled "Submit a Job" element, both explicitly not wired to anything real. |
| GitHub repo, branch protection on `main`, PR-based workflow | `.github/workflows/ci.yml` provides the CI gate branch protection depends on; exact GitHub UI steps to enable protection are in the command list below (this is a repo *setting*, not a file, so it can't ship in the zip). |

## 2. How It Satisfies Exit Criteria

**Exit criterion: "Fresh clone + setup script → all three components build/run locally without manual fixing."**

Verified locally in the build environment before packaging:
- `control-plane`: `go vet ./...` clean, `go build ./cmd/control-plane` succeeds, `go test ./...` passes (2 tests: `TestComponentName`, `TestVersionNotEmpty`).
- `worker-agent`: same checks, same result (own test names, same coverage).
- `website`: `npm ci`, `npm run lint` (0 warnings/errors), `npm test` (3/3 Vitest tests pass), `npm run build` (static export succeeds, 4/4 pages generated).

One real bug was caught and fixed during this verification: the landing
page originally passed an `onClick` handler to a plain `<a>` tag inside a
Next.js **Server Component**, which is invalid in the App Router (event
handlers require a Client Component) and made the production build fail
with a static-generation timeout. Fixed by replacing the interactive
placeholder with a non-interactive `role="button" aria-disabled="true"`
element — correct here since the button does nothing yet anyway; Phase 9
will convert this to a real client-side control when it's wired to actual
upload logic.

A second issue was caught and fixed: the initially pinned `next@14.2.5` has
a known, published security vulnerability (flagged by `npm install`
itself). Bumped to the latest patched 14.2.x release (`14.2.35`) before
finalizing — per the standing engineering standards, a known vulnerability
is never shipped even in a Phase 0 shell.

**Exit criterion: "Website shell loads locally and (optionally) is deployed to a free static host for early visibility."**

`npm run dev` serves the shell at `http://localhost:3000`; the manual test
checklist below covers this. Deployment to a free static host is optional
per Document 17 and is not done here — nothing in the architecture depends
on it happening in Phase 0.

## 3. Manual Test Checklist (run this yourself, exact steps)

1. In a **clean directory**, unzip the delivered archive on top of your
   existing project (or clone fresh if this is your first phase).
2. Run:
   ```bash
   ./scripts/setup.sh
   ```
3. Confirm the script prints `Setup complete. All three components built
   and tested successfully.` with no errors above it.
4. Start the Control Plane binary and confirm it logs and stays running:
   ```bash
   ./control-plane/bin/control-plane
   ```
   Expect JSON log lines including `"msg":"starting"` and `"msg":"control-plane running (phase 0 skeleton — no services bound yet)"`. Press `Ctrl+C` and confirm you see a clean `"msg":"shutdown signal received, exiting cleanly"` line, then the process exits (no hang, no panic).
5. In a separate terminal, do the same for the Worker Agent:
   ```bash
   ./worker-agent/bin/worker-agent
   ```
   Same expectations (component name `worker-agent` in the logs). `Ctrl+C` to stop.
6. Start the website in dev mode:
   ```bash
   cd website && npm run dev
   ```
   Open `http://localhost:3000` in a browser. Confirm:
   - The page loads with the "Compute Cloud" heading.
   - The "Download Worker Agent (coming soon)" button is visibly disabled and does nothing when clicked.
   - The "Submit a Job (coming soon)" element is visibly non-interactive.
   - No console errors in the browser dev tools.
   Stop the dev server with `Ctrl+C`.
7. Confirm fresh-clone reproducibility: delete `control-plane/bin`, `worker-agent/bin`, `website/node_modules`, `website/.next`, then re-run `./scripts/setup.sh` once more and confirm it succeeds identically.

## 4. Deviations from Documents 00–18

None. This phase introduces no architecture, security, or scheduling
decisions — it is pure scaffolding, consistent with Document 17's own
framing of Phase 0.

One implementation detail not specified by the docs and therefore decided
here: the Go module paths use the repository's actual GitHub path,
`github.com/Mukhtiar33/distributed-compute-cloud/...`. This is now consistent
across both `go.mod` files, Go imports, and build-time version metadata.

## 5. Files New vs Modified

Everything in this delivery is **new** — this is the first phase.

```
control-plane/go.mod
control-plane/cmd/control-plane/main.go
control-plane/internal/version/version.go
control-plane/internal/version/version_test.go
worker-agent/go.mod
worker-agent/cmd/worker-agent/main.go
worker-agent/internal/version/version.go
worker-agent/internal/version/version_test.go
proto/README.md
website/package.json
website/package-lock.json
website/tsconfig.json
website/next.config.mjs
website/tailwind.config.ts
website/postcss.config.mjs
website/.eslintrc.json
website/vitest.config.ts
website/vitest.setup.ts
website/.gitignore
website/app/layout.tsx
website/app/page.tsx
website/app/styles/globals.css
website/__tests__/page.test.tsx
docs/00-scope-and-roadmap.md .. docs/18-tech-stack-decision.md
docs/phase-completion/phase-0.md
.github/workflows/ci.yml
scripts/setup.sh
.gitignore
README.md
```

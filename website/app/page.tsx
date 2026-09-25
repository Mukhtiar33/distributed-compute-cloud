/**
 * Landing page — Phase 0 shell only (Document 17, Phase 0).
 *
 * This is intentionally static. The "Download Worker Agent" button is a
 * placeholder that is NOT wired to a real binary yet — that happens in
 * Phase 9 once CI (Document 17's release.yml) actually builds and publishes
 * the Worker Agent binary. Wiring it earlier would mean shipping a broken
 * or fake link, which Document 17 Rule 1 (no shortcut versions that get
 * rebuilt later) explicitly forbids.
 */
export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col items-center justify-center gap-8 px-6 text-center">
      <div className="space-y-4">
        <h1 className="text-4xl font-semibold tracking-tight sm:text-5xl">
          Compute Cloud
        </h1>
        <p className="text-lg text-slate-400">
          A secure, trustworthy distributed compute platform — built on idle
          personal machines, protected by Zero Trust isolation at every
          layer.
        </p>
      </div>

      <div className="flex flex-col gap-4 sm:flex-row">
        <button
          type="button"
          disabled
          title="Not available yet — Worker Agent builds ship in a later phase"
          className="cursor-not-allowed rounded-lg bg-indigo-600/50 px-6 py-3 font-medium text-white/70"
        >
          Download Worker Agent (coming soon)
        </button>
        <span
          role="button"
          aria-disabled="true"
          title="Not available yet — consumer upload arrives in a later phase"
          className="cursor-not-allowed rounded-lg border border-slate-700 px-6 py-3 font-medium text-slate-400"
        >
          Submit a Job (coming soon)
        </span>
      </div>

      <p className="text-sm text-slate-600">
        Phase 0 — static shell. No functionality is wired up yet.
      </p>
    </main>
  );
}

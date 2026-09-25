// Command worker-agent is the entrypoint for the provider-side Worker Agent.
//
// Phase 0 scope: this binary starts, logs that it is alive, and exits
// cleanly. No enrollment, heartbeat, sandboxing, or Control Plane
// communication exists yet — that is Phase 1 (Document 17). This exists so
// Phase 0's "all three components build/run locally" exit criterion is
// satisfiable, and so the single-static-binary property (Document 08 §1,
// Document 18 §1) is verified from the very first commit rather than
// assumed later.
package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"

	"github.com/Mukhtiar33/distributed-compute-cloud/worker-agent/internal/version"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelInfo,
	}))
	slog.SetDefault(logger)

	slog.Info("starting",
		"component", version.Component,
		"version", version.Version,
	)

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	slog.Info("worker-agent running (phase 0 skeleton — no enrollment/heartbeat yet)")

	<-ctx.Done()
	slog.Info("shutdown signal received, exiting cleanly")
}

// Command control-plane is the entrypoint for the Control Plane service.
//
// Phase 0 scope: this binary starts, logs that it is alive, and exits
// cleanly. No networking, scheduling, auth, or persistence exists yet —
// those arrive in later phases per Document 17. This exists so Phase 0's
// exit criteria ("all three components build/run locally without manual
// fixing") is satisfiable and testable from day one.
package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"

	"github.com/Mukhtiar33/distributed-compute-cloud/control-plane/internal/version"
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

	slog.Info("control-plane running (phase 0 skeleton — no services bound yet)")

	<-ctx.Done()
	slog.Info("shutdown signal received, exiting cleanly")
}

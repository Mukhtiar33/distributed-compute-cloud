// Package version exposes build-time version metadata for the Worker Agent.
package version

// Version is the current Worker Agent version. Overridden at build time via
// -ldflags "-X github.com/Mukhtiar33/distributed-compute-cloud/worker-agent/internal/version.Version=x.y.z"
var Version = "0.0.0-dev"

// Component identifies this binary in logs and health output.
const Component = "worker-agent"

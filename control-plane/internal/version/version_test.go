package version

import "testing"

func TestComponentName(t *testing.T) {
	if Component != "control-plane" {
		t.Fatalf("expected component name %q, got %q", "control-plane", Component)
	}
}

func TestVersionNotEmpty(t *testing.T) {
	if Version == "" {
		t.Fatal("Version must never be empty, even in dev builds")
	}
}

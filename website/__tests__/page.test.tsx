import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import HomePage from "../app/page";

describe("HomePage (Phase 0 shell)", () => {
  it("renders the landing headline", () => {
    render(<HomePage />);
    expect(
      screen.getByRole("heading", { name: /compute cloud/i })
    ).toBeInTheDocument();
  });

  it("renders a disabled Download Worker Agent placeholder button", () => {
    render(<HomePage />);
    const button = screen.getByRole("button", {
      name: /download worker agent/i,
    });
    expect(button).toBeDisabled();
  });

  it("renders a disabled Submit a Job placeholder link", () => {
    render(<HomePage />);
    expect(screen.getByText(/submit a job/i)).toBeInTheDocument();
  });
});

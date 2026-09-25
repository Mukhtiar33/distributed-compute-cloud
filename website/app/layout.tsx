import type { Metadata } from "next";
import "./styles/globals.css";

export const metadata: Metadata = {
  title: "Compute Cloud — Distributed Compute Platform",
  description:
    "Turn idle personal computers into a secure, trustworthy distributed compute cloud.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-slate-950 text-slate-100 antialiased">
        {children}
      </body>
    </html>
  );
}


import React from "react";
import { createRoot } from "react-dom/client";
import App from "./app/App.tsx";
import "./styles/index.css";

type ErrorBoundaryState = {
  hasError: boolean;
  message: string;
};

class RootErrorBoundary extends React.Component<
  React.PropsWithChildren,
  ErrorBoundaryState
> {
  constructor(props: React.PropsWithChildren) {
    super(props);
    this.state = { hasError: false, message: "" };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return {
      hasError: true,
      message: error.message || "Unknown runtime error",
    };
  }

  componentDidCatch(error: Error) {
    console.error("[ACONSIA] Runtime render error:", error);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div
          style={{
            minHeight: "100vh",
            padding: "16px",
            fontFamily: "ui-sans-serif, system-ui, sans-serif",
            background: "#fff",
            color: "#111827",
          }}
        >
          <h1 style={{ fontSize: "20px", fontWeight: 700, marginBottom: "8px" }}>
            Aplikasi gagal dimuat
          </h1>
          <p style={{ marginBottom: "8px" }}>Detail error:</p>
          <pre
            style={{
              whiteSpace: "pre-wrap",
              background: "#f3f4f6",
              padding: "12px",
              borderRadius: "8px",
            }}
          >
            {this.state.message}
          </pre>
        </div>
      );
    }

    return this.props.children;
  }
}

createRoot(document.getElementById("root")!).render(
  <RootErrorBoundary>
    <App />
  </RootErrorBoundary>,
);

import { useEffect } from "react";
import { RouterProvider } from "react-router";
import { router } from "./routes.tsx";
import { seedDemoData } from "../utils/seedDoctorData";

export default function App() {
  useEffect(() => {
    const enableDemoSeed =
      String(import.meta.env.VITE_ENABLE_DEMO_SEED || "false").toLowerCase() ===
      "true";

    if (!enableDemoSeed) {
      return;
    }

    seedDemoData();
  }, []);

  return <RouterProvider router={router} />;
}
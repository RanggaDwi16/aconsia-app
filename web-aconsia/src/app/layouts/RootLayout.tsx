import { Outlet } from "react-router";
import { Toaster } from "../components/ui/sonner";
import { InstallPrompt } from "../components/InstallPrompt";
import { OfflineIndicator } from "../components/OfflineIndicator";
import { useEffect } from "react";

export function RootLayout() {
  useEffect(() => {
    // Register Service Worker
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/sw.js')
        .then((registration) => {
          console.log('SW registered:', registration);
        })
        .catch((error) => {
          console.log('SW registration failed:', error);
        });
    }
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50">
      <OfflineIndicator />
      <Outlet />
      <InstallPrompt />
      <Toaster />
    </div>
  );
}
import { Outlet } from "react-router";
import { useEffect } from "react";
import React from "react";
import { Toaster } from "../components/ui/sonner";
import { InstallPrompt } from "../components/InstallPrompt";
import { OfflineIndicator } from "../components/OfflineIndicator";
import {
  hydrateDesktopSessionFromFirebaseAuth,
  subscribeDesktopSessionSync,
} from "../../core/auth/session";

type GuardedWidgetState = {
  hasError: boolean;
};

class GuardedWidget extends React.Component<React.PropsWithChildren, GuardedWidgetState> {
  constructor(props: React.PropsWithChildren) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: unknown) {
    console.warn("[RootLayout] Global widget failed and was isolated:", error);
  }

  render() {
    if (this.state.hasError) return null;
    return this.props.children;
  }
}

export function RootLayout() {
  useEffect(() => {
    let unsubscribe = () => {};
    let active = true;

    const bootstrapSession = async () => {
      await hydrateDesktopSessionFromFirebaseAuth();
      if (!active) return;
      unsubscribe = subscribeDesktopSessionSync();
    };

    void bootstrapSession();

    return () => {
      active = false;
      unsubscribe();
    };
  }, []);

  useEffect(() => {
    if (!("serviceWorker" in navigator)) {
      return;
    }

    if (import.meta.env.DEV) {
      navigator.serviceWorker
        .getRegistrations()
        .then((registrations) => {
          registrations.forEach((registration) => {
            void registration.unregister();
          });
        })
        .catch((error) => {
          console.log("[RootLayout] SW cleanup failed:", error);
        });
      return;
    }

    navigator.serviceWorker.register("/sw.js").catch((error) => {
      console.log("[RootLayout] SW registration failed:", error);
    });
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50">
      <GuardedWidget>
        <OfflineIndicator />
      </GuardedWidget>

      <Outlet />

      <GuardedWidget>
        <InstallPrompt />
      </GuardedWidget>

      <GuardedWidget>
        <Toaster />
      </GuardedWidget>
    </div>
  );
}

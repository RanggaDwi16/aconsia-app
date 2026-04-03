import { Navigate } from "react-router";
import { useEffect, useState } from "react";
import {
  getDesktopSession,
  resolveDesktopSession,
} from "./session";
import type { DesktopRole } from "./types";

type RequireRoleProps = {
  allowedRoles: DesktopRole[];
  children: JSX.Element;
};

export function RequireRole({ allowedRoles, children }: RequireRoleProps) {
  const [isCheckingSession, setIsCheckingSession] = useState(true);
  const [session, setSession] = useState(() => getDesktopSession());

  useEffect(() => {
    let active = true;

    const resolveSession = async () => {
      const hydrated = await resolveDesktopSession();
      if (!active) return;

      setSession(hydrated);
      setIsCheckingSession(false);
    };

    void resolveSession();

    return () => {
      active = false;
    };
  }, []);

  if (isCheckingSession) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-10 h-10 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-sm text-slate-600 font-medium">Memverifikasi sesi...</p>
        </div>
      </div>
    );
  }

  if (!session) {
    return <Navigate to="/login" replace />;
  }

  if (!allowedRoles.includes(session.role)) {
    return <Navigate to="/login" replace />;
  }

  return children;
}

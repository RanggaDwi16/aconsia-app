import { Navigate } from "react-router";
import { getDesktopSession } from "./session";
import type { DesktopRole } from "./types";

type RequireRoleProps = {
  allowedRoles: DesktopRole[];
  children: JSX.Element;
};

export function RequireRole({ allowedRoles, children }: RequireRoleProps) {
  const session = getDesktopSession();

  if (!session) {
    return <Navigate to="/login" replace />;
  }

  if (!allowedRoles.includes(session.role)) {
    return <Navigate to="/login" replace />;
  }

  return children;
}

import { lazy } from "react";
import type { RouteObject } from "react-router";
import { RequireRole } from "../../core/auth/RequireRole";
import { withSuspense } from "./shared";

const EnhancedAdminDashboard = lazy(() =>
  import("../pages/admin/EnhancedAdminDashboard").then((m) => ({
    default: m.EnhancedAdminDashboard,
  })),
);
const ReportsPage = lazy(() =>
  import("../pages/admin/ReportsPage").then((m) => ({ default: m.ReportsPage })),
);
const AuditTrailPage = lazy(() =>
  import("../pages/admin/AuditTrailPage").then((m) => ({
    default: m.AuditTrailPage,
  })),
);

export const adminRoutes: RouteObject[] = [
  {
    path: "admin",
    element: (
      <RequireRole allowedRoles={["admin"]}>
        {withSuspense(<EnhancedAdminDashboard />)}
      </RequireRole>
    ),
  },
  {
    path: "admin/reports",
    element: (
      <RequireRole allowedRoles={["admin"]}>
        {withSuspense(<ReportsPage />)}
      </RequireRole>
    ),
  },
  {
    path: "admin/audit-trail",
    element: (
      <RequireRole allowedRoles={["admin"]}>
        {withSuspense(<AuditTrailPage />)}
      </RequireRole>
    ),
  },
];

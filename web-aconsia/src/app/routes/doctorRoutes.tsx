import { lazy } from "react";
import type { ReactElement } from "react";
import type { RouteObject } from "react-router";
import { Navigate } from "react-router";
import { RequireRole } from "../../core/auth/RequireRole";
import { withSuspense } from "./shared";

const DoctorDashboardNew = lazy(() =>
  import("../pages/doctor/DoctorDashboardNew").then((m) => ({
    default: m.DoctorDashboardNew,
  })),
);
const DoctorProfile = lazy(() =>
  import("../pages/doctor/DoctorProfile").then((m) => ({ default: m.DoctorProfile })),
);
const DoctorPatients = lazy(() =>
  import("../pages/doctor/DoctorPatients").then((m) => ({ default: m.DoctorPatients })),
);
const DoctorContent = lazy(() =>
  import("../pages/doctor/DoctorContent").then((m) => ({ default: m.DoctorContent })),
);
const PatientApprovalNew = lazy(() =>
  import("../pages/doctor/PatientApprovalNew").then((m) => ({
    default: m.PatientApprovalNew,
  })),
);
const DoctorRegistration = lazy(() =>
  import("../pages/doctor/DoctorRegistration").then((m) => ({
    default: m.DoctorRegistration,
  })),
);
const DoctorMonitoring = lazy(() =>
  import("../pages/doctor/DoctorMonitoring").then((m) => ({
    default: m.DoctorMonitoring,
  })),
);
const DoctorChatRoom = lazy(() =>
  import("../pages/doctor/DoctorChatRoom").then((m) => ({
    default: m.DoctorChatRoom,
  })),
);
const DoctorChats = lazy(() =>
  import("../pages/doctor/DoctorChats").then((m) => ({
    default: m.DoctorChats,
  })),
);

function doctorOnly(element: ReactElement) {
  return <RequireRole allowedRoles={["doctor", "admin"]}>{element}</RequireRole>;
}

export const doctorRoutes: RouteObject[] = [
  { path: "doctor/register", element: withSuspense(<DoctorRegistration />) },
  {
    path: "doctor",
    element: doctorOnly(withSuspense(<DoctorDashboardNew />)),
  },
  {
    path: "doctor/dashboard",
    element: doctorOnly(withSuspense(<DoctorDashboardNew />)),
  },
  {
    path: "doctor/profile",
    element: doctorOnly(withSuspense(<DoctorProfile />)),
  },
  {
    path: "doctor/patients",
    element: doctorOnly(withSuspense(<DoctorPatients />)),
  },
  {
    path: "doctor/content",
    element: doctorOnly(withSuspense(<DoctorContent />)),
  },
  {
    path: "doctor/approval",
    element: doctorOnly(withSuspense(<PatientApprovalNew />)),
  },
  {
    path: "doctor/dashboard-old",
    element: <Navigate to="/doctor/dashboard" replace />,
  },
  {
    path: "doctor/approval-old",
    element: <Navigate to="/doctor/patients" replace />,
  },
  {
    path: "doctor/monitoring",
    element: doctorOnly(withSuspense(<DoctorMonitoring />)),
  },
  {
    path: "doctor/chat/:pasienId",
    element: doctorOnly(withSuspense(<DoctorChatRoom />)),
  },
  {
    path: "doctor/chats",
    element: doctorOnly(withSuspense(<DoctorChats />)),
  },
];

import { createBrowserRouter } from "react-router";
import { RootLayout } from "./layouts/RootLayout";
import { LandingPage } from "./pages/LandingPage";
import { UnifiedLoginPage } from "./pages/UnifiedLoginPage";
import { PrototypeDemo } from "./pages/PrototypeDemo";
import { DemoOptionsPage } from "./pages/DemoOptionsPage";
import { EnhancedAdminDashboard } from "./pages/admin/EnhancedAdminDashboard";
import { ReportsPage } from "./pages/admin/ReportsPage";
import { AuditTrailPage } from "./pages/admin/AuditTrailPage";
import { DoctorDashboardNew } from "./pages/doctor/DoctorDashboardNew";
import { DoctorProfile } from "./pages/doctor/DoctorProfile";
import { DoctorPatients } from "./pages/doctor/DoctorPatients";
import { DoctorContent } from "./pages/doctor/DoctorContent";
import { PatientApprovalNew } from "./pages/doctor/PatientApprovalNew";
import { PatientApproval } from "./pages/doctor/PatientApproval";
import { EnhancedDoctorDashboard } from "./pages/doctor/EnhancedDoctorDashboard";
import { DoctorRegistration } from "./pages/doctor/DoctorRegistration";
import { DoctorMonitoring } from "./pages/doctor/DoctorMonitoring";
import { NotFound } from "./pages/NotFound";
import { RequireRole } from "../core/auth/RequireRole";
import { DesktopPatientRedirectPage } from "./pages/DesktopPatientRedirectPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <RootLayout />,
    children: [
      { index: true, element: <LandingPage /> },
      { path: "login", element: <UnifiedLoginPage /> },
      { path: "register", element: <DesktopPatientRedirectPage /> },
      { path: "demo", element: <PrototypeDemo /> },
      { path: "demo-options", element: <DemoOptionsPage /> },
      {
        path: "admin",
        element: (
          <RequireRole allowedRoles={["admin"]}>
            <EnhancedAdminDashboard />
          </RequireRole>
        ),
      },
      {
        path: "admin/reports",
        element: (
          <RequireRole allowedRoles={["admin"]}>
            <ReportsPage />
          </RequireRole>
        ),
      },
      {
        path: "admin/audit-trail",
        element: (
          <RequireRole allowedRoles={["admin"]}>
            <AuditTrailPage />
          </RequireRole>
        ),
      },
      {
        path: "doctor",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <DoctorDashboardNew />
          </RequireRole>
        ),
      },
      { path: "doctor/register", element: <DoctorRegistration /> },
      { path: "doctor/login", element: <UnifiedLoginPage /> },
      {
        path: "doctor/dashboard",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <DoctorDashboardNew />
          </RequireRole>
        ),
      },
      {
        path: "doctor/profile",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <DoctorProfile />
          </RequireRole>
        ),
      },
      {
        path: "doctor/patients",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <DoctorPatients />
          </RequireRole>
        ),
      },
      {
        path: "doctor/content",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <DoctorContent />
          </RequireRole>
        ),
      },
      {
        path: "doctor/approval",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <PatientApprovalNew />
          </RequireRole>
        ),
      },
      {
        path: "doctor/dashboard-old",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <EnhancedDoctorDashboard />
          </RequireRole>
        ),
      },
      {
        path: "doctor/approval-old",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <PatientApproval />
          </RequireRole>
        ),
      },
      { path: "patient", element: <DesktopPatientRedirectPage /> },
      { path: "patient/dashboard", element: <DesktopPatientRedirectPage /> },
      { path: "patient/dashboard-new", element: <DesktopPatientRedirectPage /> },
      { path: "patient/register", element: <DesktopPatientRedirectPage /> },
      { path: "patient/register-old", element: <DesktopPatientRedirectPage /> },
      { path: "patient/education", element: <DesktopPatientRedirectPage /> },
      { path: "patient/chatbot", element: <DesktopPatientRedirectPage /> },
      { path: "patient/chat", element: <DesktopPatientRedirectPage /> },
      { path: "patient/chat-hybrid", element: <DesktopPatientRedirectPage /> },
      { path: "patient/schedule-consent", element: <DesktopPatientRedirectPage /> },
      { path: "patient/schedule-signature", element: <DesktopPatientRedirectPage /> },
      { path: "patient/contact-doctor", element: <DesktopPatientRedirectPage /> },
      { path: "patient/profile", element: <DesktopPatientRedirectPage /> },
      { path: "patient/material/:materialId", element: <DesktopPatientRedirectPage /> },
      { path: "patient/material-old/:materialId", element: <DesktopPatientRedirectPage /> },
      { path: "patient/quiz", element: <DesktopPatientRedirectPage /> },
      { path: "patient/pre-operative-assessment", element: <DesktopPatientRedirectPage /> },
      {
        path: "doctor/monitoring",
        element: (
          <RequireRole allowedRoles={["doctor", "admin"]}>
            <DoctorMonitoring />
          </RequireRole>
        ),
      },
      { path: "*", element: <NotFound /> },
    ],
  },
]);
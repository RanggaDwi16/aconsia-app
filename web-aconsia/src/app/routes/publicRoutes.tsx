import { lazy } from "react";
import type { RouteObject } from "react-router";
import { LandingPage } from "../pages/LandingPage";
import { DesktopPatientRedirectPage } from "../pages/DesktopPatientRedirectPage";
import { withSuspense } from "./shared";

const UnifiedLoginPage = lazy(() =>
  import("../pages/UnifiedLoginPage").then((m) => ({ default: m.UnifiedLoginPage })),
);

export const publicRoutes: RouteObject[] = [
  { index: true, element: <LandingPage /> },
  { path: "login", element: withSuspense(<UnifiedLoginPage />) },
  { path: "register", element: <DesktopPatientRedirectPage /> },
  { path: "doctor/login", element: withSuspense(<UnifiedLoginPage />) },
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
];

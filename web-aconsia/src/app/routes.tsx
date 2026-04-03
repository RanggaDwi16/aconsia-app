import { createBrowserRouter } from "react-router";
import { RootLayout } from "./layouts/RootLayout";
import { RouteErrorPage } from "./pages/RouteErrorPage";
import { NotFound } from "./pages/NotFound";
import { publicRoutes } from "./routes/publicRoutes";
import { adminRoutes } from "./routes/adminRoutes";
import { doctorRoutes } from "./routes/doctorRoutes";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <RootLayout />,
    errorElement: <RouteErrorPage />,
    children: [...publicRoutes, ...adminRoutes, ...doctorRoutes, { path: "*", element: <NotFound /> }],
  },
]);

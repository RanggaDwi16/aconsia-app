import { Suspense, type ReactElement } from "react";

export function withSuspense(element: ReactElement) {
  return <Suspense fallback={<div className="p-6">Loading...</div>}>{element}</Suspense>;
}

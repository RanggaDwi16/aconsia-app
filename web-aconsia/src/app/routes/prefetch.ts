const prefetchCache = new Map<string, Promise<unknown>>();

type ConnectionLike = {
  saveData?: boolean;
  effectiveType?: string;
};

function canUseAggressivePrefetch() {
  const connection = (navigator as Navigator & { connection?: ConnectionLike })
    .connection;
  if (!connection) return true;

  if (connection.saveData) return false;
  const effectiveType = (connection.effectiveType || "").toLowerCase();
  if (effectiveType.includes("2g")) return false;

  return true;
}

function scheduleIdle(task: () => void) {
  const withIdleCallback = window as Window & {
    requestIdleCallback?: (
      cb: (deadline: { didTimeout: boolean; timeRemaining: () => number }) => void,
      opts?: { timeout?: number },
    ) => number;
  };

  if (typeof withIdleCallback.requestIdleCallback === "function") {
    withIdleCallback.requestIdleCallback(() => task(), { timeout: 1200 });
    return;
  }

  window.setTimeout(task, 250);
}

function runPrefetch(key: string, loader: () => Promise<unknown>) {
  const existing = prefetchCache.get(key);
  if (existing) return existing;

  const promise = loader().catch((error) => {
    prefetchCache.delete(key);
    console.warn(`[Prefetch] gagal memuat chunk "${key}"`, error);
  });

  prefetchCache.set(key, promise);
  return promise;
}

function maybePrefetch(key: string, loader: () => Promise<unknown>) {
  if (!canUseAggressivePrefetch()) {
    return Promise.resolve(undefined);
  }
  return runPrefetch(key, loader);
}

export function prefetchLoginPage() {
  return maybePrefetch("login-page", () =>
    import("../pages/UnifiedLoginPage").then(() => undefined),
  );
}

export function prefetchLoginPageOnIdle() {
  scheduleIdle(() => {
    void prefetchLoginPage();
  });
}

export function prefetchDoctorArea() {
  if (!canUseAggressivePrefetch()) {
    return Promise.resolve([]);
  }

  return Promise.all([
    runPrefetch("doctor-dashboard", () =>
      import("../pages/doctor/DoctorDashboardNew").then(() => undefined),
    ),
    runPrefetch("doctor-patients", () =>
      import("../pages/doctor/DoctorPatients").then(() => undefined),
    ),
    runPrefetch("doctor-approval", () =>
      import("../pages/doctor/PatientApprovalNew").then(() => undefined),
    ),
  ]);
}

export function prefetchDoctorAreaOnIdle() {
  scheduleIdle(() => {
    void prefetchDoctorArea();
  });
}

export function prefetchAdminArea() {
  if (!canUseAggressivePrefetch()) {
    return Promise.resolve([]);
  }

  return Promise.all([
    runPrefetch("admin-dashboard", () =>
      import("../pages/admin/EnhancedAdminDashboard").then(() => undefined),
    ),
    runPrefetch("admin-reports", () =>
      import("../pages/admin/ReportsPage").then(() => undefined),
    ),
    runPrefetch("admin-audit", () =>
      import("../pages/admin/AuditTrailPage").then(() => undefined),
    ),
  ]);
}

export function prefetchAdminAreaOnIdle() {
  scheduleIdle(() => {
    void prefetchAdminArea();
  });
}

export function prefetchCriticalRoutesOnIdle() {
  if (!canUseAggressivePrefetch()) {
    return;
  }

  scheduleIdle(() => {
    void prefetchLoginPage();
  });
}

export function prefetchLoginPageImmediate() {
  return runPrefetch("login-page", () =>
    import("../pages/UnifiedLoginPage").then(() => undefined),
  );
}

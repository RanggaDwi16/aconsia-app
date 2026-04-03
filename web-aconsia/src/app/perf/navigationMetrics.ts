type NavigationMetricRecord = {
  key: string;
  durationMs: number;
  at: string;
  context?: Record<string, string | number | boolean>;
};

const START_PREFIX = "aconsia-nav-start:";
const END_PREFIX = "aconsia-nav-end:";

declare global {
  interface Window {
    __ACONSIA_NAV_METRICS__?: NavigationMetricRecord[];
  }
}

function safeMark(markName: string) {
  try {
    performance.mark(markName);
  } catch {
    // no-op
  }
}

function safeMeasure(name: string, startMark: string, endMark: string) {
  try {
    performance.measure(name, startMark, endMark);
  } catch {
    // no-op
  }
}

export function startNavigationMetric(key: string) {
  safeMark(`${START_PREFIX}${key}`);
}

export function finishNavigationMetric(
  key: string,
  context?: Record<string, string | number | boolean>,
) {
  const startMark = `${START_PREFIX}${key}`;
  const endMark = `${END_PREFIX}${key}`;
  safeMark(endMark);
  safeMeasure(`aconsia-nav:${key}`, startMark, endMark);

  const entries = performance.getEntriesByName(`aconsia-nav:${key}`, "measure");
  const latest = entries[entries.length - 1];
  const durationMs = latest ? Math.round(latest.duration) : -1;

  const record: NavigationMetricRecord = {
    key,
    durationMs,
    at: new Date().toISOString(),
    context,
  };

  const current = window.__ACONSIA_NAV_METRICS__ || [];
  window.__ACONSIA_NAV_METRICS__ = [...current, record].slice(-50);

  console.info(`[Perf] ${key}: ${durationMs}ms`, context || {});
}

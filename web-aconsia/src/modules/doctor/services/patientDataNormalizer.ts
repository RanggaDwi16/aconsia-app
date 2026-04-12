export const EMPTY_TEXT_LABEL = "Belum diisi";
export const EMPTY_SCHEDULE_LABEL = "Belum dijadwalkan";

type AnyRecord = Record<string, unknown>;

export type DoctorPatientNormalizedDisplay = {
  mrnText: string;
  diagnosisText: string;
  scheduleText: string;
  scheduleDateRaw: string;
  scheduleTimeRaw: string;
};

export type RawDoctorPatientRow = {
  docId: string;
  data: AnyRecord;
};

export type MergedDoctorPatientRow = {
  canonicalUid: string;
  primaryDocId: string;
  docIds: string[];
  data: AnyRecord;
  recencyMs: number;
};

function isPlainObject(value: unknown): value is AnyRecord {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function readByPath(data: AnyRecord, path: string): unknown {
  if (!path.includes(".")) return data[path];
  const segments = path.split(".");
  let current: unknown = data;
  for (const segment of segments) {
    if (!isPlainObject(current) || !(segment in current)) return undefined;
    current = current[segment];
  }
  return current;
}

export function readNonEmptyText(value: unknown): string {
  if (value === null || value === undefined) return "";
  if (typeof value === "string") {
    const clean = value.trim();
    return clean === "-" ? "" : clean;
  }
  if (typeof value === "number" || typeof value === "boolean") {
    return String(value);
  }
  return "";
}

function hasMeaningfulValue(value: unknown): boolean {
  if (value === null || value === undefined) return false;
  if (typeof value === "string") return readNonEmptyText(value).length > 0;
  if (typeof value === "number") return Number.isFinite(value);
  if (typeof value === "boolean") return true;
  if (Array.isArray(value)) return value.length > 0;
  if (isPlainObject(value)) return Object.keys(value).length > 0;
  return true;
}

function firstValue(data: AnyRecord, paths: string[]): unknown {
  for (const path of paths) {
    const value = readByPath(data, path);
    if (hasMeaningfulValue(value)) return value;
  }
  return undefined;
}

export function toMillisValue(value: unknown): number {
  if (!value) return 0;

  if (value instanceof Date) {
    return Number.isFinite(value.getTime()) ? value.getTime() : 0;
  }

  if (typeof value === "number") {
    return Number.isFinite(value) ? value : 0;
  }

  if (typeof value === "object" && value !== null) {
    if ("toMillis" in value && typeof value.toMillis === "function") {
      try {
        const millis = value.toMillis();
        return Number.isFinite(millis) ? millis : 0;
      } catch {
        return 0;
      }
    }
    if ("toDate" in value && typeof value.toDate === "function") {
      try {
        const date = value.toDate();
        return date instanceof Date && Number.isFinite(date.getTime())
          ? date.getTime()
          : 0;
      } catch {
        return 0;
      }
    }
  }

  if (typeof value === "string" && value.trim().length > 0) {
    const parsed = Date.parse(value.trim());
    return Number.isFinite(parsed) ? parsed : 0;
  }

  return 0;
}

function parseDateValue(value: unknown): Date | null {
  const millis = toMillisValue(value);
  if (millis <= 0) return null;
  const date = new Date(millis);
  return Number.isFinite(date.getTime()) ? date : null;
}

function parseTimeValue(value: unknown): string {
  const text = readNonEmptyText(value);
  if (!text) return "";
  const match = text.match(/^(\d{1,2}):(\d{2})$/);
  if (!match) return "";
  const hour = Number(match[1]);
  const minute = Number(match[2]);
  if (!Number.isInteger(hour) || !Number.isInteger(minute)) return "";
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return "";
  return `${String(hour).padStart(2, "0")}:${String(minute).padStart(2, "0")}`;
}

function resolveMrn(data: AnyRecord): string {
  return readNonEmptyText(
    firstValue(data, ["noRekamMedis", "mrn", "no_rm", "noRM"]),
  );
}

function resolveDiagnosis(data: AnyRecord): string {
  return readNonEmptyText(
    firstValue(data, [
      "jenisOperasi",
      "surgeryType",
      "diagnosis",
      "preOperativeAssessment.data.jenisOperasi",
      "preOperativeAssessment.data.surgeryType",
      "preOperativeAssessment.data.diagnosis",
      "preOperativeAssessment.data.primaryDiagnosis",
    ]),
  );
}

function resolveSchedule(data: AnyRecord): {
  text: string;
  dateRaw: string;
  timeRaw: string;
} {
  const dateValue = firstValue(data, [
    "preOperativeAssessment.scheduledSignatureDate",
    "scheduledSignatureDate",
  ]);
  const timeValue = firstValue(data, [
    "preOperativeAssessment.scheduledSignatureTime",
    "scheduledSignatureTime",
  ]);

  const date = parseDateValue(dateValue);
  const time = parseTimeValue(timeValue);

  if (!date) {
    return {
      text: EMPTY_SCHEDULE_LABEL,
      dateRaw: "",
      timeRaw: time,
    };
  }

  const dateText = date.toLocaleDateString("id-ID", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  });

  return {
    text: time ? `${dateText} • ${time}` : dateText,
    dateRaw: date.toISOString(),
    timeRaw: time,
  };
}

export function resolveOperationalStatus(data: AnyRecord): string {
  const explicit = readNonEmptyText(data.status).toLowerCase();
  if (explicit) return explicit;

  const hasApprovedSignal =
    Boolean(data.approvalDate) ||
    Boolean(data.approvedByUid) ||
    Boolean(data.approvedByRole) ||
    readNonEmptyText(firstValue(data, ["jenisAnestesi", "anesthesiaType"]))
      .length > 0;

  if (hasApprovedSignal) return "approved";

  const hasRejectedSignal =
    Boolean(data.rejectionDate) ||
    Boolean(data.rejectedByUid) ||
    Boolean(data.rejectedByRole) ||
    readNonEmptyText(data.rejectionReason).length > 0;

  if (hasRejectedSignal) return "rejected";
  return "pending";
}

function mergeRecordsPreferPrimary(primary: AnyRecord, candidate: AnyRecord): AnyRecord {
  const merged: AnyRecord = { ...primary };

  for (const [key, candidateValue] of Object.entries(candidate)) {
    const primaryValue = merged[key];

    if (isPlainObject(primaryValue) && isPlainObject(candidateValue)) {
      merged[key] = mergeRecordsPreferPrimary(primaryValue, candidateValue);
      continue;
    }

    if (!hasMeaningfulValue(primaryValue) && hasMeaningfulValue(candidateValue)) {
      merged[key] = candidateValue;
    }
  }

  return merged;
}

export function resolveCanonicalPasienUid(docId: string, data?: AnyRecord): string {
  const candidates = [
    readNonEmptyText(data?.uid),
    readNonEmptyText(data?.pasienUid),
    readNonEmptyText(data?.patientUid),
    readNonEmptyText(data?.userId),
    readNonEmptyText(data?.userUid),
    readNonEmptyText(data?.authUid),
    readNonEmptyText(data?.pasienId),
    readNonEmptyText(docId),
  ].filter((value) => value.length > 0);

  return candidates[0] ?? docId;
}

export function collectPasienIdentifiers(docId: string, data?: AnyRecord): string[] {
  const candidates = [
    resolveCanonicalPasienUid(docId, data),
    readNonEmptyText(data?.uid),
    readNonEmptyText(data?.pasienUid),
    readNonEmptyText(data?.patientUid),
    readNonEmptyText(data?.userId),
    readNonEmptyText(data?.userUid),
    readNonEmptyText(data?.authUid),
    readNonEmptyText(data?.pasienId),
    readNonEmptyText(docId),
  ].filter((value) => value.length > 0);

  return Array.from(new Set(candidates));
}

export function resolveRowRecencyMs(data: AnyRecord): number {
  return Math.max(
    toMillisValue(firstValue(data, ["updatedAt"])),
    toMillisValue(firstValue(data, ["preOperativeAssessmentUpdatedAt"])),
    toMillisValue(firstValue(data, ["preOperativeAssessment.updatedAt"])),
    toMillisValue(firstValue(data, ["createdAt"])),
  );
}

export function mergePatientRowsByCanonicalUid(
  rows: RawDoctorPatientRow[],
): MergedDoctorPatientRow[] {
  const sorted = [...rows].sort((a, b) => {
    const delta = resolveRowRecencyMs(b.data) - resolveRowRecencyMs(a.data);
    if (delta !== 0) return delta;
    return a.docId.localeCompare(b.docId);
  });

  const grouped = new Map<string, MergedDoctorPatientRow>();

  for (const row of sorted) {
    const canonicalUid = resolveCanonicalPasienUid(row.docId, row.data);
    const current = grouped.get(canonicalUid);

    if (!current) {
      grouped.set(canonicalUid, {
        canonicalUid,
        primaryDocId: row.docId,
        docIds: [row.docId],
        data: { ...row.data },
        recencyMs: resolveRowRecencyMs(row.data),
      });
      continue;
    }

    current.docIds.push(row.docId);
    current.data = mergeRecordsPreferPrimary(current.data, row.data);
    current.recencyMs = Math.max(current.recencyMs, resolveRowRecencyMs(row.data));
  }

  return Array.from(grouped.values()).sort((a, b) => {
    if (b.recencyMs !== a.recencyMs) return b.recencyMs - a.recencyMs;
    return a.canonicalUid.localeCompare(b.canonicalUid);
  });
}

export function normalizeDoctorPatientDisplay(
  data: AnyRecord,
): DoctorPatientNormalizedDisplay {
  const mrn = resolveMrn(data);
  const diagnosis = resolveDiagnosis(data);
  const schedule = resolveSchedule(data);

  return {
    mrnText: mrn || EMPTY_TEXT_LABEL,
    diagnosisText: diagnosis || EMPTY_TEXT_LABEL,
    scheduleText: schedule.text,
    scheduleDateRaw: schedule.dateRaw,
    scheduleTimeRaw: schedule.timeRaw,
  };
}

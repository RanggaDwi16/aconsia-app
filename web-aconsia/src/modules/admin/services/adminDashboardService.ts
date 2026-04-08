import {
  collection,
  getDocs,
  limit,
  query,
  startAfter,
  type DocumentData,
  type QueryConstraint,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

export interface AdminPatientData {
  id: string;
  fullName: string;
  mrn: string;
  nik?: string;
  dateOfBirth?: string;
  age?: string;
  gender?: string;
  diagnosis?: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready" | "completed";
  comprehensionScore: number;
  assignedDoctorId: string;
  materialsCompleted?: number;
  totalMaterials?: number;
  lastActivity?: string;
  scheduledConsentDate?: string;
  createdAt?: string;
}

export interface AdminDoctorPerformance {
  id: string;
  fullName: string;
  patientsCount: number;
  avgComprehension: number;
}

export interface PaginatedResult<T> {
  items: T[];
  nextCursor: QueryDocumentSnapshot<DocumentData> | null;
  hasNext: boolean;
}

export interface AdminPatientsFilter {
  status?: "all" | AdminPatientData["status"];
  anesthesiaType?: "all" | string;
}

export interface PaginatedQueryParams<TFilter> {
  pageSize?: number;
  cursor?: QueryDocumentSnapshot<DocumentData> | null;
  search?: string;
  filters?: TFilter;
}

const DEFAULT_PAGE_SIZE = 20;
const DEFAULT_SCAN_BATCH_SIZE = 60;
const MAX_SCAN_ROUNDS = 8;

function normalizeText(value: unknown): string {
  return String(value || "").trim().toLowerCase();
}

function mapPatientDoc(docSnap: QueryDocumentSnapshot<DocumentData>): AdminPatientData {
  const data = docSnap.data() as Record<string, unknown>;

  const statusRaw = String(data.status || "pending");
  const status =
    statusRaw === "approved" ||
    statusRaw === "in_progress" ||
    statusRaw === "ready" ||
    statusRaw === "completed"
      ? statusRaw
      : "pending";

  return {
    id: docSnap.id,
    fullName: String(data.namaLengkap || data.fullName || "Pasien"),
    mrn: String(data.noRekamMedis || data.mrn || "N/A"),
    nik: String(data.nik || ""),
    dateOfBirth: String(data.tanggalLahir || data.dateOfBirth || ""),
    age: String(data.age || ""),
    gender: String(data.jenisKelamin || data.gender || ""),
    diagnosis: String(data.diagnosis || ""),
    surgeryType: String(data.jenisOperasi || data.surgeryType || "Belum ditentukan"),
    surgeryDate: String(data.surgeryDate || "Belum dijadwalkan"),
    anesthesiaType: (data.jenisAnestesi || data.anesthesiaType || null) as string | null,
    status,
    comprehensionScore: Number(data.comprehensionScore || 0),
    assignedDoctorId: String(data.assignedDokterId || data.assignedDoctorId || ""),
    materialsCompleted: Number(data.materialsCompleted || 0),
    totalMaterials: Number(data.totalMaterials || 0),
    lastActivity: String(data.lastActivity || "N/A"),
    scheduledConsentDate: data.scheduledConsentDate ? String(data.scheduledConsentDate) : undefined,
    createdAt: data.createdAt ? String(data.createdAt) : undefined,
  };
}

function createPatientsMatcher(params: {
  searchRaw: string;
  statusFilter?: AdminPatientsFilter["status"];
  anesthesiaTypeFilter?: AdminPatientsFilter["anesthesiaType"];
}): ((item: AdminPatientData) => boolean) | null {
  const statusFilter = params.statusFilter;
  const anesthesiaTypeFilter = params.anesthesiaTypeFilter;
  const queryText = normalizeText(params.searchRaw);
  const hasSearch = Boolean(queryText);
  const hasStatusFilter = Boolean(statusFilter && statusFilter !== "all");
  const hasAnesthesiaFilter = Boolean(anesthesiaTypeFilter && anesthesiaTypeFilter !== "all");
  if (!hasSearch && !hasStatusFilter && !hasAnesthesiaFilter) return null;

  return (item: AdminPatientData) => {
    const statusMatches = !hasStatusFilter || item.status === statusFilter;
    const anesthesiaMatches =
      !hasAnesthesiaFilter || normalizeText(item.anesthesiaType) === normalizeText(anesthesiaTypeFilter);
    const searchMatches = !hasSearch
      ? true
      : normalizeText(item.fullName).includes(queryText) || normalizeText(item.mrn).includes(queryText);
    return statusMatches && anesthesiaMatches && searchMatches;
  };
}

async function hasNextMatchingPatient(params: {
  startCursor: QueryDocumentSnapshot<DocumentData>;
  constraints: QueryConstraint[];
  matcher: ((item: AdminPatientData) => boolean) | null;
  batchSize: number;
}): Promise<boolean> {
  let cursor: QueryDocumentSnapshot<DocumentData> | null = params.startCursor;

  for (let round = 0; round < MAX_SCAN_ROUNDS; round += 1) {
    const constraints: QueryConstraint[] = [...params.constraints];
    if (cursor) {
      constraints.push(startAfter(cursor));
    }
    constraints.push(limit(params.batchSize));

    const snap = await getDocs(query(collection(firestore, "pasien_profiles"), ...constraints));
    if (snap.empty) return false;

    for (const docSnap of snap.docs) {
      if (!params.matcher || params.matcher(mapPatientDoc(docSnap))) {
        return true;
      }
    }

    if (snap.docs.length < params.batchSize) return false;
    cursor = snap.docs[snap.docs.length - 1];
  }

  return true;
}

export async function getAdminDashboardPatientsPaginated(
  params: PaginatedQueryParams<AdminPatientsFilter> = {},
): Promise<PaginatedResult<AdminPatientData>> {
  const pageSize = params.pageSize && params.pageSize > 0 ? params.pageSize : DEFAULT_PAGE_SIZE;
  const batchSize = Math.max(DEFAULT_SCAN_BATCH_SIZE, pageSize * 2);
  const statusFilter = params.filters?.status;
  const anesthesiaTypeFilter = params.filters?.anesthesiaType;
  const matcher = createPatientsMatcher({
    searchRaw: params.search || "",
    statusFilter,
    anesthesiaTypeFilter,
  });

  const constraints: QueryConstraint[] = [];

  let cursor = params.cursor || null;
  const items: AdminPatientData[] = [];
  let lastScannedCursor: QueryDocumentSnapshot<DocumentData> | null = cursor;

  for (let round = 0; round < MAX_SCAN_ROUNDS; round += 1) {
    const pagingConstraints: QueryConstraint[] = [...constraints];
    if (cursor) {
      pagingConstraints.push(startAfter(cursor));
    }
    pagingConstraints.push(limit(batchSize));

    const snap = await getDocs(query(collection(firestore, "pasien_profiles"), ...pagingConstraints));
    if (snap.empty) break;

    for (const docSnap of snap.docs) {
      const mapped = mapPatientDoc(docSnap);
      if (!matcher || matcher(mapped)) {
        items.push(mapped);
        if (items.length >= pageSize) break;
      }
    }

    lastScannedCursor = snap.docs[snap.docs.length - 1];
    cursor = lastScannedCursor;

    if (items.length >= pageSize) break;
    if (snap.docs.length < batchSize) break;
  }

  if (items.length === 0 || !lastScannedCursor) {
    return {
      items: [],
      nextCursor: null,
      hasNext: false,
    };
  }

  const hasNext = await hasNextMatchingPatient({
    startCursor: lastScannedCursor,
    constraints,
    matcher,
    batchSize,
  });

  return {
    items,
    nextCursor: hasNext ? lastScannedCursor : null,
    hasNext,
  };
}

export async function getAdminDashboardPatients(): Promise<AdminPatientData[]> {
  const pasienProfilesRef = collection(firestore, "pasien_profiles");
  const snapshot = await getDocs(pasienProfilesRef);
  return snapshot.docs.map((docSnap) => mapPatientDoc(docSnap as QueryDocumentSnapshot<DocumentData>));
}

export async function getAdminDoctorPerformance(
  patients: AdminPatientData[],
): Promise<AdminDoctorPerformance[]> {
  const usersRef = collection(firestore, "users");
  const usersSnap = await getDocs(usersRef);

  const doctors = usersSnap.docs
    .map((docSnap) => {
      const data = docSnap.data() as Record<string, unknown>;
      const role = String(data.role || "").toLowerCase();
      if (role !== "dokter" && role !== "doctor") {
        return null;
      }

      return {
        id: docSnap.id,
        fullName: String(
          data.name || data.displayName || data.fullName || data.email || "Dokter",
        ),
      };
    })
    .filter((doctor): doctor is { id: string; fullName: string } => doctor !== null);

  return doctors.map((doctor) => {
    const doctorPatients = patients.filter(
      (patient) => patient.assignedDoctorId === doctor.id,
    );

    const avgComprehension =
      doctorPatients.length > 0
        ? Math.round(
            doctorPatients.reduce(
              (sum, patient) => sum + patient.comprehensionScore,
              0,
            ) / doctorPatients.length,
          )
        : 0;

    return {
      id: doctor.id,
      fullName: doctor.fullName,
      patientsCount: doctorPatients.length,
      avgComprehension,
    };
  });
}

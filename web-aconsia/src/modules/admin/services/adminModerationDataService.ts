import {
  collection,
  doc,
  getDoc,
  getDocs,
  limit,
  query,
  startAfter,
  type DocumentData,
  type QueryConstraint,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

export type ModerationUserRole = "patient" | "doctor" | "admin";
export type ModerationUserStatus = "active" | "suspended";
export type ModerationContentStatus = "draft" | "published";

export interface AdminModerationUser {
  id: string;
  displayName: string;
  email: string;
  role: ModerationUserRole;
  status: ModerationUserStatus;
}

export interface AdminModerationContent {
  id: string;
  title: string;
  status: ModerationContentStatus;
  doctorName: string;
}

export interface PaginatedResult<T> {
  items: T[];
  nextCursor: QueryDocumentSnapshot<DocumentData> | null;
  hasNext: boolean;
}

export interface PaginatedQueryParams<TFilter> {
  pageSize?: number;
  cursor?: QueryDocumentSnapshot<DocumentData> | null;
  search?: string;
  filters?: TFilter;
}

export interface AdminModerationUserFilter {
  role?: "all" | ModerationUserRole;
  status?: "all" | ModerationUserStatus;
}

export interface AdminModerationContentFilter {
  status?: "all" | ModerationContentStatus;
}

const DEFAULT_PAGE_SIZE = 20;
const DEFAULT_SCAN_BATCH_SIZE = 60;
const MAX_SCAN_ROUNDS = 8;

function normalizeUserRole(raw: string): ModerationUserRole {
  if (raw === "dokter" || raw === "doctor") return "doctor";
  if (raw === "admin") return "admin";
  return "patient";
}

function normalizeUserStatus(raw: string): ModerationUserStatus {
  return raw === "suspended" ? "suspended" : "active";
}

function normalizeContentStatus(raw: string): ModerationContentStatus {
  return raw === "published" ? "published" : "draft";
}

function normalizeText(value: unknown): string {
  return String(value || "").trim().toLowerCase();
}

function mapModerationUserDoc(docSnap: QueryDocumentSnapshot<DocumentData>): AdminModerationUser {
  const data = docSnap.data() as Record<string, unknown>;
  const role = normalizeUserRole(String(data.role || ""));
  return {
    id: docSnap.id,
    displayName: String(data.name || data.displayName || data.fullName || data.email || "User"),
    email: String(data.email || "-"),
    role,
    status: normalizeUserStatus(String(data.status || "active")),
  };
}

function mapModerationContentDoc(
  docSnap: QueryDocumentSnapshot<DocumentData>,
  doctorNameMap: Map<string, string>,
): AdminModerationContent {
  const data = docSnap.data() as Record<string, unknown>;
  const doctorId = String(data.dokterId || data.doctorId || "");
  return {
    id: docSnap.id,
    title: String(data.judul || data.title || data.namaKonten || "Konten"),
    status: normalizeContentStatus(String(data.status || "draft")),
    doctorName: doctorNameMap.get(doctorId) || "Dokter",
  };
}

function createUserMatcher(searchRaw: string): ((item: AdminModerationUser) => boolean) | null {
  const queryText = normalizeText(searchRaw);
  if (!queryText) return null;

  return (item: AdminModerationUser) => {
    return (
      normalizeText(item.displayName).includes(queryText) || normalizeText(item.email).includes(queryText)
    );
  };
}

function createContentMatcher(
  searchRaw: string,
): ((item: AdminModerationContent) => boolean) | null {
  const queryText = normalizeText(searchRaw);
  if (!queryText) return null;

  return (item: AdminModerationContent) => {
    return (
      normalizeText(item.title).includes(queryText) || normalizeText(item.doctorName).includes(queryText)
    );
  };
}

async function hasNextMatching<T>(params: {
  collectionName: "users" | "konten";
  startCursor: QueryDocumentSnapshot<DocumentData>;
  constraints: QueryConstraint[];
  batchSize: number;
  mapDoc: (docSnap: QueryDocumentSnapshot<DocumentData>) => Promise<T>;
  matcher: ((item: T) => boolean) | null;
}): Promise<boolean> {
  let cursor: QueryDocumentSnapshot<DocumentData> | null = params.startCursor;

  for (let round = 0; round < MAX_SCAN_ROUNDS; round += 1) {
    const pagingConstraints: QueryConstraint[] = [...params.constraints];
    if (cursor) {
      pagingConstraints.push(startAfter(cursor));
    }
    pagingConstraints.push(limit(params.batchSize));

    const snap = await getDocs(query(collection(firestore, params.collectionName), ...pagingConstraints));
    if (snap.empty) return false;

    for (const docSnap of snap.docs) {
      const mapped = await params.mapDoc(docSnap);
      if (!params.matcher || params.matcher(mapped)) {
        return true;
      }
    }

    if (snap.docs.length < params.batchSize) return false;
    cursor = snap.docs[snap.docs.length - 1];
  }

  return true;
}

async function resolveDoctorNameMap(
  doctorIds: string[],
  cache: Map<string, string>,
): Promise<Map<string, string>> {
  const missingDoctorIds = doctorIds.filter((doctorId) => doctorId && !cache.has(doctorId));
  if (missingDoctorIds.length === 0) return cache;

  await Promise.all(
    missingDoctorIds.map(async (doctorId) => {
      try {
        const userSnap = await getDoc(doc(firestore, "users", doctorId));
        if (!userSnap.exists()) {
          cache.set(doctorId, "Dokter");
          return;
        }
        const userData = userSnap.data() as Record<string, unknown>;
        cache.set(
          doctorId,
          String(userData.name || userData.displayName || userData.fullName || userData.email || "Dokter"),
        );
      } catch (error) {
        console.error("[AdminModerationData] Failed resolving doctor name", { doctorId, error });
        cache.set(doctorId, "Dokter");
      }
    }),
  );

  return cache;
}

export async function getAdminModerationUsersPaginated(
  params: PaginatedQueryParams<AdminModerationUserFilter> = {},
): Promise<PaginatedResult<AdminModerationUser>> {
  const pageSize = params.pageSize && params.pageSize > 0 ? params.pageSize : DEFAULT_PAGE_SIZE;
  const batchSize = Math.max(DEFAULT_SCAN_BATCH_SIZE, pageSize * 2);
  const matcher = createUserMatcher(params.search || "");

  const constraints: QueryConstraint[] = [];
  const roleFilter = params.filters?.role;
  const statusFilter = params.filters?.status;

  let cursor = params.cursor || null;
  const items: AdminModerationUser[] = [];
  let lastScannedCursor: QueryDocumentSnapshot<DocumentData> | null = cursor;

  for (let round = 0; round < MAX_SCAN_ROUNDS; round += 1) {
    const pagingConstraints: QueryConstraint[] = [...constraints];
    if (cursor) {
      pagingConstraints.push(startAfter(cursor));
    }
    pagingConstraints.push(limit(batchSize));

    const snap = await getDocs(query(collection(firestore, "users"), ...pagingConstraints));
    if (snap.empty) break;

    for (const docSnap of snap.docs) {
      const mapped = mapModerationUserDoc(docSnap);
      const roleMatches = !roleFilter || roleFilter === "all" || mapped.role === roleFilter;
      const statusMatches = !statusFilter || statusFilter === "all" || mapped.status === statusFilter;
      const searchMatches = !matcher || matcher(mapped);

      if (roleMatches && statusMatches && searchMatches) {
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

  const hasNext = await hasNextMatching<AdminModerationUser>({
    collectionName: "users",
    startCursor: lastScannedCursor,
    constraints,
    batchSize,
    mapDoc: async (docSnap) => mapModerationUserDoc(docSnap),
    matcher,
  });

  return {
    items,
    nextCursor: hasNext ? lastScannedCursor : null,
    hasNext,
  };
}

export async function getAdminModerationContentsPaginated(
  params: PaginatedQueryParams<AdminModerationContentFilter> = {},
): Promise<PaginatedResult<AdminModerationContent>> {
  const pageSize = params.pageSize && params.pageSize > 0 ? params.pageSize : DEFAULT_PAGE_SIZE;
  const batchSize = Math.max(DEFAULT_SCAN_BATCH_SIZE, pageSize * 2);

  const constraints: QueryConstraint[] = [];
  const statusFilter = params.filters?.status;

  const doctorNameCache = new Map<string, string>();
  const searchRaw = normalizeText(params.search || "");
  const matcher = createContentMatcher(searchRaw);

  let cursor = params.cursor || null;
  const items: AdminModerationContent[] = [];
  let lastScannedCursor: QueryDocumentSnapshot<DocumentData> | null = cursor;

  for (let round = 0; round < MAX_SCAN_ROUNDS; round += 1) {
    const pagingConstraints: QueryConstraint[] = [...constraints];
    if (cursor) {
      pagingConstraints.push(startAfter(cursor));
    }
    pagingConstraints.push(limit(batchSize));

    const snap = await getDocs(query(collection(firestore, "konten"), ...pagingConstraints));
    if (snap.empty) break;

    const doctorIds = snap.docs.map((docSnap) => {
      const data = docSnap.data() as Record<string, unknown>;
      return String(data.dokterId || data.doctorId || "");
    });
    await resolveDoctorNameMap(doctorIds, doctorNameCache);

    for (const docSnap of snap.docs) {
      const mapped = mapModerationContentDoc(docSnap, doctorNameCache);
      const statusMatches = !statusFilter || statusFilter === "all" || mapped.status === statusFilter;
      const searchMatches = !matcher || matcher(mapped);

      if (statusMatches && searchMatches) {
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

  const hasNext = await hasNextMatching<AdminModerationContent>({
    collectionName: "konten",
    startCursor: lastScannedCursor,
    constraints,
    batchSize,
    mapDoc: async (docSnap) => {
      const data = docSnap.data() as Record<string, unknown>;
      const doctorId = String(data.dokterId || data.doctorId || "");
      await resolveDoctorNameMap([doctorId], doctorNameCache);
      return mapModerationContentDoc(docSnap, doctorNameCache);
    },
    matcher,
  });

  return {
    items,
    nextCursor: hasNext ? lastScannedCursor : null,
    hasNext,
  };
}

export async function getAdminModerationSnapshot(): Promise<{
  users: AdminModerationUser[];
  contents: AdminModerationContent[];
}> {
  const [usersResult, contentsResult] = await Promise.all([
    getAdminModerationUsersPaginated({ pageSize: 12 }),
    getAdminModerationContentsPaginated({ pageSize: 12 }),
  ]);

  return {
    users: usersResult.items,
    contents: contentsResult.items,
  };
}

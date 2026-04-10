import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  DocumentReference,
  getDoc,
  getDocs,
  limit,
  orderBy,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
} from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

export type DoctorContentItem = {
  id: string;
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
  bodySource?: "section" | "top-level" | "empty";
  status: "draft" | "published";
  doctorId: string;
  createdAt: string;
};

export type ContentAssignmentRecipient = {
  pasienId: string;
  fullName: string;
  mrn: string;
};

export type BulkAssignResult = {
  assignedCount: number;
  failedCount: number;
  failedPatients: Array<{ pasienId: string; reason: string }>;
};

export type BulkUnassignResult = {
  updatedCount: number;
  failedCount: number;
  failedPatients: Array<{ pasienId: string; reason: string }>;
};

type ContentDoc = Record<string, unknown>;

const CANONICAL_ANESTHESIA = [
  "Anestesi Umum",
  "Anestesi Spinal",
  "Anestesi Epidural",
  "Anestesi Regional",
  "Anestesi Lokal + Sedasi",
] as const;

const ANESTHESIA_ALIASES: Record<string, (typeof CANONICAL_ANESTHESIA)[number]> = {
  "general anesthesia": "Anestesi Umum",
  "anestesi umum": "Anestesi Umum",
  "spinal anesthesia": "Anestesi Spinal",
  "anestesi spinal": "Anestesi Spinal",
  epidural: "Anestesi Epidural",
  "epidural anesthesia": "Anestesi Epidural",
  "anestesi epidural": "Anestesi Epidural",
  "regional anesthesia": "Anestesi Regional",
  "anestesi regional": "Anestesi Regional",
  "local anesthesia + sedation": "Anestesi Lokal + Sedasi",
  "anestesi lokal + sedasi": "Anestesi Lokal + Sedasi",
};

function normalizeStatus(raw: unknown): "draft" | "published" {
  return String(raw || "").toLowerCase() === "published" ? "published" : "draft";
}

function normalizeDate(value: unknown): string {
  if (!value || typeof value !== "object") return "-";
  const maybeTimestamp = value as { toDate?: () => Date };
  if (typeof maybeTimestamp.toDate !== "function") return "-";
  return maybeTimestamp.toDate().toLocaleDateString("id-ID", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  });
}

function toNonEmptyString(value: unknown): string {
  return typeof value === "string" && value.trim().length > 0 ? value.trim() : "";
}

function normalizeAnesthesiaLabel(raw: unknown): string {
  const value = toNonEmptyString(raw);
  if (!value) return "-";
  const normalized = ANESTHESIA_ALIASES[value.toLowerCase()];
  if (normalized) return normalized;
  return value;
}

function toLegacyAnesthesiaLabel(canonical: string): string {
  const map: Record<string, string> = {
    "Anestesi Umum": "General Anesthesia",
    "Anestesi Spinal": "Spinal Anesthesia",
    "Anestesi Epidural": "Epidural Anesthesia",
    "Anestesi Regional": "Regional Anesthesia",
    "Anestesi Lokal + Sedasi": "Local Anesthesia + Sedation",
  };
  return map[canonical] ?? canonical;
}

function getTopLevelBody(data: ContentDoc): string {
  const isiKonten = data.isiKonten;
  if (typeof isiKonten === "string" && isiKonten.trim()) return isiKonten.trim();
  if (isiKonten && typeof isiKonten === "object") {
    const nestedIsiKonten = toNonEmptyString((isiKonten as ContentDoc).isiKonten);
    if (nestedIsiKonten) return nestedIsiKonten;
    const nestedBody = toNonEmptyString((isiKonten as ContentDoc).body);
    if (nestedBody) return nestedBody;
  }
  return toNonEmptyString(data.body);
}

async function getPrimarySectionBody(contentId: string): Promise<string> {
  const sectionsRef = collection(firestore, "konten", contentId, "sections");
  const sectionSnap = await getDocs(query(sectionsRef, orderBy("urutan"), limit(1)));
  if (sectionSnap.empty) return "";
  const sectionData = sectionSnap.docs[0].data() as ContentDoc;
  return toNonEmptyString(sectionData.isiKonten || sectionData.body);
}

async function mapContent(docId: string, data: ContentDoc): Promise<DoctorContentItem> {
  const topLevelBody = getTopLevelBody(data);
  let sectionBody = "";
  try {
    sectionBody = await getPrimarySectionBody(docId);
  } catch (error) {
    console.debug("[DoctorContentService] section read fallback to top-level", {
      contentId: docId,
      error,
    });
  }

  const finalBody = sectionBody || topLevelBody;
  const bodySource: DoctorContentItem["bodySource"] = sectionBody
    ? "section"
    : topLevelBody
      ? "top-level"
      : "empty";

  return {
    id: docId,
    title: String(data.judul || data.title || "Tanpa Judul"),
    anesthesiaType: normalizeAnesthesiaLabel(data.jenisAnestesi || data.anesthesiaType),
    description: String(data.indikasiTindakan || data.deskripsi || data.description || ""),
    body: finalBody,
    bodySource,
    status: normalizeStatus(data.status),
    doctorId: String(data.dokterId || data.doctorId || ""),
    createdAt: normalizeDate(data.createdAt),
  };
}

export async function getDoctorContents(doctorUid: string): Promise<DoctorContentItem[]> {
  const kontenRef = collection(firestore, "konten");
  const [byDokterIdSnap, byDoctorIdSnap] = await Promise.all([
    getDocs(query(kontenRef, where("dokterId", "==", doctorUid))),
    getDocs(query(kontenRef, where("doctorId", "==", doctorUid))),
  ]);

  const docsById = new Map<string, ContentDoc>();
  [...byDokterIdSnap.docs, ...byDoctorIdSnap.docs].forEach((item) => {
    docsById.set(item.id, item.data() as ContentDoc);
  });

  console.debug("[DoctorContentService] getDoctorContents", {
    doctorUid,
    rawDokterId: byDokterIdSnap.size,
    rawDoctorId: byDoctorIdSnap.size,
    deduped: docsById.size,
  });

  const mapped = await Promise.all(
    Array.from(docsById.entries()).map(([id, data]) => mapContent(id, data)),
  );
  mapped.forEach((item) => {
    console.debug("[DoctorContentService] content body source", {
      contentId: item.id,
      bodySource: item.bodySource,
    });
  });
  return mapped.sort((a, b) => a.title.localeCompare(b.title));
}

export async function createDoctorContent(params: {
  doctorUid: string;
  doctorName: string;
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
}) {
  const canonicalAnesthesia = normalizeAnesthesiaLabel(params.anesthesiaType);
  const legacyAnesthesia = toLegacyAnesthesiaLabel(canonicalAnesthesia);
  const payload = {
    judul: params.title,
    title: params.title,
    jenisAnestesi: canonicalAnesthesia,
    anesthesiaType: legacyAnesthesia,
    indikasiTindakan: params.description,
    deskripsi: params.description,
    description: params.description,
    isiKonten: params.body,
    body: params.body,
    dokterId: params.doctorUid,
    doctorId: params.doctorUid,
    dokterName: params.doctorName || "Dokter",
    status: "draft",
    jumlahBagian: 1,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  };

  const contentRef = await addDoc(collection(firestore, "konten"), payload);

  try {
    await addDoc(collection(firestore, "konten", contentRef.id, "sections"), {
      kontenId: contentRef.id,
      urutan: 1,
      judulBagian: "Bagian 1",
      isiKonten: params.body,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    });
  } catch (error) {
    await deleteDoc(contentRef).catch(() => undefined);
    throw error;
  }
}

export async function updateDoctorContent(params: {
  contentId: string;
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
}) {
  const canonicalAnesthesia = normalizeAnesthesiaLabel(params.anesthesiaType);
  const legacyAnesthesia = toLegacyAnesthesiaLabel(canonicalAnesthesia);
  await updateDoc(doc(firestore, "konten", params.contentId), {
    judul: params.title,
    title: params.title,
    jenisAnestesi: canonicalAnesthesia,
    anesthesiaType: legacyAnesthesia,
    indikasiTindakan: params.description,
    deskripsi: params.description,
    description: params.description,
    isiKonten: params.body,
    body: params.body,
    jumlahBagian: 1,
    updatedAt: serverTimestamp(),
  });

  const sectionsRef = collection(firestore, "konten", params.contentId, "sections");
  const firstSectionSnap = await getDocs(query(sectionsRef, orderBy("urutan"), limit(1)));
  if (firstSectionSnap.empty) {
    await addDoc(sectionsRef, {
      kontenId: params.contentId,
      urutan: 1,
      judulBagian: "Bagian 1",
      isiKonten: params.body,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    });
    return;
  }

  const firstSectionDoc = firstSectionSnap.docs[0];
  await setDoc(
    doc(firestore, "konten", params.contentId, "sections", firstSectionDoc.id),
    {
      ...firstSectionDoc.data(),
      kontenId: params.contentId,
      urutan: Number(firstSectionDoc.data().urutan || 1),
      judulBagian: String(firstSectionDoc.data().judulBagian || "Bagian 1"),
      isiKonten: params.body,
      updatedAt: serverTimestamp(),
    },
    { merge: true },
  );
}

export async function deleteDoctorContent(contentId: string) {
  const sectionsRef = collection(firestore, "konten", contentId, "sections");
  const sectionSnap = await getDocs(sectionsRef);
  await Promise.all(sectionSnap.docs.map((section) => deleteDoc(section.ref)));
  await deleteDoc(doc(firestore, "konten", contentId));
}

export const doctorContentAnesthesiaOptions = [...CANONICAL_ANESTHESIA];

async function validateDoctorContentOwner(
  contentId: string,
  doctorUid: string,
): Promise<void> {
  const kontenRef = doc(firestore, "konten", contentId);
  const kontenSnap = await getDoc(kontenRef);
  if (!kontenSnap.exists()) {
    throw new Error("Konten tidak ditemukan.");
  }

  const kontenData = kontenSnap.data() as ContentDoc;
  const kontenOwnerUid = String(kontenData.dokterId || kontenData.doctorId || "");
  if (!kontenOwnerUid || kontenOwnerUid !== doctorUid) {
    throw new Error("Anda bukan pemilik konten ini.");
  }
}

async function validateDoctorContentPublished(
  contentId: string,
): Promise<void> {
  const kontenRef = doc(firestore, "konten", contentId);
  const kontenSnap = await getDoc(kontenRef);
  if (!kontenSnap.exists()) {
    throw new Error("Konten tidak ditemukan.");
  }
  const kontenData = kontenSnap.data() as ContentDoc;
  const status = normalizeStatus(kontenData.status);
  if (status !== "published") {
    throw new Error("Konten draft belum bisa di-assign. Publish via Admin terlebih dahulu.");
  }
}

async function getPatientDoc(
  pasienId: string,
): Promise<{ pasienId: string; snap: Awaited<ReturnType<typeof getDoc>> }> {
  const pasienRef = doc(firestore, "pasien_profiles", pasienId);
  return {
    pasienId,
    snap: await getDoc(pasienRef),
  };
}

export async function assignDoctorContentToPatients(params: {
  doctorUid: string;
  contentId: string;
  pasienIds: string[];
}): Promise<BulkAssignResult> {
  const { doctorUid, contentId, pasienIds } = params;
  const dedupedPasienIds = Array.from(
    new Set(pasienIds.map((item) => item.trim()).filter(Boolean)),
  );

  if (dedupedPasienIds.length === 0) {
    throw new Error("Pilih minimal 1 pasien.");
  }

  await validateDoctorContentOwner(contentId, doctorUid);
  await validateDoctorContentPublished(contentId);

  const patientSnapshots = await Promise.all(
    dedupedPasienIds.map((pasienId) => getPatientDoc(pasienId)),
  );

  const writablePatients: string[] = [];
  const failedPatients: Array<{ pasienId: string; reason: string }> = [];

  patientSnapshots.forEach(({ pasienId, snap }) => {
    if (!snap.exists()) {
      failedPatients.push({
        pasienId,
        reason: "Pasien tidak ditemukan.",
      });
      return;
    }
    const pasienData = snap.data() as Record<string, unknown>;
    const pasienDokterId = String(
      pasienData.dokterId || pasienData.assignedDokterId || "",
    );
    if (!pasienDokterId || pasienDokterId !== doctorUid) {
      failedPatients.push({
        pasienId,
        reason: "Pasien di luar scope dokter.",
      });
      return;
    }
    writablePatients.push(pasienId);
  });

  const writeResults = await Promise.all(
    writablePatients.map(async (pasienId) => {
      const assignmentId = `${contentId}_${pasienId}`;
      try {
        await setDoc(
          doc(firestore, "assignments", assignmentId),
          {
            pasienId,
            dokterId: doctorUid,
            kontenId: contentId,
            assignedBy: doctorUid,
            status: "assigned",
            assignedAt: serverTimestamp(),
            updatedAt: serverTimestamp(),
            isCompleted: false,
            currentBagian: 1,
            completedAt: null,
          },
          { merge: true },
        );
        return { pasienId, ok: true as const };
      } catch (error) {
        console.error("[DoctorContentService] assign write failed", {
          pasienId,
          contentId,
          doctorUid,
          error,
        });
        return {
          pasienId,
          ok: false as const,
          reason: "Gagal menulis assignment.",
        };
      }
    }),
  );

  writeResults.forEach((result) => {
    if (!result.ok) {
      failedPatients.push({
        pasienId: result.pasienId,
        reason: result.reason,
      });
    }
  });

  const assignedCount = writeResults.filter((result) => result.ok).length;
  const failedCount = failedPatients.length;

  return {
    assignedCount,
    failedCount,
    failedPatients,
  };
}

export async function unassignDoctorContentFromPatients(params: {
  doctorUid: string;
  contentId: string;
  pasienIds: string[];
}): Promise<BulkUnassignResult> {
  const { doctorUid, contentId, pasienIds } = params;
  const dedupedPasienIds = Array.from(
    new Set(pasienIds.map((item) => item.trim()).filter(Boolean)),
  );

  if (dedupedPasienIds.length === 0) {
    throw new Error("Pilih minimal 1 pasien.");
  }

  await validateDoctorContentOwner(contentId, doctorUid);

  const writeResults = await Promise.all(
    dedupedPasienIds.map(async (pasienId) => {
      const assignmentId = `${contentId}_${pasienId}`;
      const ref = doc(firestore, "assignments", assignmentId);
      try {
        const existing = await getDoc(ref);
        if (!existing.exists()) {
          return {
            pasienId,
            ok: false as const,
            reason: "Assignment tidak ditemukan.",
          };
        }

        const data = existing.data() as Record<string, unknown>;
        const ownerDokterId = String(data.dokterId || data.assignedBy || "");
        if (!ownerDokterId || ownerDokterId !== doctorUid) {
          return {
            pasienId,
            ok: false as const,
            reason: "Assignment di luar scope dokter.",
          };
        }

        const currentStatus = String(data.status || "").toLowerCase();
        if (currentStatus === "cancelled") {
          return { pasienId, ok: true as const };
        }

        await setDoc(
          ref,
          {
            status: "cancelled",
            cancelledAt: serverTimestamp(),
            cancelledBy: doctorUid,
            updatedAt: serverTimestamp(),
          },
          { merge: true },
        );
        return { pasienId, ok: true as const };
      } catch (error) {
        console.error("[DoctorContentService] unassign write failed", {
          pasienId,
          contentId,
          doctorUid,
          error,
        });
        return {
          pasienId,
          ok: false as const,
          reason: "Gagal membatalkan assignment.",
        };
      }
    }),
  );

  const failedPatients = writeResults
    .filter((item) => !item.ok)
    .map((item) => ({ pasienId: item.pasienId, reason: item.reason }));

  const updatedCount = writeResults.filter((item) => item.ok).length;
  return {
    updatedCount,
    failedCount: failedPatients.length,
    failedPatients,
  };
}

export async function unassignAllDoctorContentRecipients(params: {
  doctorUid: string;
  contentId: string;
}): Promise<BulkUnassignResult> {
  const { doctorUid, contentId } = params;
  await validateDoctorContentOwner(contentId, doctorUid);

  const assignmentSnap = await getDocs(
    query(
      collection(firestore, "assignments"),
      where("dokterId", "==", doctorUid),
      where("kontenId", "==", contentId),
    ),
  );

  const activePasienIds = assignmentSnap.docs
    .map((item) => item.data() as Record<string, unknown>)
    .filter((item) => {
      const status = String(item.status || "").toLowerCase();
      return status === "assigned" || status === "active";
    })
    .map((item) => String(item.pasienId || ""))
    .filter((id) => id.length > 0);

  if (activePasienIds.length === 0) {
    return {
      updatedCount: 0,
      failedCount: 0,
      failedPatients: [],
    };
  }

  return unassignDoctorContentFromPatients({
    doctorUid,
    contentId,
    pasienIds: activePasienIds,
  });
}

export async function assignDoctorContentToPatient(params: {
  doctorUid: string;
  contentId: string;
  pasienId: string;
}) {
  const result = await assignDoctorContentToPatients({
    doctorUid: params.doctorUid,
    contentId: params.contentId,
    pasienIds: [params.pasienId],
  });

  if (result.failedCount > 0) {
    throw new Error(result.failedPatients[0]?.reason || "Assign konten gagal.");
  }
}

export async function getDoctorContentAssignmentRecipients(
  doctorUid: string,
  contentIds: string[],
): Promise<Record<string, ContentAssignmentRecipient[]>> {
  const sanitizedIds = Array.from(new Set(contentIds.map((item) => item.trim()).filter(Boolean)));
  if (sanitizedIds.length === 0) return {};

  const assignmentSnap = await getDocs(
    query(collection(firestore, "assignments"), where("dokterId", "==", doctorUid)),
  );
  const contentIdSet = new Set(sanitizedIds);
  const filteredAssignments = assignmentSnap.docs
    .map((docSnap) => docSnap.data() as Record<string, unknown>)
    .filter((assignment) => {
      const kontenId = String(assignment.kontenId || "");
      const status = String(assignment.status || "").toLowerCase();
      return contentIdSet.has(kontenId) && status !== "cancelled";
    });

  const uniquePasienIds = Array.from(
    new Set(filteredAssignments.map((assignment) => String(assignment.pasienId || "")).filter(Boolean)),
  );

  const pasienDocRefs: DocumentReference[] = uniquePasienIds.map((pasienId) =>
    doc(firestore, "pasien_profiles", pasienId),
  );
  const pasienSnaps = await Promise.all(pasienDocRefs.map((ref) => getDoc(ref)));
  const patientMap = new Map<string, ContentAssignmentRecipient>();

  pasienSnaps.forEach((snap) => {
    if (!snap.exists()) return;
    const data = snap.data() as Record<string, unknown>;
    patientMap.set(snap.id, {
      pasienId: snap.id,
      fullName: String(data.namaLengkap || data.fullName || "Pasien"),
      mrn: String(data.noRekamMedis || data.mrn || "-"),
    });
  });

  const recipientsByContent: Record<string, ContentAssignmentRecipient[]> = {};
  filteredAssignments.forEach((assignment) => {
    const contentId = String(assignment.kontenId || "");
    const pasienId = String(assignment.pasienId || "");
    if (!contentId || !pasienId) return;
    const patient = patientMap.get(pasienId);
    if (!patient) return;
    recipientsByContent[contentId] = recipientsByContent[contentId] || [];
    if (!recipientsByContent[contentId].some((item) => item.pasienId === pasienId)) {
      recipientsByContent[contentId].push(patient);
    }
  });

  Object.keys(recipientsByContent).forEach((contentId) => {
    recipientsByContent[contentId].sort((a, b) => a.fullName.localeCompare(b.fullName));
  });

  return recipientsByContent;
}

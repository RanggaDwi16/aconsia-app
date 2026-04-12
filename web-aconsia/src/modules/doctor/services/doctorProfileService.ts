import {
  doc,
  getDoc,
  query,
  collection,
  where,
  getDocs,
  serverTimestamp,
  setDoc,
} from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";
import {
  getLatestQuizScoreForDoctor,
  resolveComprehensionScoreFromProfile,
} from "./doctorComprehension";
import {
  collectPasienIdentifiers,
  mergePatientRowsByCanonicalUid,
  resolveOperationalStatus,
} from "./patientDataNormalizer";

export type DoctorProfileData = {
  uid: string;
  fullName: string;
  email: string;
  phoneNumber: string;
  sipNumber: string;
  strNumber: string;
  specialization: string;
  hospitalName: string;
  status: string;
  joinedAtLabel: string;
};

export type DoctorPerformanceData = {
  totalPatients: number;
  avgComprehension: number;
  approvedPatients: number;
  pendingPatients: number;
};

function formatJoinedAt(value: unknown): string {
  if (!value || typeof value !== "object") return "-";

  const maybeTimestamp = value as { toDate?: () => Date };
  if (typeof maybeTimestamp.toDate !== "function") return "-";

  return maybeTimestamp.toDate().toLocaleDateString("id-ID", {
    month: "long",
    year: "numeric",
  });
}

export async function getDoctorProfile(uid: string): Promise<DoctorProfileData> {
  const [userSnap, profileSnap] = await Promise.all([
    getDoc(doc(firestore, "users", uid)),
    getDoc(doc(firestore, "dokter_profiles", uid)),
  ]);

  if (!userSnap.exists() && !profileSnap.exists()) {
    throw new Error("Profil dokter tidak ditemukan.");
  }

  const user = userSnap.exists() ? (userSnap.data() as Record<string, unknown>) : {};
  const profile = profileSnap.exists() ? (profileSnap.data() as Record<string, unknown>) : {};

  return {
    uid,
    fullName: String(profile.fullName || profile.nama || user.name || user.displayName || "Dokter"),
    email: String(profile.email || user.email || ""),
    phoneNumber: String(profile.phoneNumber || profile.noTelepon || user.phone || ""),
    sipNumber: String(profile.sipNumber || user.sipNumber || ""),
    strNumber: String(profile.strNumber || user.strNumber || ""),
    specialization: String(profile.specialization || user.specialization || "Anestesiologi"),
    hospitalName: String(profile.hospitalName || profile.namaRumahSakit || user.hospital || ""),
    status: String(profile.status || user.status || "active"),
    joinedAtLabel: formatJoinedAt(profile.createdAt || user.createdAt),
  };
}

export async function getDoctorPerformance(uid: string): Promise<DoctorPerformanceData> {
  const pasienRef = collection(firestore, "pasien_profiles");
  const dokterIdQuery = query(pasienRef, where("dokterId", "==", uid));
  const assignedDokterIdQuery = query(
    pasienRef,
    where("assignedDokterId", "==", uid),
  );

  const [dokterIdSnap, assignedDokterIdSnap] = await Promise.all([
    getDocs(dokterIdQuery),
    getDocs(assignedDokterIdQuery),
  ]);

  const mergedRows = mergePatientRowsByCanonicalUid(
    [...dokterIdSnap.docs, ...assignedDokterIdSnap.docs].map((docSnap) => ({
      docId: docSnap.id,
      data: docSnap.data() as Record<string, unknown>,
    })),
  );
  const patients = mergedRows.map((row) => ({
    id: row.primaryDocId,
    canonicalUid: row.canonicalUid,
    data: row.data,
  }));
  const operationalStatuses = patients.map((entry) =>
    resolveOperationalStatus(entry.data),
  );

  const totalPatients = patients.length;
  const approvedPatients = operationalStatuses.filter((status) =>
    ["approved", "in_progress", "ready", "completed"].includes(status),
  ).length;
  const pendingPatients = operationalStatuses.filter((status) => status === "pending").length;

  const latestScoreByPatientId = new Map<string, number>();
  await Promise.all(
    patients.map(async (entry) => {
      try {
        const latest = await getLatestQuizScoreForDoctor({
          candidateIds: collectPasienIdentifiers(entry.id, {
            ...entry.data,
            uid: entry.canonicalUid,
          }),
          doctorUid: uid,
        });
        if (latest !== null) {
          latestScoreByPatientId.set(entry.id, latest);
        }
      } catch (error) {
        if (import.meta.env.DEV) {
          console.warn("[doctorProfileService] latest quiz fallback failed", {
            patientId: entry.id,
            doctorUid: uid,
            error,
          });
        }
      }
    }),
  );

  const scored = patients
    .map((entry) => {
      const cacheScore = resolveComprehensionScoreFromProfile(entry.data);
      return latestScoreByPatientId.get(entry.id) ?? cacheScore;
    })
    .filter((x) => Number.isFinite(x) && x > 0);

  const avgComprehension =
    scored.length > 0
      ? Math.round(scored.reduce((sum, val) => sum + val, 0) / scored.length)
      : 0;

  if (import.meta.env.DEV) {
    console.info("[doctorProfileService] performance_metrics", {
      doctorUid: uid,
      dokterIdCount: dokterIdSnap.size,
      assignedDokterIdCount: assignedDokterIdSnap.size,
      mergedCount: totalPatients,
      approvedCount: approvedPatients,
      pendingCount: pendingPatients,
      timestamp: new Date().toISOString(),
    });
  }

  return {
    totalPatients,
    avgComprehension,
    approvedPatients,
    pendingPatients,
  };
}

export async function updateDoctorProfile(uid: string, profile: DoctorProfileData) {
  const fullName = profile.fullName.trim();
  const email = profile.email.trim().toLowerCase();
  const phoneNumber = profile.phoneNumber.trim();
  const hospitalName = profile.hospitalName.trim();
  const sipNumber = profile.sipNumber.trim();
  const strNumber = profile.strNumber.trim();

  await Promise.all([
    setDoc(
      doc(firestore, "users", uid),
      {
        uid,
        email,
        name: fullName,
        displayName: fullName,
        role: "dokter",
        status: "active",
        phone: phoneNumber,
        hospital: hospitalName,
        specialization: "Anestesiologi",
        sipNumber,
        strNumber,
        isProfileCompleted: true,
        updatedAt: serverTimestamp(),
      },
      { merge: true },
    ),
    setDoc(
      doc(firestore, "dokter_profiles", uid),
      {
        uid,
        email,
        fullName,
        nama: fullName,
        phoneNumber,
        noTelepon: phoneNumber,
        hospitalName,
        namaRumahSakit: hospitalName,
        specialization: "Anestesiologi",
        sipNumber,
        strNumber,
        status: "active",
        updatedAt: serverTimestamp(),
      },
      { merge: true },
    ),
  ]);
}

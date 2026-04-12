import { onAuthStateChanged, type User } from "firebase/auth";
import {
  collection,
  getDocs,
  query,
  where,
} from "firebase/firestore";
import { httpsCallable } from "firebase/functions";
import {
  firebaseAuth,
  firebaseFunctions,
  firestore,
} from "../../../core/firebase/client";
import {
  getLatestQuizScoreForDoctor,
  resolveComprehensionScoreFromProfile,
} from "./doctorComprehension";
import {
  collectPasienIdentifiers,
  mergePatientRowsByCanonicalUid,
  normalizeDoctorPatientDisplay,
  readNonEmptyText,
  resolveOperationalStatus,
} from "./patientDataNormalizer";

const assignAnesthesiaCallable = httpsCallable(
  firebaseFunctions,
  "assignPasienAnesthesia",
);

export type DoctorDashboardPatient = {
  id: string;
  pasienUid: string;
  fullName: string;
  mrn: string;
  nik?: string;
  phone?: string;
  diagnosis: string;
  scheduleText: string;
  scheduleDateRaw: string;
  scheduleTimeRaw: string;
  anesthesiaType?: string | null;
  status?: string;
  comprehensionScore?: number;
  assignedDoctorId?: string;
};

function resolveAssignedDoctorId(data: Record<string, unknown>, doctorUid: string): string {
  return (
    readNonEmptyText(data.dokterId) ||
    readNonEmptyText(data.assignedDokterId) ||
    doctorUid
  );
}

function resolvePatientName(data: Record<string, unknown>): string {
  return (
    readNonEmptyText(data.namaLengkap) ||
    readNonEmptyText(data.fullName) ||
    readNonEmptyText(data.name) ||
    "Pasien"
  );
}

function resolveAnesthesiaType(data: Record<string, unknown>): string | null {
  const value =
    readNonEmptyText(data.jenisAnestesi) ||
    readNonEmptyText(data.anesthesiaType);
  return value || null;
}

async function waitForAuthenticatedUser(timeoutMs = 2000): Promise<User | null> {
  if (firebaseAuth.currentUser) {
    return firebaseAuth.currentUser;
  }

  return await new Promise((resolve) => {
    const timeout = setTimeout(() => {
      unsubscribe();
      resolve(null);
    }, timeoutMs);

    const unsubscribe = onAuthStateChanged(firebaseAuth, (user) => {
      if (!user) return;
      clearTimeout(timeout);
      unsubscribe();
      resolve(user);
    });
  });
}

export async function getDoctorScopedPatients(
  doctorUid: string,
): Promise<DoctorDashboardPatient[]> {
  const authUser = await waitForAuthenticatedUser();

  if (!authUser) {
    const err = new Error("Firebase auth session belum siap.") as Error & {
      code?: string;
    };
    err.code = "auth/not-authenticated";
    throw err;
  }

  if (authUser.uid !== doctorUid) {
    const err = new Error("UID sesi lokal tidak sama dengan UID Firebase.") as Error & {
      code?: string;
    };
    err.code = "auth/session-mismatch";
    throw err;
  }

  const pasienRef = collection(firestore, "pasien_profiles");
  const dokterIdQuery = query(
    pasienRef,
    where("dokterId", "==", doctorUid),
  );
  const assignedDokterIdQuery = query(
    pasienRef,
    where("assignedDokterId", "==", doctorUid),
  );
  const [dokterIdSnapshot, assignedSnapshot] = await Promise.all([
    getDocs(dokterIdQuery),
    getDocs(assignedDokterIdQuery),
  ]);

  const groupedRows = mergePatientRowsByCanonicalUid(
    [...dokterIdSnapshot.docs, ...assignedSnapshot.docs].map((docSnap) => ({
      docId: docSnap.id,
      data: docSnap.data() as Record<string, unknown>,
    })),
  );

  const patients: DoctorDashboardPatient[] = groupedRows.map((row) => {
    const display = normalizeDoctorPatientDisplay(row.data);
    return {
      id: row.primaryDocId,
      pasienUid: row.canonicalUid,
      fullName: resolvePatientName(row.data),
      mrn: display.mrnText,
      nik: readNonEmptyText(row.data.nik),
      phone: readNonEmptyText(row.data.nomorTelepon) || readNonEmptyText(row.data.phone),
      diagnosis: display.diagnosisText,
      scheduleText: display.scheduleText,
      scheduleDateRaw: display.scheduleDateRaw,
      scheduleTimeRaw: display.scheduleTimeRaw,
      anesthesiaType: resolveAnesthesiaType(row.data),
      status: resolveOperationalStatus(row.data),
      comprehensionScore: resolveComprehensionScoreFromProfile(row.data),
      assignedDoctorId: resolveAssignedDoctorId(row.data, doctorUid),
    };
  });

  await Promise.all(
    patients.map(async (patient) => {
      try {
        const latestScore = await getLatestQuizScoreForDoctor({
          candidateIds: collectPasienIdentifiers(patient.id, {
            pasienId: patient.pasienUid,
          }),
          doctorUid,
        });
        if (latestScore !== null) {
          patient.comprehensionScore = latestScore;
        }
      } catch (error) {
        if (import.meta.env.DEV) {
          console.warn("[doctorDashboardService] latest quiz fallback failed", {
            pasienId: patient.id,
            doctorUid,
            error,
          });
        }
      }
    }),
  );

  return patients;
}

export async function assignAnesthesiaToPatient(params: {
  pasienId: string;
  anesthesiaType: string;
}) {
  const { pasienId, anesthesiaType } = params;

  await assignAnesthesiaCallable({
    pasienId,
    anesthesiaType,
  });
}

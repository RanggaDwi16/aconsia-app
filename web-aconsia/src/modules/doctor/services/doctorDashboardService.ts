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

const assignAnesthesiaCallable = httpsCallable(
  firebaseFunctions,
  "assignPasienAnesthesia",
);

export type DoctorDashboardPatient = {
  id: string;
  fullName: string;
  mrn: string;
  nik?: string;
  phone?: string;
  diagnosis?: string;
  surgeryDate?: string;
  anesthesiaType?: string | null;
  status?: string;
  comprehensionScore?: number;
  assignedDoctorId?: string;
};

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

  const merged = new Map<string, DoctorDashboardPatient>();
  const allDocs = [...dokterIdSnapshot.docs, ...assignedSnapshot.docs];

  for (const docSnap of allDocs) {
    const data = docSnap.data() as Record<string, unknown>;
    merged.set(docSnap.id, {
      id: docSnap.id,
      fullName: String(data.namaLengkap || data.fullName || "Pasien"),
      mrn: String(data.noRekamMedis || data.mrn || "-"),
      nik: String(data.nik || ""),
      phone: String(data.nomorTelepon || data.phone || ""),
      diagnosis: String(data.diagnosis || ""),
      surgeryDate: String(data.surgeryDate || ""),
      anesthesiaType: (data.jenisAnestesi || data.anesthesiaType || null) as
        | string
        | null,
      status: String(data.status || "approved"),
      comprehensionScore: Number(data.comprehensionScore || 0),
      assignedDoctorId: String(
        data.dokterId || data.assignedDokterId || doctorUid,
      ),
    });
  }

  return Array.from(merged.values());
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

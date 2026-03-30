import {
  collection,
  doc,
  getDocs,
  query,
  serverTimestamp,
  updateDoc,
  where,
} from "firebase/firestore";
import { httpsCallable } from "firebase/functions";
import { firebaseFunctions, firestore } from "../../../core/firebase/client";

const assignAnesthesiaCallable = httpsCallable(
  firebaseFunctions,
  "assignPasienAnesthesia",
);

function legacyAssignFallbackEnabled() {
  return import.meta.env.VITE_ALLOW_LEGACY_DOCTOR_MODERATION_FALLBACK === "true";
}

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

export async function getDoctorScopedPatients(
  doctorUid: string,
): Promise<DoctorDashboardPatient[]> {
  const pasienRef = collection(firestore, "pasien_profiles");
  const pasienQuery = query(
    pasienRef,
    where("assignedDokterId", "==", doctorUid),
  );
  const snapshot = await getDocs(pasienQuery);

  return snapshot.docs.map((docSnap) => {
    const data = docSnap.data() as Record<string, unknown>;

    return {
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
      assignedDoctorId: String(data.assignedDokterId || doctorUid),
    };
  });
}

export async function assignAnesthesiaToPatient(params: {
  pasienId: string;
  anesthesiaType: string;
}) {
  const { pasienId, anesthesiaType } = params;

  try {
    await assignAnesthesiaCallable({
      pasienId,
      anesthesiaType,
    });
    return { mode: "callable" as const };
  } catch (error) {
    if (!legacyAssignFallbackEnabled()) {
      throw error;
    }
    console.warn(
      "[DoctorDashboardService] Callable assign anesthesia failed, using fallback",
      error,
    );
  }

  const pasienDocRef = doc(firestore, "pasien_profiles", pasienId);

  await updateDoc(pasienDocRef, {
    jenisAnestesi: anesthesiaType,
    status: "in_progress",
    updatedAt: serverTimestamp(),
  });

  return { mode: "fallback" as const };
}

import { collection, getDocs } from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

export interface AdminPatientData {
  id: string;
  fullName: string;
  mrn: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready" | "completed";
  comprehensionScore: number;
  assignedDoctorId: string;
  scheduledConsentDate?: string;
}

export async function getAdminDashboardPatients(): Promise<AdminPatientData[]> {
  const pasienProfilesRef = collection(firestore, "pasien_profiles");
  const snapshot = await getDocs(pasienProfilesRef);

  return snapshot.docs.map((docSnap) => {
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
      surgeryType: String(data.jenisOperasi || data.surgeryType || "Belum ditentukan"),
      surgeryDate: String(data.surgeryDate || "Belum dijadwalkan"),
      anesthesiaType: (data.jenisAnestesi || data.anesthesiaType || null) as
        | string
        | null,
      status,
      comprehensionScore: Number(data.comprehensionScore || 0),
      assignedDoctorId: String(data.assignedDokterId || data.assignedDoctorId || ""),
      scheduledConsentDate: data.scheduledConsentDate
        ? String(data.scheduledConsentDate)
        : undefined,
    };
  });
}

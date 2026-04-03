import { collection, getDocs } from "firebase/firestore";
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
      nik: String(data.nik || ""),
      dateOfBirth: String(data.tanggalLahir || data.dateOfBirth || ""),
      age: String(data.age || ""),
      gender: String(data.jenisKelamin || data.gender || ""),
      diagnosis: String(data.diagnosis || ""),
      surgeryType: String(data.jenisOperasi || data.surgeryType || "Belum ditentukan"),
      surgeryDate: String(data.surgeryDate || "Belum dijadwalkan"),
      anesthesiaType: (data.jenisAnestesi || data.anesthesiaType || null) as
        | string
        | null,
      status,
      comprehensionScore: Number(data.comprehensionScore || 0),
      assignedDoctorId: String(data.assignedDokterId || data.assignedDoctorId || ""),
      materialsCompleted: Number(data.materialsCompleted || 0),
      totalMaterials: Number(data.totalMaterials || 0),
      lastActivity: String(data.lastActivity || "N/A"),
      scheduledConsentDate: data.scheduledConsentDate
        ? String(data.scheduledConsentDate)
        : undefined,
      createdAt: data.createdAt ? String(data.createdAt) : undefined,
    };
  });
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

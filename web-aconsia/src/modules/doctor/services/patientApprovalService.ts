import {
  doc,
  getDoc,
} from "firebase/firestore";
import { httpsCallable } from "firebase/functions";
import { firebaseFunctions, firestore } from "../../../core/firebase/client";

const approvePatientCallable = httpsCallable(firebaseFunctions, "approvePasienProfile");
const rejectPatientCallable = httpsCallable(firebaseFunctions, "rejectPasienProfile");

export interface DoctorApprovalPatient {
  id: string;
  fullName: string;
  mrn: string;
  nik?: string;
  dateOfBirth?: string;
  age?: string;
  gender?: string;
  phone?: string;
  address?: string;
  height?: string;
  weight?: string;
  bloodType?: string;
  allergies?: string;
  medicalHistory?: string;
  currentMedications?: string;
  previousAnesthesia?: string;
  diagnosis?: string;
  surgeryType?: string;
  anesthesiaType?: string;
  assignedDokterId?: string;
  status?: string;
}

export async function getPatientForApproval(
  pasienId: string,
): Promise<DoctorApprovalPatient | null> {
  const pasienDoc = await getDoc(doc(firestore, "pasien_profiles", pasienId));

  if (!pasienDoc.exists()) {
    return null;
  }

  const data = pasienDoc.data() as Record<string, unknown>;

  return {
    id: pasienDoc.id,
    fullName: String(data.namaLengkap || data.fullName || "Pasien"),
    mrn: String(data.noRekamMedis || data.mrn || "N/A"),
    nik: String(data.nik || ""),
    dateOfBirth: String(data.tanggalLahir || data.dateOfBirth || ""),
    age: String(data.age || ""),
    gender: String(data.jenisKelamin || data.gender || ""),
    phone: String(data.nomorTelepon || data.phone || ""),
    address: String(data.alamat || data.address || ""),
    height: String(data.tinggiBadan || data.height || ""),
    weight: String(data.beratBadan || data.weight || ""),
    bloodType: String(data.golonganDarah || data.bloodType || ""),
    allergies: String(data.allergies || ""),
    medicalHistory: String(data.medicalHistory || ""),
    currentMedications: String(data.currentMedications || ""),
    previousAnesthesia: String(data.previousAnesthesia || ""),
    diagnosis: String(data.diagnosis || ""),
    surgeryType: String(data.jenisOperasi || data.surgeryType || ""),
    anesthesiaType: String(data.jenisAnestesi || data.anesthesiaType || ""),
    assignedDokterId: String(data.assignedDokterId || ""),
    status: String(data.status || "pending"),
  };
}

export async function approvePatient(params: {
  pasienId: string;
  diagnosis: string;
  surgeryType: string;
  anesthesiaType: string;
}) {
  const { pasienId, diagnosis, surgeryType, anesthesiaType } = params;

  await approvePatientCallable({
    pasienId,
    diagnosis,
    surgeryType,
    anesthesiaType,
  });
}

export async function rejectPatient(params: {
  pasienId: string;
  reason?: string;
}) {
  const { pasienId, reason } = params;

  await rejectPatientCallable({
    pasienId,
    reason,
  });
}

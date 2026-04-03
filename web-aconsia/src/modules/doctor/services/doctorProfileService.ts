import { doc, getDoc, query, collection, where, getDocs, serverTimestamp, setDoc } from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

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
  const pasienQuery = query(
    collection(firestore, "pasien_profiles"),
    where("assignedDokterId", "==", uid),
  );
  const pasienSnap = await getDocs(pasienQuery);

  const patients = pasienSnap.docs.map((d) => d.data() as Record<string, unknown>);

  const totalPatients = patients.length;
  const approvedPatients = patients.filter((p) =>
    ["approved", "in_progress", "ready", "completed"].includes(String(p.status || "")),
  ).length;
  const pendingPatients = patients.filter((p) => String(p.status || "") === "pending").length;

  const scored = patients
    .map((p) => Number(p.comprehensionScore || 0))
    .filter((x) => Number.isFinite(x) && x > 0);

  const avgComprehension =
    scored.length > 0
      ? Math.round(scored.reduce((sum, val) => sum + val, 0) / scored.length)
      : 0;

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

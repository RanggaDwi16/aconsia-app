import { collection, getDocs } from "firebase/firestore";
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

export async function getAdminModerationSnapshot(): Promise<{
  users: AdminModerationUser[];
  contents: AdminModerationContent[];
}> {
  const usersRef = collection(firestore, "users");
  const kontenRef = collection(firestore, "konten");

  const [usersSnap, kontenSnap] = await Promise.all([
    getDocs(usersRef),
    getDocs(kontenRef),
  ]);

  const users = usersSnap.docs
    .map((docSnap) => {
      const data = docSnap.data() as Record<string, unknown>;
      const role = normalizeUserRole(String(data.role || ""));

      return {
        id: docSnap.id,
        displayName: String(
          data.name || data.displayName || data.fullName || data.email || "User",
        ),
        email: String(data.email || "-"),
        role,
        status: normalizeUserStatus(String(data.status || "active")),
      } satisfies AdminModerationUser;
    })
    .sort((a, b) => {
      if (a.role === "admin" && b.role !== "admin") return -1;
      if (a.role !== "admin" && b.role === "admin") return 1;
      return a.displayName.localeCompare(b.displayName);
    })
    .slice(0, 12);

  const userNameMap = new Map(users.map((user) => [user.id, user.displayName]));

  const contents = kontenSnap.docs
    .map((docSnap) => {
      const data = docSnap.data() as Record<string, unknown>;
      const doctorId = String(data.dokterId || data.doctorId || "");

      return {
        id: docSnap.id,
        title: String(data.judul || data.title || data.namaKonten || "Konten"),
        status: normalizeContentStatus(String(data.status || "draft")),
        doctorName: userNameMap.get(doctorId) || "Dokter",
      } satisfies AdminModerationContent;
    })
    .sort((a, b) => a.title.localeCompare(b.title))
    .slice(0, 12);

  return {
    users,
    contents,
  };
}

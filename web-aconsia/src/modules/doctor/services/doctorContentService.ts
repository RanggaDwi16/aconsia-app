import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  getDocs,
  query,
  serverTimestamp,
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
  status: "draft" | "published";
  doctorId: string;
  createdAt: string;
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

function mapContent(docId: string, data: Record<string, unknown>): DoctorContentItem {
  return {
    id: docId,
    title: String(data.judul || data.title || "Tanpa Judul"),
    anesthesiaType: String(data.jenisAnestesi || data.anesthesiaType || "-"),
    description: String(data.deskripsi || data.description || ""),
    body: String(data.isiKonten || data.body || ""),
    status: normalizeStatus(data.status),
    doctorId: String(data.dokterId || data.doctorId || ""),
    createdAt: normalizeDate(data.createdAt),
  };
}

export async function getDoctorContents(doctorUid: string): Promise<DoctorContentItem[]> {
  const kontenRef = collection(firestore, "konten");
  const q = query(kontenRef, where("dokterId", "==", doctorUid));
  const snap = await getDocs(q);
  return snap.docs
    .map((d) => mapContent(d.id, d.data() as Record<string, unknown>))
    .sort((a, b) => a.title.localeCompare(b.title));
}

export async function createDoctorContent(params: {
  doctorUid: string;
  doctorName: string;
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
}) {
  const payload = {
    judul: params.title,
    title: params.title,
    jenisAnestesi: params.anesthesiaType,
    anesthesiaType: params.anesthesiaType,
    deskripsi: params.description,
    description: params.description,
    isiKonten: params.body,
    body: params.body,
    dokterId: params.doctorUid,
    doctorId: params.doctorUid,
    dokterName: params.doctorName || "Dokter",
    status: "draft",
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  };

  await addDoc(collection(firestore, "konten"), payload);
}

export async function updateDoctorContent(params: {
  contentId: string;
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
}) {
  await updateDoc(doc(firestore, "konten", params.contentId), {
    judul: params.title,
    title: params.title,
    jenisAnestesi: params.anesthesiaType,
    anesthesiaType: params.anesthesiaType,
    deskripsi: params.description,
    description: params.description,
    isiKonten: params.body,
    body: params.body,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteDoctorContent(contentId: string) {
  await deleteDoc(doc(firestore, "konten", contentId));
}

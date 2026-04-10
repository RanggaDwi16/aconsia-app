import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router";
import {
  collection,
  doc,
  getDoc,
  onSnapshot,
  orderBy,
  query,
  where,
  type Timestamp,
} from "firebase/firestore";
import { AlertCircle, Clock3, MessageCircle, UserRound } from "lucide-react";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Badge } from "../../components/ui/badge";
import { Button } from "../../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { getDesktopSession } from "../../../core/auth/session";
import { firebaseAuth, firestore } from "../../../core/firebase/client";
import { userMessages } from "../../copy/userMessages";

type ChatSessionListItem = {
  id: string;
  pasienId: string;
  lastMessage: string;
  lastMessageAt?: Date;
  unreadCountDokter: number;
};

type PatientMeta = {
  name: string;
  mrn: string;
};

function toDateSafe(input: unknown): Date | undefined {
  if (!input) return undefined;
  if (typeof input === "object" && input !== null && "toDate" in input) {
    return (input as Timestamp).toDate();
  }
  return undefined;
}

function formatLastMessageAt(date?: Date): string {
  if (!date) return "-";
  return date.toLocaleString("id-ID", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

export function DoctorChats() {
  const navigate = useNavigate();
  const session = getDesktopSession();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [sessions, setSessions] = useState<ChatSessionListItem[]>([]);
  const [patientMetaMap, setPatientMetaMap] = useState<Record<string, PatientMeta>>({});

  useEffect(() => {
    if (!session?.uid) {
      setError("Sesi login dokter tidak ditemukan.");
      setLoading(false);
      return;
    }

    const firebaseUid = firebaseAuth.currentUser?.uid;
    if (firebaseUid && firebaseUid !== session.uid) {
      setError(userMessages.doctorChats.authMismatch);
      setLoading(false);
      return;
    }

    const sessionsQuery = query(
      collection(firestore, "chat_sessions"),
      where("dokterId", "==", session.uid),
      orderBy("lastMessageAt", "desc"),
    );

    const unsubscribe = onSnapshot(
      sessionsQuery,
      async (snapshot) => {
        const mapped: ChatSessionListItem[] = snapshot.docs.map((docSnap) => {
          const data = docSnap.data() as Record<string, unknown>;
          return {
            id: docSnap.id,
            pasienId: String(data.pasienId || ""),
            lastMessage: String(data.lastMessage || ""),
            lastMessageAt: toDateSafe(data.lastMessageAt),
            unreadCountDokter: Number(data.unreadCountDokter || 0),
          };
        });

        setSessions(mapped);
        setError("");
        setLoading(false);

        const pasienIds = Array.from(
          new Set(mapped.map((item) => item.pasienId).filter((id) => id.trim().length > 0)),
        );

        if (pasienIds.length === 0) {
          setPatientMetaMap({});
          return;
        }

        const resolvedMetaEntries = await Promise.all(
          pasienIds.map(async (pasienId) => {
            try {
              const pasienSnap = await getDoc(doc(firestore, "pasien_profiles", pasienId));
              if (!pasienSnap.exists()) {
                return [
                  pasienId,
                  { name: "Pasien tidak ditemukan", mrn: "-" } satisfies PatientMeta,
                ] as const;
              }

              const data = pasienSnap.data() as Record<string, unknown>;
              return [
                pasienId,
                {
                  name: String(data.namaLengkap || data.fullName || "Pasien"),
                  mrn: String(data.noRekamMedis || data.mrn || "-"),
                } satisfies PatientMeta,
              ] as const;
            } catch {
              return [
                pasienId,
                { name: "Pasien tidak tersedia", mrn: "-" } satisfies PatientMeta,
              ] as const;
            }
          }),
        );

        setPatientMetaMap(Object.fromEntries(resolvedMetaEntries));
      },
      (snapshotError: unknown) => {
        const code =
          typeof snapshotError === "object" &&
          snapshotError !== null &&
          "code" in snapshotError
            ? String((snapshotError as { code?: string }).code || "")
            : "";

        if (code === "permission-denied") {
          setError(userMessages.doctorChats.permissionDenied);
        } else if (code === "unauthenticated") {
          setError(userMessages.doctorChats.authMismatch);
        } else {
          setError(userMessages.doctorChats.loadError);
        }

        console.error("[DoctorChats] failed to load sessions", {
          code: code || "unknown",
          doctor_uid: session.uid,
        });

        setSessions([]);
        setLoading(false);
      },
    );

    return () => unsubscribe();
  }, [session?.uid]);

  const sortedSessions = useMemo(() => {
    return [...sessions].sort((a, b) => {
      const aMs = a.lastMessageAt?.getTime() || 0;
      const bMs = b.lastMessageAt?.getTime() || 0;
      return bMs - aMs;
    });
  }, [sessions]);

  return (
    <DoctorLayout>
      <div className="p-8 space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Chat Pasien</h1>
          <p className="text-gray-600 mt-1">{userMessages.doctorChats.subtitle}</p>
        </div>

        <Card className="border-blue-200 bg-blue-50">
          <CardContent className="pt-6 text-sm text-blue-900">
            {userMessages.doctorChats.infoBanner}
          </CardContent>
        </Card>

        {loading && (
          <Card>
            <CardContent className="pt-6 text-gray-600 text-center">Memuat daftar chat...</CardContent>
          </Card>
        )}

        {!loading && error && (
          <Card className="border-red-200">
            <CardContent className="pt-6 text-center text-red-700">
              <AlertCircle className="w-8 h-8 mx-auto mb-2" />
              <p>{error}</p>
              <Button className="mt-4" variant="outline" onClick={() => window.location.reload()}>
                Coba Lagi
              </Button>
            </CardContent>
          </Card>
        )}

        {!loading && !error && (
          <Card>
            <CardHeader>
              <CardTitle>Inbox Percakapan</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {sortedSessions.length === 0 && (
                <div className="py-10 text-center text-gray-500">
                  <MessageCircle className="w-10 h-10 mx-auto mb-3 text-gray-400" />
                  <p>Belum ada sesi chat pasien.</p>
                </div>
              )}

              {sortedSessions.map((sessionItem) => {
                const patientMeta = patientMetaMap[sessionItem.pasienId] || {
                  name: "Pasien",
                  mrn: "-",
                };
                return (
                  <button
                    key={sessionItem.id}
                    type="button"
                    onClick={() => navigate(`/doctor/chat/${sessionItem.pasienId}`)}
                    className="w-full rounded-xl border border-slate-200 bg-white p-4 text-left transition hover:border-blue-300 hover:shadow-sm"
                  >
                    <div className="flex items-start justify-between gap-4">
                      <div className="min-w-0">
                        <div className="flex items-center gap-2">
                          <UserRound className="w-4 h-4 text-slate-500" />
                          <p className="font-semibold text-slate-900 truncate">{patientMeta.name}</p>
                          {sessionItem.unreadCountDokter > 0 && (
                            <Badge className="bg-red-100 text-red-700 border border-red-200">
                              {sessionItem.unreadCountDokter} belum dibaca
                            </Badge>
                          )}
                        </div>
                        <p className="mt-1 text-xs text-slate-500">MRN: {patientMeta.mrn}</p>
                        <p className="mt-2 text-sm text-slate-700 truncate">
                          {sessionItem.lastMessage.trim().length > 0
                            ? sessionItem.lastMessage
                            : "Belum ada pesan"}
                        </p>
                      </div>
                      <div className="flex items-center gap-1 text-xs text-slate-500 shrink-0">
                        <Clock3 className="w-3 h-3" />
                        <span>{formatLastMessageAt(sessionItem.lastMessageAt)}</span>
                      </div>
                    </div>
                  </button>
                );
              })}
            </CardContent>
          </Card>
        )}
      </div>
    </DoctorLayout>
  );
}

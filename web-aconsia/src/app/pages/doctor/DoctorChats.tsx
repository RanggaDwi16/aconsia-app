import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useNavigate } from "react-router";
import {
  collection,
  doc,
  getDoc,
  onSnapshot,
  query,
  where,
  type Timestamp,
} from "firebase/firestore";
import { AlertCircle, Clock3, MessageCircle, UserRound } from "lucide-react";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Badge } from "../../components/ui/badge";
import { Button } from "../../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import {
  getDesktopSession,
  resolveDesktopSession,
} from "../../../core/auth/session";
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

type DoctorChatLoadErrorCode =
  | "permission-denied"
  | "unauthenticated"
  | "auth-mismatch"
  | "failed-precondition"
  | "unavailable"
  | "unknown";

function toDateSafe(input: unknown): Date | undefined {
  if (!input) return undefined;
  if (typeof input === "object" && input !== null && "toDate" in input) {
    return (input as Timestamp).toDate();
  }
  return undefined;
}

function parseFirestoreErrorCode(error: unknown): string {
  if (
    typeof error === "object" &&
    error !== null &&
    "code" in error &&
    typeof (error as { code?: unknown }).code === "string"
  ) {
    return String((error as { code?: string }).code || "");
  }
  return "";
}

function mapChatLoadError(code: string): {
  normalizedCode: DoctorChatLoadErrorCode;
  message: string;
} {
  if (code === "permission-denied") {
    return {
      normalizedCode: "permission-denied",
      message: userMessages.doctorChats.permissionDenied,
    };
  }

  if (
    code === "unauthenticated" ||
    code === "auth/invalid-user-token" ||
    code === "auth/user-token-expired"
  ) {
    return {
      normalizedCode: "unauthenticated",
      message: userMessages.doctorChats.authMismatch,
    };
  }

  if (code === "failed-precondition") {
    return {
      normalizedCode: "failed-precondition",
      message:
        "Konfigurasi query chat belum siap (index/aturan). Silakan deploy index terbaru lalu coba lagi.",
    };
  }

  if (code === "unavailable") {
    return {
      normalizedCode: "unavailable",
      message: "Layanan chat sementara tidak tersedia. Silakan coba lagi.",
    };
  }

  return {
    normalizedCode: "unknown",
    message: userMessages.doctorChats.loadError,
  };
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
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [errorCode, setErrorCode] = useState<DoctorChatLoadErrorCode | null>(
    null,
  );
  const [sessions, setSessions] = useState<ChatSessionListItem[]>([]);
  const [patientMetaMap, setPatientMetaMap] = useState<Record<string, PatientMeta>>({});
  const [reloadToken, setReloadToken] = useState(0);
  const unsubscribeRef = useRef<(() => void) | null>(null);

  const reloadSessions = useCallback(() => {
    unsubscribeRef.current?.();
    unsubscribeRef.current = null;
    setLoading(true);
    setError("");
    setErrorCode(null);
    setReloadToken((prev) => prev + 1);
  }, []);

  useEffect(() => {
    let disposed = false;
    unsubscribeRef.current?.();
    unsubscribeRef.current = null;

    const bootstrap = async () => {
      setLoading(true);
      setError("");
      setErrorCode(null);

      await resolveDesktopSession();
      const session = getDesktopSession();

      if (!session?.uid) {
        if (disposed) return;
        setError("Sesi login dokter tidak ditemukan.");
        setErrorCode("unauthenticated");
        setLoading(false);
        return;
      }

      const firebaseUid = firebaseAuth.currentUser?.uid;
      if (!firebaseUid || firebaseUid !== session.uid) {
        if (disposed) return;
        setError(userMessages.doctorChats.authMismatch);
        setErrorCode("auth-mismatch");
        setLoading(false);
        return;
      }

      const sessionsQuery = query(
        collection(firestore, "chat_sessions"),
        where("dokterId", "==", session.uid),
      );

      unsubscribeRef.current = onSnapshot(
        sessionsQuery,
        async (snapshot) => {
          if (disposed) return;

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
          setErrorCode(null);
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

          if (disposed) return;
          setPatientMetaMap(Object.fromEntries(resolvedMetaEntries));
        },
        (snapshotError: unknown) => {
          if (disposed) return;
          const code = parseFirestoreErrorCode(snapshotError);
          const mappedError = mapChatLoadError(code);

          setError(mappedError.message);
          setErrorCode(mappedError.normalizedCode);
          setSessions([]);
          setLoading(false);

          console.error("[DoctorChats] failed to load sessions", {
            code: code || "unknown",
            doctorUid: session.uid,
            firebaseUid: firebaseAuth.currentUser?.uid || null,
            queryMode: "safe_where_only",
            timestamp: new Date().toISOString(),
          });
        },
      );
    };

    void bootstrap();

    return () => {
      disposed = true;
      unsubscribeRef.current?.();
      unsubscribeRef.current = null;
    };
  }, [reloadToken]);

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
              {errorCode === "failed-precondition" && (
                <p className="text-xs text-red-600 mt-2">
                  Pastikan index Firestore untuk `chat_sessions` sudah ter-deploy.
                </p>
              )}
              <Button className="mt-4" variant="outline" onClick={reloadSessions}>
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

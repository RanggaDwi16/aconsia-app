import { useEffect, useMemo, useRef, useState } from "react";
import { useNavigate, useParams } from "react-router";
import {
  addDoc,
  collection,
  doc,
  getDoc,
  getDocs,
  increment,
  limit,
  onSnapshot,
  orderBy,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
  writeBatch,
  type Timestamp,
} from "firebase/firestore";
import { ArrowLeft, Clock3, Send, UserRound } from "lucide-react";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Badge } from "../../components/ui/badge";
import { firestore } from "../../../core/firebase/client";
import { getDesktopSession } from "../../../core/auth/session";

type ChatMessage = {
  id: string;
  senderId: string;
  senderRole: "dokter" | "pasien";
  message: string;
  createdAt?: Date;
  isRead: boolean;
};

type PatientSummary = {
  id: string;
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

function formatTime(date?: Date): string {
  if (!date) return "--:--";
  return date.toLocaleTimeString("id-ID", { hour: "2-digit", minute: "2-digit" });
}

export function DoctorChatRoom() {
  const navigate = useNavigate();
  const { pasienId = "" } = useParams();
  const session = getDesktopSession();
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const [patient, setPatient] = useState<PatientSummary | null>(null);
  const [chatSessionId, setChatSessionId] = useState("");
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputMessage, setInputMessage] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [sending, setSending] = useState(false);

  const doctorUid = session?.uid || "";

  const headerSubtitle = useMemo(() => {
    if (!patient) return "Memuat data pasien...";
    const mrn = patient.mrn.trim().length > 0 ? patient.mrn : "-";
    return `MRN: ${mrn}`;
  }, [patient]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  useEffect(() => {
    const init = async () => {
      if (!doctorUid) {
        setError("Sesi dokter tidak ditemukan. Silakan login ulang.");
        setLoading(false);
        return;
      }

      if (!pasienId) {
        setError("Pasien tidak valid.");
        setLoading(false);
        return;
      }

      try {
        const patientRef = doc(firestore, "pasien_profiles", pasienId);
        const patientSnap = await getDoc(patientRef);
        if (!patientSnap.exists()) {
          setError("Profil pasien tidak ditemukan.");
          setLoading(false);
          return;
        }

        const patientData = patientSnap.data() as Record<string, unknown>;
        setPatient({
          id: pasienId,
          name: String(patientData.namaLengkap || patientData.fullName || "Pasien"),
          mrn: String(patientData.noRekamMedis || patientData.mrn || "-"),
        });

        const sessionQuery = query(
          collection(firestore, "chat_sessions"),
          where("pasienId", "==", pasienId),
          where("dokterId", "==", doctorUid),
          limit(1),
        );
        const sessionSnap = await getDocs(sessionQuery);

        let resolvedSessionId = "";
        if (!sessionSnap.empty) {
          resolvedSessionId = sessionSnap.docs[0].id;
        } else {
          const created = await addDoc(collection(firestore, "chat_sessions"), {
            pasienId,
            dokterId: doctorUid,
            unreadCountPasien: 0,
            unreadCountDokter: 0,
            createdAt: serverTimestamp(),
            updatedAt: serverTimestamp(),
            lastMessage: "",
            lastMessageAt: null,
          });
          resolvedSessionId = created.id;
        }

        setChatSessionId(resolvedSessionId);
        setError("");
      } catch (err) {
        console.error("[DoctorChatRoom] init error", err);
        setError("Gagal menyiapkan ruang chat dokter.");
      } finally {
        setLoading(false);
      }
    };

    void init();
  }, [doctorUid, pasienId]);

  useEffect(() => {
    if (!chatSessionId || !doctorUid) return undefined;

    const nestedQuery = query(
      collection(firestore, "chat_sessions", chatSessionId, "messages"),
      orderBy("createdAt", "asc"),
      limit(200),
    );

    const unsubscribe = onSnapshot(nestedQuery, async (snap) => {
      const mapped = snap.docs.map((docSnap) => {
        const data = docSnap.data() as Record<string, unknown>;
        return {
          id: docSnap.id,
          senderId: String(data.senderId || ""),
          senderRole: (data.senderRole === "pasien" ? "pasien" : "dokter") as
            | "dokter"
            | "pasien",
          message: String(data.message || ""),
          createdAt: toDateSafe(data.createdAt),
          isRead: Boolean(data.isRead ?? false),
        } satisfies ChatMessage;
      });

      setMessages(mapped);

      const unreadIncoming = snap.docs.filter((docSnap) => {
        const data = docSnap.data();
        return data.senderId !== doctorUid && data.isRead == false;
      });

      if (unreadIncoming.length > 0) {
        const batch = writeBatch(firestore);
        for (const item of unreadIncoming) {
          batch.update(item.ref, {
            isRead: true,
            readAt: serverTimestamp(),
          });
        }
        batch.update(doc(firestore, "chat_sessions", chatSessionId), {
          unreadCountDokter: 0,
          updatedAt: serverTimestamp(),
        });
        await batch.commit();
      } else {
        await updateDoc(doc(firestore, "chat_sessions", chatSessionId), {
          unreadCountDokter: 0,
          updatedAt: serverTimestamp(),
        });
      }
    });

    return () => unsubscribe();
  }, [chatSessionId, doctorUid]);

  const sendMessage = async () => {
    const text = inputMessage.trim();
    if (!text || !chatSessionId || !doctorUid || sending) return;

    setSending(true);
    try {
      const msgRef = doc(collection(firestore, "chat_sessions", chatSessionId, "messages"));
      await setDoc(msgRef, {
        id: msgRef.id,
        sessionId: chatSessionId,
        senderId: doctorUid,
        senderRole: "dokter",
        message: text,
        isRead: false,
        readAt: null,
        createdAt: serverTimestamp(),
      });

      await updateDoc(doc(firestore, "chat_sessions", chatSessionId), {
        lastMessage: text,
        lastMessageAt: serverTimestamp(),
        unreadCountPasien: increment(1),
        updatedAt: serverTimestamp(),
      });

      setInputMessage("");
    } catch (err) {
      console.error("[DoctorChatRoom] send message failed", err);
      setError("Gagal mengirim pesan. Coba lagi.");
    } finally {
      setSending(false);
    }
  };

  return (
    <DoctorLayout>
      <div className="p-8 space-y-4">
        <div className="flex items-center justify-between">
          <Button variant="outline" onClick={() => navigate("/doctor/chats")} className="gap-2">
            <ArrowLeft className="w-4 h-4" />
            Kembali ke Chat
          </Button>
          <Badge className="bg-blue-50 text-blue-700 border border-blue-200">
            Chat-only
          </Badge>
        </div>

        <Card className="border-blue-100">
          <CardHeader>
            <CardTitle>{patient?.name || "Chat dengan Pasien"}</CardTitle>
            <p className="text-sm text-gray-600">{headerSubtitle}</p>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-blue-900 bg-blue-50 border border-blue-100 rounded-lg p-3">
              Catatan: Komunikasi ini adalah chat langsung dokter-pasien. Tidak ada telepon atau video call di fase ini.
            </p>
          </CardContent>
        </Card>

        <Card className="min-h-[520px] flex flex-col">
          <CardContent className="flex-1 p-4 bg-slate-50 rounded-t-xl overflow-y-auto space-y-3">
            {loading && <p className="text-sm text-gray-600">Menyiapkan room chat...</p>}
            {!loading && error && <p className="text-sm text-red-600">{error}</p>}

            {!loading && !error && messages.length === 0 && (
              <p className="text-sm text-gray-600">Belum ada pesan. Mulai percakapan dengan pasien.</p>
            )}

            {messages.map((message) => {
              const isMine = message.senderRole === "dokter";
              return (
                <div
                  key={message.id}
                  className={`flex ${isMine ? "justify-end" : "justify-start"}`}
                >
                  <div
                    className={`max-w-[80%] rounded-2xl px-4 py-3 ${
                      isMine
                        ? "bg-blue-600 text-white"
                        : "bg-white text-slate-900 border border-slate-200"
                    }`}
                  >
                    <p className="text-sm leading-relaxed whitespace-pre-wrap">{message.message}</p>
                    <div
                      className={`mt-2 flex items-center gap-1 text-xs ${
                        isMine ? "text-blue-100" : "text-slate-500"
                      }`}
                    >
                      <Clock3 className="w-3 h-3" />
                      <span>{formatTime(message.createdAt)}</span>
                    </div>
                  </div>
                </div>
              );
            })}
            <div ref={messagesEndRef} />
          </CardContent>

          <div className="border-t border-slate-200 p-4 bg-white rounded-b-xl">
            <div className="flex gap-2">
              <Input
                value={inputMessage}
                onChange={(e) => setInputMessage(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && !e.shiftKey) {
                    e.preventDefault();
                    void sendMessage();
                  }
                }}
                disabled={!chatSessionId || sending || !!error}
                placeholder="Ketik balasan untuk pasien..."
                className="h-11"
              />
              <Button
                onClick={() => void sendMessage()}
                disabled={!inputMessage.trim() || sending || !chatSessionId || !!error}
                className="h-11 px-4 bg-blue-600 hover:bg-blue-700"
              >
                <Send className="w-4 h-4 mr-2" />
                Kirim
              </Button>
            </div>
            <div className="mt-2 flex items-center gap-2 text-xs text-slate-500">
              <UserRound className="w-3 h-3" />
              <span>Pesan akan langsung diterima pasien terkait.</span>
            </div>
          </div>
        </Card>
      </div>
    </DoctorLayout>
  );
}

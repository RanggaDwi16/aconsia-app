import { collection, getDocs, query, where } from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

export type MonitoringQuiz = {
  section: string;
  score: number;
  attempts: number;
};

export type MonitoringPatient = {
  id: string;
  name: string;
  noRM: string;
  anesthesiaType: string;
  approvedDate: string;
  overallProgress: number;
  currentSection: string;
  timeSpent: number;
  quizScores: MonitoringQuiz[];
  aiChatStats: {
    totalQuestions: number;
    topicsAsked: string[];
  };
  status: "not-started" | "in-progress" | "completed";
  redFlags: string[];
  comprehensionScore: number;
};

type SessionAgg = {
  totalSeconds: number;
  lastSection: number;
  completedCount: number;
  totalCount: number;
};

type QuizAgg = {
  items: MonitoringQuiz[];
  avgScore: number;
};

function normalizeDate(value: unknown): string {
  if (!value || typeof value !== "object") return "-";
  const maybeTimestamp = value as { toDate?: () => Date };
  if (typeof maybeTimestamp.toDate !== "function") return "-";
  return maybeTimestamp.toDate().toLocaleString("id-ID", {
    day: "2-digit",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function deriveStatus(patientStatus: string, progress: number): "not-started" | "in-progress" | "completed" {
  const s = patientStatus.toLowerCase();
  if (s === "completed" || s === "ready") return "completed";
  if (progress <= 0 && (s === "pending" || s === "approved")) return "not-started";
  return "in-progress";
}

function toNumber(value: unknown): number {
  const num = Number(value);
  return Number.isFinite(num) ? num : 0;
}

export async function getDoctorMonitoringPatients(doctorUid: string): Promise<MonitoringPatient[]> {
  const pasienQuery = query(
    collection(firestore, "pasien_profiles"),
    where("assignedDokterId", "==", doctorUid),
  );
  const readingQuery = query(
    collection(firestore, "reading_sessions"),
    where("dokterId", "==", doctorUid),
  );
  const quizQuery = query(
    collection(firestore, "quiz_results"),
    where("dokterId", "==", doctorUid),
  );

  const [pasienSnap, readingSnap, quizSnap] = await Promise.all([
    getDocs(pasienQuery),
    getDocs(readingQuery),
    getDocs(quizQuery),
  ]);

  const sessionMap = new Map<string, SessionAgg>();
  for (const docSnap of readingSnap.docs) {
    const data = docSnap.data() as Record<string, unknown>;
    const pasienId = String(data.pasienId || "");
    if (!pasienId) continue;

    const prev = sessionMap.get(pasienId) || {
      totalSeconds: 0,
      lastSection: 0,
      completedCount: 0,
      totalCount: 0,
    };

    prev.totalSeconds += toNumber(data.durationSeconds || data.duration || 0);
    prev.lastSection = Math.max(prev.lastSection, toNumber(data.section || data.sectionNumber || 0));
    prev.completedCount = Math.max(prev.completedCount, toNumber(data.completedCount || data.materialsCompleted || 0));
    prev.totalCount = Math.max(prev.totalCount, toNumber(data.totalCount || data.totalMaterials || 0));
    sessionMap.set(pasienId, prev);
  }

  const quizMap = new Map<string, QuizAgg>();
  for (const docSnap of quizSnap.docs) {
    const data = docSnap.data() as Record<string, unknown>;
    const pasienId = String(data.pasienId || "");
    if (!pasienId) continue;

    const sectionIndex = toNumber(data.section || data.sectionNumber || 0);
    const score = toNumber(data.score || data.finalScore || data.comprehensionScore || 0);
    const attempts = Math.max(1, toNumber(data.attempts || 1));

    const prev = quizMap.get(pasienId) || { items: [], avgScore: 0 };
    prev.items.push({
      section: sectionIndex > 0 ? `Section ${sectionIndex}` : "Section ?",
      score,
      attempts,
    });
    quizMap.set(pasienId, prev);
  }

  for (const [pasienId, agg] of quizMap.entries()) {
    if (agg.items.length === 0) continue;
    agg.avgScore = Math.round(
      agg.items.reduce((sum, item) => sum + item.score, 0) / agg.items.length,
    );
    quizMap.set(pasienId, agg);
  }

  return pasienSnap.docs.map((docSnap) => {
    const data = docSnap.data() as Record<string, unknown>;
    const patientStatus = String(data.status || "pending");
    const comprehensionScore = toNumber(data.comprehensionScore || 0);
    const sessionAgg = sessionMap.get(docSnap.id);
    const quizAgg = quizMap.get(docSnap.id);

    const materialsCompleted = toNumber(data.materialsCompleted || sessionAgg?.completedCount || 0);
    const totalMaterials = Math.max(
      1,
      toNumber(data.totalMaterials || sessionAgg?.totalCount || 10),
    );
    const progressFromMaterials = Math.round((materialsCompleted / totalMaterials) * 100);
    const fallbackProgress = patientStatus === "pending" ? 0 : Math.min(95, Math.max(20, comprehensionScore));
    const overallProgress = Math.max(
      0,
      Math.min(100, progressFromMaterials > 0 ? progressFromMaterials : fallbackProgress),
    );
    const status = deriveStatus(patientStatus, overallProgress);

    const redFlags: string[] = [];
    if (status === "not-started" && patientStatus !== "pending") {
      redFlags.push("Belum memulai edukasi setelah approval.");
    }
    if (quizAgg && quizAgg.items.some((item) => item.attempts >= 3 && item.score < 80)) {
      redFlags.push("Ada section quiz dengan percobaan berulang dan skor rendah.");
    }
    if (comprehensionScore > 0 && comprehensionScore < 60) {
      redFlags.push("Tingkat pemahaman pasien masih di bawah 60%.");
    }

    return {
      id: docSnap.id,
      name: String(data.namaLengkap || data.fullName || "Pasien"),
      noRM: String(data.noRekamMedis || data.mrn || "-"),
      anesthesiaType: String(data.jenisAnestesi || data.anesthesiaType || "-"),
      approvedDate: normalizeDate(data.approvalDate || data.updatedAt),
      overallProgress,
      currentSection:
        sessionAgg && sessionAgg.lastSection > 0
          ? `Section ${sessionAgg.lastSection}`
          : status === "completed"
            ? "Selesai"
            : "Belum Mulai",
      timeSpent: Math.round((sessionAgg?.totalSeconds || 0) / 60),
      quizScores: quizAgg?.items || [],
      aiChatStats: {
        totalQuestions: toNumber(data.aiQuestionsCount || 0),
        topicsAsked: Array.isArray(data.aiTopics) ? data.aiTopics.map(String) : [],
      },
      status,
      redFlags,
      comprehensionScore,
    };
  });
}

import { collection, getDocs, limit, query, where } from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";
import { collectPasienIdentifiers, toMillisValue } from "./patientDataNormalizer";

function clampScore(value: unknown): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) return 0;
  return Math.round(Math.max(0, Math.min(100, parsed)));
}

export function resolveComprehensionScoreFromProfile(
  data: Record<string, unknown>,
): number {
  const candidates = [
    data.comprehensionScore,
    data.lastQuizScore,
    data.overallScore,
    data.finalScore,
    data.score,
  ];

  for (const candidate of candidates) {
    const score = clampScore(candidate);
    if (score > 0) return score;
  }

  return 0;
}

export function resolveQuizScoreValue(data: Record<string, unknown>): number {
  const candidates = [
    data.overallScore,
    data.finalScore,
    data.score,
    data.comprehensionScore,
    data.lastQuizScore,
  ];

  let fallbackScore = 0;
  for (const candidate of candidates) {
    const score = clampScore(candidate);
    if (score > 0) return score;
    fallbackScore = score;
  }

  return fallbackScore;
}

export function toMillis(value: unknown): number {
  return toMillisValue(value);
}

function resolveQuizCompletedAt(data: Record<string, unknown>): number {
  const candidates = [data.completedAt, data.updatedAt, data.createdAt];
  let latest = 0;
  for (const candidate of candidates) {
    latest = Math.max(latest, toMillis(candidate));
  }
  return latest;
}

export function resolvePasienIdentifiers(
  docId: string,
  data?: Record<string, unknown>,
): string[] {
  return collectPasienIdentifiers(docId, data);
}

export async function getLatestQuizScoreForDoctor(params: {
  candidateIds: string[];
  doctorUid: string;
  rowLimit?: number;
}): Promise<number | null> {
  const { candidateIds, doctorUid, rowLimit = 50 } = params;
  if (candidateIds.length === 0 || !doctorUid.trim()) return null;

  let bestScore = 0;
  let bestCompletedAt = 0;
  let found = false;

  for (const candidateId of candidateIds) {
    const quizSnapshot = await getDocs(
      query(
        collection(firestore, "quiz_results"),
        where("pasienId", "==", candidateId),
        where("dokterId", "==", doctorUid),
        limit(rowLimit),
      ),
    );

    for (const docSnap of quizSnapshot.docs) {
      const data = docSnap.data() as Record<string, unknown>;
      const completedAt = resolveQuizCompletedAt(data);
      const score = resolveQuizScoreValue(data);
      found = true;

      if (completedAt >= bestCompletedAt) {
        bestCompletedAt = completedAt;
        bestScore = score;
      }
    }
  }

  return found ? bestScore : null;
}

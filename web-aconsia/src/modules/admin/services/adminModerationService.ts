import { httpsCallable } from "firebase/functions";
import { firebaseFunctions } from "../../../core/firebase/client";

export type UserLifecycleStatus = "active" | "suspended";
export type ContentLifecycleStatus = "draft" | "published";

const setUserLifecycleStatusCallable = httpsCallable(
  firebaseFunctions,
  "setUserLifecycleStatus",
);

const setKontenPublishStatusCallable = httpsCallable(
  firebaseFunctions,
  "setKontenPublishStatus",
);

export async function setUserLifecycleStatus(params: {
  userId: string;
  targetStatus: UserLifecycleStatus;
  reason?: string;
}) {
  await setUserLifecycleStatusCallable({
    userId: params.userId,
    targetStatus: params.targetStatus,
    reason: params.reason || null,
  });
}

export async function setKontenPublishStatus(params: {
  kontenId: string;
  targetStatus: ContentLifecycleStatus;
  reason?: string;
}) {
  await setKontenPublishStatusCallable({
    kontenId: params.kontenId,
    targetStatus: params.targetStatus,
    reason: params.reason || null,
  });
}

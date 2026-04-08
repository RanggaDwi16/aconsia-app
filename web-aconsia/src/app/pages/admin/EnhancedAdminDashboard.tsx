import { useState, useEffect, useCallback, type Dispatch, type SetStateAction } from "react";
import { useNavigate, useSearchParams } from "react-router";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Input } from "../../components/ui/input";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "../../components/ui/alert-dialog";
import {
  Users,
  Stethoscope,
  TrendingUp,
  FileCheck,
  Activity,
  Clock,
  CheckCircle,
  AlertCircle,
  FileText,
  LogOut,
} from "lucide-react";
import {
  getAdminDashboardPatientsPaginated,
  getAdminDoctorPerformance,
  type AdminPatientData,
  type AdminPatientsFilter,
} from "../../../modules/admin/services/adminDashboardService";
import {
  type AdminModerationContent,
  type AdminModerationContentFilter,
  type AdminModerationUser,
  type AdminModerationUserFilter,
  getAdminModerationContentsPaginated,
  getAdminModerationUsersPaginated,
} from "../../../modules/admin/services/adminModerationDataService";
import {
  setKontenPublishStatus,
  type ModerationCallableErrorCode,
  ModerationActionError,
  setUserLifecycleStatus,
} from "../../../modules/admin/services/adminModerationService";
import { getDesktopSession } from "../../../core/auth/session";
import { signOutDesktop } from "../../../core/auth/service";
import { writeAuditLog } from "../../../modules/admin/services/auditWriterService";
import { finishNavigationMetric } from "../../perf/navigationMetrics";
import { userMessages } from "../../copy/userMessages";
import { getFirebaseInitErrorMessage, isFirebaseClientReady } from "../../../core/firebase/client";
import { type DocumentData, type QueryDocumentSnapshot } from "firebase/firestore";

interface DoctorData {
  id: string;
  fullName: string;
  patientsCount: number;
  avgComprehension: number;
}

type PendingModerationAction =
  | {
      kind: "user";
      user: AdminModerationUser;
      targetStatus: "active" | "suspended";
    }
  | {
      kind: "content";
      content: AdminModerationContent;
      targetStatus: "draft" | "published";
    };

export function EnhancedAdminDashboard() {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const [patients, setPatients] = useState<AdminPatientData[]>([]);
  const [doctors, setDoctors] = useState<DoctorData[]>([]);
  const [moderationUsers, setModerationUsers] = useState<AdminModerationUser[]>([]);
  const [moderationContents, setModerationContents] = useState<AdminModerationContent[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState("");
  const [actionLoadingKey, setActionLoadingKey] = useState<string | null>(null);
  const [moderationMessage, setModerationMessage] = useState<string>("");
  const [moderationError, setModerationError] = useState<string>("");
  const [moderationErrorHint, setModerationErrorHint] = useState<string>("");
  const [moderationErrorCode, setModerationErrorCode] = useState<ModerationCallableErrorCode | null>(null);
  const [adminName, setAdminName] = useState("Admin");
  const [pendingModerationAction, setPendingModerationAction] = useState<PendingModerationAction | null>(null);
  const [isConfirmingAction, setIsConfirmingAction] = useState(false);
  const [patientsHasNext, setPatientsHasNext] = useState(false);
  const [moderationUsersHasNext, setModerationUsersHasNext] = useState(false);
  const [moderationContentsHasNext, setModerationContentsHasNext] = useState(false);
  const [patientsCursorStack, setPatientsCursorStack] = useState<Array<QueryDocumentSnapshot<DocumentData> | null>>([null]);
  const [moderationUsersCursorStack, setModerationUsersCursorStack] = useState<Array<QueryDocumentSnapshot<DocumentData> | null>>([null]);
  const [moderationContentsCursorStack, setModerationContentsCursorStack] = useState<Array<QueryDocumentSnapshot<DocumentData> | null>>([null]);

  const parsePage = (value: string | null): number => {
    const parsed = Number(value || "1");
    return Number.isFinite(parsed) && parsed > 0 ? Math.floor(parsed) : 1;
  };

  const [patientSearch, setPatientSearch] = useState(searchParams.get("p_search") || "");
  const [patientStatusFilter, setPatientStatusFilter] = useState<AdminPatientsFilter["status"]>(
    (searchParams.get("p_status") as AdminPatientsFilter["status"]) || "all",
  );
  const [patientAnesthesiaFilter, setPatientAnesthesiaFilter] = useState<string>(
    searchParams.get("p_anesthesia") || "all",
  );
  const [patientsPage, setPatientsPage] = useState<number>(parsePage(searchParams.get("p_page")));

  const [moderationUserSearch, setModerationUserSearch] = useState(searchParams.get("u_search") || "");
  const [moderationUserRoleFilter, setModerationUserRoleFilter] =
    useState<AdminModerationUserFilter["role"]>(
      (searchParams.get("u_role") as AdminModerationUserFilter["role"]) || "all",
    );
  const [moderationUserStatusFilter, setModerationUserStatusFilter] =
    useState<AdminModerationUserFilter["status"]>(
      (searchParams.get("u_status") as AdminModerationUserFilter["status"]) || "all",
    );
  const [moderationUsersPage, setModerationUsersPage] =
    useState<number>(parsePage(searchParams.get("u_page")));

  const [moderationContentSearch, setModerationContentSearch] =
    useState(searchParams.get("c_search") || "");
  const [moderationContentStatusFilter, setModerationContentStatusFilter] =
    useState<AdminModerationContentFilter["status"]>(
      (searchParams.get("c_status") as AdminModerationContentFilter["status"]) || "all",
    );
  const [moderationContentsPage, setModerationContentsPage] =
    useState<number>(parsePage(searchParams.get("c_page")));

  // Resolve current admin session
  useEffect(() => {
    finishNavigationMetric("login_to_admin_dashboard", { route: "/admin" });
    const session = getDesktopSession();
    if (!session || session.role !== "admin") {
      navigate("/login");
      return;
    }

    if (!isFirebaseClientReady()) {
      const initMessage = getFirebaseInitErrorMessage();
      setLoadError(userMessages.admin.moderationPreflight);
      setModerationErrorHint(
        initMessage ? userMessages.admin.hintTryAgain : userMessages.admin.hintReloginAdmin,
      );
      setIsLoading(false);
      return;
    }

    setAdminName(session.displayName || session.email || "Admin");
  }, [navigate]);

  const mapModerationHint = (code: ModerationCallableErrorCode): string => {
    if (code === "unauthenticated") return userMessages.admin.hintReloginAdmin;
    if (code === "permission-denied") return userMessages.admin.hintCheckAdminRole;
    if (code === "not-found") return userMessages.admin.hintCheckContentExists;
    if (code === "invalid-argument") return userMessages.admin.hintTryAgain;
    return userMessages.admin.hintTryAgain;
  };

  const applyNextCursor = (
    page: number,
    nextCursor: QueryDocumentSnapshot<DocumentData> | null,
    hasNext: boolean,
    setCursorStack: Dispatch<SetStateAction<Array<QueryDocumentSnapshot<DocumentData> | null>>>,
  ) => {
    setCursorStack((prev) => {
      const next = prev.slice(0, page);
      if (hasNext && nextCursor) {
        next[page] = nextCursor;
      }
      return next.length === 0 ? [null] : next;
    });
  };

  const loadPatientsPanel = useCallback(async () => {
    let cursor = patientsCursorStack[patientsPage - 1] || null;
    if (patientsPage > 1 && !cursor) {
      const rebuiltStack: Array<QueryDocumentSnapshot<DocumentData> | null> = [null];
      let rebuildCursor: QueryDocumentSnapshot<DocumentData> | null = null;
      for (let page = 1; page < patientsPage; page += 1) {
        const stepResult = await getAdminDashboardPatientsPaginated({
          pageSize: 20,
          cursor: rebuildCursor,
          search: patientSearch,
          filters: {
            status: patientStatusFilter || "all",
            anesthesiaType: patientAnesthesiaFilter || "all",
          },
        });
        if (!stepResult.hasNext || !stepResult.nextCursor) {
          setPatientsPage(1);
          setPatientsCursorStack([null]);
          return;
        }
        rebuildCursor = stepResult.nextCursor;
        rebuiltStack[page] = rebuildCursor;
      }
      setPatientsCursorStack(rebuiltStack);
      cursor = rebuiltStack[patientsPage - 1] || null;
    }
    const result = await getAdminDashboardPatientsPaginated({
      pageSize: 20,
      cursor,
      search: patientSearch,
      filters: {
        status: patientStatusFilter || "all",
        anesthesiaType: patientAnesthesiaFilter || "all",
      },
    });
    setPatients(result.items);
    setPatientsHasNext(result.hasNext);
    applyNextCursor(patientsPage, result.nextCursor, result.hasNext, setPatientsCursorStack);
    const doctorPerformance = await getAdminDoctorPerformance(result.items);
    setDoctors(doctorPerformance);
  }, [
    patientAnesthesiaFilter,
    patientSearch,
    patientStatusFilter,
    patientsCursorStack,
    patientsPage,
  ]);

  const loadModerationUsersPanel = useCallback(async () => {
    let cursor = moderationUsersCursorStack[moderationUsersPage - 1] || null;
    if (moderationUsersPage > 1 && !cursor) {
      const rebuiltStack: Array<QueryDocumentSnapshot<DocumentData> | null> = [null];
      let rebuildCursor: QueryDocumentSnapshot<DocumentData> | null = null;
      for (let page = 1; page < moderationUsersPage; page += 1) {
        const stepResult = await getAdminModerationUsersPaginated({
          pageSize: 20,
          cursor: rebuildCursor,
          search: moderationUserSearch,
          filters: {
            role: moderationUserRoleFilter || "all",
            status: moderationUserStatusFilter || "all",
          },
        });
        if (!stepResult.hasNext || !stepResult.nextCursor) {
          setModerationUsersPage(1);
          setModerationUsersCursorStack([null]);
          return;
        }
        rebuildCursor = stepResult.nextCursor;
        rebuiltStack[page] = rebuildCursor;
      }
      setModerationUsersCursorStack(rebuiltStack);
      cursor = rebuiltStack[moderationUsersPage - 1] || null;
    }
    const result = await getAdminModerationUsersPaginated({
      pageSize: 20,
      cursor,
      search: moderationUserSearch,
      filters: {
        role: moderationUserRoleFilter || "all",
        status: moderationUserStatusFilter || "all",
      },
    });
    setModerationUsers(result.items);
    setModerationUsersHasNext(result.hasNext);
    applyNextCursor(
      moderationUsersPage,
      result.nextCursor,
      result.hasNext,
      setModerationUsersCursorStack,
    );
  }, [
    moderationUserRoleFilter,
    moderationUserSearch,
    moderationUserStatusFilter,
    moderationUsersCursorStack,
    moderationUsersPage,
  ]);

  const loadModerationContentsPanel = useCallback(async () => {
    let cursor = moderationContentsCursorStack[moderationContentsPage - 1] || null;
    if (moderationContentsPage > 1 && !cursor) {
      const rebuiltStack: Array<QueryDocumentSnapshot<DocumentData> | null> = [null];
      let rebuildCursor: QueryDocumentSnapshot<DocumentData> | null = null;
      for (let page = 1; page < moderationContentsPage; page += 1) {
        const stepResult = await getAdminModerationContentsPaginated({
          pageSize: 20,
          cursor: rebuildCursor,
          search: moderationContentSearch,
          filters: {
            status: moderationContentStatusFilter || "all",
          },
        });
        if (!stepResult.hasNext || !stepResult.nextCursor) {
          setModerationContentsPage(1);
          setModerationContentsCursorStack([null]);
          return;
        }
        rebuildCursor = stepResult.nextCursor;
        rebuiltStack[page] = rebuildCursor;
      }
      setModerationContentsCursorStack(rebuiltStack);
      cursor = rebuiltStack[moderationContentsPage - 1] || null;
    }
    const result = await getAdminModerationContentsPaginated({
      pageSize: 20,
      cursor,
      search: moderationContentSearch,
      filters: {
        status: moderationContentStatusFilter || "all",
      },
    });
    setModerationContents(result.items);
    setModerationContentsHasNext(result.hasNext);
    applyNextCursor(
      moderationContentsPage,
      result.nextCursor,
      result.hasNext,
      setModerationContentsCursorStack,
    );
  }, [
    moderationContentSearch,
    moderationContentStatusFilter,
    moderationContentsCursorStack,
    moderationContentsPage,
  ]);

  const loadData = useCallback(async () => {
    try {
      await Promise.all([
        loadPatientsPanel(),
        loadModerationUsersPanel(),
        loadModerationContentsPanel(),
      ]);
      setLoadError("");
      setIsLoading(false);
    } catch (error) {
      console.error("[AdminDashboard] Firestore paginated load failed", error);
      setLoadError(userMessages.admin.dashboardLoadError);
      setPatients([]);
      setDoctors([]);
      setModerationUsers([]);
      setModerationContents([]);
      setIsLoading(false);
    }
  }, [loadModerationContentsPanel, loadModerationUsersPanel, loadPatientsPanel]);

  useEffect(() => {
    void loadData();
  }, [loadData]);

  useEffect(() => {
    const interval = setInterval(() => {
      void loadData();
    }, 5000);
    return () => clearInterval(interval);
  }, [loadData]);

  useEffect(() => {
    const nextParams = new URLSearchParams();
    const setOrDelete = (key: string, value: string, defaultValue: string) => {
      if (value === defaultValue) {
        nextParams.delete(key);
      } else {
        nextParams.set(key, value);
      }
    };

    setOrDelete("p_search", patientSearch.trim(), "");
    setOrDelete("p_status", patientStatusFilter || "all", "all");
    setOrDelete("p_anesthesia", patientAnesthesiaFilter || "all", "all");
    setOrDelete("p_page", String(patientsPage), "1");
    setOrDelete("u_search", moderationUserSearch.trim(), "");
    setOrDelete("u_role", moderationUserRoleFilter || "all", "all");
    setOrDelete("u_status", moderationUserStatusFilter || "all", "all");
    setOrDelete("u_page", String(moderationUsersPage), "1");
    setOrDelete("c_search", moderationContentSearch.trim(), "");
    setOrDelete("c_status", moderationContentStatusFilter || "all", "all");
    setOrDelete("c_page", String(moderationContentsPage), "1");
    setSearchParams(nextParams, { replace: true });
  }, [
    moderationContentSearch,
    moderationContentStatusFilter,
    moderationContentsPage,
    moderationUserRoleFilter,
    moderationUserSearch,
    moderationUserStatusFilter,
    moderationUsersPage,
    patientAnesthesiaFilter,
    patientSearch,
    patientStatusFilter,
    patientsPage,
    setSearchParams,
  ]);

  const resetPatientsQuery = () => {
    setPatientsPage(1);
    setPatientsCursorStack([null]);
  };

  const resetModerationUsersQuery = () => {
    setModerationUsersPage(1);
    setModerationUsersCursorStack([null]);
  };

  const resetModerationContentsQuery = () => {
    setModerationContentsPage(1);
    setModerationContentsCursorStack([null]);
  };

  const handleUserLifecycleAction = (user: AdminModerationUser) => {
    const targetStatus = user.status === "suspended" ? "active" : "suspended";
    setPendingModerationAction({
      kind: "user",
      user,
      targetStatus,
    });
  };

  const handleContentPublishAction = (content: AdminModerationContent) => {
    const targetStatus = content.status === "published" ? "draft" : "published";
    setPendingModerationAction({
      kind: "content",
      content,
      targetStatus,
    });
  };

  const executePendingModerationAction = async () => {
    if (!pendingModerationAction || isConfirmingAction) return;
    const action = pendingModerationAction;

    setIsConfirmingAction(true);
    setPendingModerationAction(null);
    setModerationMessage("");
    setModerationError("");
    setModerationErrorHint("");
    setModerationErrorCode(null);

    try {
      if (action.kind === "user") {
        setActionLoadingKey(`user-${action.user.id}`);
        await setUserLifecycleStatus({
          userId: action.user.id,
          targetStatus: action.targetStatus,
          reason:
            action.targetStatus === "suspended"
              ? "Suspended by admin desktop moderation"
              : "Reactivated by admin desktop moderation",
        });
        setModerationMessage(
          `Status user ${action.user.displayName} berhasil diubah ke ${action.targetStatus}.`,
        );
        await loadModerationUsersPanel();
        return;
      }

      setActionLoadingKey(`content-${action.content.id}`);
      await setKontenPublishStatus({
        kontenId: action.content.id,
        targetStatus: action.targetStatus,
        reason:
          action.targetStatus === "published"
            ? "Published by admin desktop moderation"
            : "Unpublished by admin desktop moderation",
      });
      setModerationMessage(
        `Status konten ${action.content.title} berhasil diubah ke ${action.targetStatus}.`,
      );
      await loadModerationContentsPanel();
    } catch (error) {
      if (error instanceof ModerationActionError) {
        if (action.kind === "user") {
          console.error("[AdminDashboard] User moderation action failed", {
            code: error.code,
            debugMessage: error.debugMessage,
            userId: action.user.id,
            targetStatus: action.targetStatus,
          });
        } else {
          console.error("[AdminDashboard] Content moderation action failed", {
            code: error.code,
            debugMessage: error.debugMessage,
            contentId: action.content.id,
            contentTitle: action.content.title,
            targetStatus: action.targetStatus,
          });
        }
        setModerationError(error.userMessage);
        setModerationErrorHint(mapModerationHint(error.code));
        setModerationErrorCode(error.code);
      } else {
        if (action.kind === "user") {
          console.error("[AdminDashboard] User moderation action failed", {
            error,
            userId: action.user.id,
            targetStatus: action.targetStatus,
          });
          setModerationError(userMessages.admin.lifecycleUnknown);
        } else {
          console.error("[AdminDashboard] Content moderation action failed", {
            error,
            contentId: action.content.id,
            contentTitle: action.content.title,
            targetStatus: action.targetStatus,
          });
          setModerationError(userMessages.admin.publishUnknown);
        }
        setModerationErrorHint(userMessages.admin.hintTryAgain);
        setModerationErrorCode("unknown");
      }
    } finally {
      setActionLoadingKey(null);
      setIsConfirmingAction(false);
    }
  };

  const handleLogout = async () => {
    const session = getDesktopSession();
    if (session) {
      await writeAuditLog({
        actorUid: session.uid,
        actorRole: "admin",
        actorName: session.displayName || session.email,
        actionType: "LOGOUT",
        entityType: "auth",
        message: "Admin signed out from desktop portal",
      });
    }

    await signOutDesktop();
    navigate("/login");
  };

  // Calculate statistics
  const stats = {
    totalPatients: patients.length,
    pending: patients.filter((p) => p.status === "pending").length,
    inProgress: patients.filter((p) => p.status === "in_progress").length,
    ready: patients.filter((p) => p.status === "ready").length,
    completed: patients.filter((p) => p.status === "completed").length,
    avgComprehension: Math.round(
      patients.reduce((sum, p) => sum + p.comprehensionScore, 0) / patients.length || 0
    ),
  };

  // Anesthesia type distribution
  const anesthesiaDistribution = {
    general: patients.filter((p) => p.anesthesiaType === "General Anesthesia").length,
    spinal: patients.filter((p) => p.anesthesiaType === "Spinal Anesthesia").length,
    epidural: patients.filter((p) => p.anesthesiaType === "Epidural Anesthesia").length,
    regional: patients.filter((p) => p.anesthesiaType === "Regional Anesthesia").length,
    local: patients.filter((p) => p.anesthesiaType === "Local Anesthesia + Sedation").length,
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Memuat data...</p>
        </div>
      </div>
    );
  }

  if (loadError) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center p-6">
        <Card className="max-w-lg w-full border-red-200">
          <CardHeader>
            <CardTitle className="text-red-700">Gagal Memuat Dashboard</CardTitle>
            <CardDescription>{loadError}</CardDescription>
            {moderationErrorHint ? (
              <CardDescription className="text-red-700">{moderationErrorHint}</CardDescription>
            ) : null}
          </CardHeader>
          <CardContent className="flex gap-3">
            <Button variant="outline" onClick={() => navigate("/login")}>Kembali ke Login</Button>
            <Button onClick={() => window.location.reload()}>Coba Lagi</Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50">
      {/* Auto-sync indicator */}
      <div className="bg-purple-600 text-white text-xs py-1 text-center">
        <Activity className="w-3 h-3 inline mr-1 animate-pulse" />
        Dashboard ter-sinkronisasi dengan semua pasien & dokter secara real-time
      </div>

      {/* Header */}
      <div className="bg-white border-b shadow-sm">
        <div className="container mx-auto px-6 py-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">
                Dashboard Administrator
              </h1>
              <p className="text-gray-600 mt-1">
                Sistem Edukasi Informed Consent Anestesi · {adminName}
              </p>
            </div>
            <div className="flex items-center gap-3">
              <Badge className="bg-purple-100 text-purple-800 text-sm px-4 py-2">
                <Activity className="w-4 h-4 mr-2" />
                Auto-sync setiap 5 detik
              </Badge>
              <Button
                variant="outline"
                onClick={() => navigate('/admin/audit-trail')}
                className="border-purple-300 text-purple-600 hover:bg-purple-50"
              >
                <FileText className="w-4 h-4 mr-2" />
                Audit Trail
              </Button>
              <Button
                variant="outline"
                onClick={() => navigate('/admin/reports')}
                className="border-blue-300 text-blue-600 hover:bg-blue-50"
              >
                <FileText className="w-4 h-4 mr-2" />
                Lihat Laporan
              </Button>
              <Button
                variant="outline"
                onClick={handleLogout}
                className="border-red-300 text-red-600 hover:bg-red-50"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Logout
              </Button>
            </div>
          </div>

          {/* Statistics Cards */}
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mt-6">
            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Total Pasien</p>
                    <p className="text-2xl font-bold text-blue-600">
                      {stats.totalPatients}
                    </p>
                  </div>
                  <Users className="w-8 h-8 text-blue-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-yellow-200 bg-yellow-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Pending</p>
                    <p className="text-2xl font-bold text-yellow-600">
                      {stats.pending}
                    </p>
                  </div>
                  <Clock className="w-8 h-8 text-yellow-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">In Progress</p>
                    <p className="text-2xl font-bold text-blue-600">
                      {stats.inProgress}
                    </p>
                  </div>
                  <Activity className="w-8 h-8 text-blue-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-green-200 bg-green-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Ready</p>
                    <p className="text-2xl font-bold text-green-600">
                      {stats.ready}
                    </p>
                  </div>
                  <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-gray-200 bg-gray-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Completed</p>
                    <p className="text-2xl font-bold text-gray-600">
                      {stats.completed}
                    </p>
                  </div>
                  <FileCheck className="w-8 h-8 text-gray-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-purple-200 bg-purple-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Avg Score</p>
                    <p className="text-2xl font-bold text-purple-600">
                      {stats.avgComprehension}%
                    </p>
                  </div>
                  <TrendingUp className="w-8 h-8 text-purple-600" />
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-6 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Doctor Performance */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Stethoscope className="w-5 h-5" />
                Performa Dokter
              </CardTitle>
              <CardDescription>Berdasarkan rata-rata pemahaman pasien</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {doctors.map((doctor) => (
                <div key={doctor.id} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium text-sm">{doctor.fullName}</p>
                      <p className="text-xs text-gray-500">
                        {doctor.patientsCount} pasien
                      </p>
                    </div>
                    <Badge
                      className={
                        doctor.avgComprehension >= 80
                          ? "bg-green-100 text-green-800"
                          : doctor.avgComprehension >= 60
                          ? "bg-yellow-100 text-yellow-800"
                          : "bg-red-100 text-red-800"
                      }
                    >
                      {doctor.avgComprehension}%
                    </Badge>
                  </div>
                  <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all ${
                        doctor.avgComprehension >= 80
                          ? "bg-green-600"
                          : doctor.avgComprehension >= 60
                          ? "bg-yellow-600"
                          : "bg-red-600"
                      }`}
                      style={{ width: `${doctor.avgComprehension}%` }}
                    />
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Anesthesia Distribution */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <FileText className="w-5 h-5" />
                Distribusi Jenis Anestesi
              </CardTitle>
              <CardDescription>Total {stats.totalPatients} pasien</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {[
                { label: "General Anesthesia", count: anesthesiaDistribution.general, color: "blue" },
                { label: "Spinal Anesthesia", count: anesthesiaDistribution.spinal, color: "green" },
                { label: "Epidural Anesthesia", count: anesthesiaDistribution.epidural, color: "purple" },
                { label: "Regional Anesthesia", count: anesthesiaDistribution.regional, color: "orange" },
                { label: "Local + Sedation", count: anesthesiaDistribution.local, color: "pink" },
              ].map((item) => {
                const percentage = stats.totalPatients > 0
                  ? Math.round((item.count / stats.totalPatients) * 100)
                  : 0;

                return (
                  <div key={item.label} className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium">{item.label}</span>
                      <span className="text-sm text-gray-600">
                        {item.count} ({percentage}%)
                      </span>
                    </div>
                    <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                      <div
                        className={`h-full bg-${item.color}-600 rounded-full transition-all`}
                        style={{ width: `${percentage}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </CardContent>
          </Card>

          {/* Recent Patients */}
          <Card className="lg:col-span-2">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Users className="w-5 h-5" />
                Status Pasien Real-Time
              </CardTitle>
              <CardDescription>
                Update otomatis setiap 5 detik · Halaman {patientsPage} · 20 item per halaman
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="mb-4 grid grid-cols-1 gap-3 md:grid-cols-3">
                <Input
                  value={patientSearch}
                  onChange={(event) => {
                    setPatientSearch(event.target.value);
                    resetPatientsQuery();
                  }}
                  placeholder="Cari nama atau MRN pasien"
                />
                <select
                  value={patientStatusFilter || "all"}
                  onChange={(event) => {
                    setPatientStatusFilter(event.target.value as AdminPatientsFilter["status"]);
                    resetPatientsQuery();
                  }}
                  className="h-10 rounded-md border border-slate-200 bg-white px-3 text-sm"
                >
                  <option value="all">Semua status</option>
                  <option value="pending">Pending</option>
                  <option value="approved">Approved</option>
                  <option value="in_progress">In Progress</option>
                  <option value="ready">Ready</option>
                  <option value="completed">Completed</option>
                </select>
                <select
                  value={patientAnesthesiaFilter || "all"}
                  onChange={(event) => {
                    setPatientAnesthesiaFilter(event.target.value);
                    resetPatientsQuery();
                  }}
                  className="h-10 rounded-md border border-slate-200 bg-white px-3 text-sm"
                >
                  <option value="all">Semua anestesi</option>
                  <option value="General Anesthesia">General Anesthesia</option>
                  <option value="Spinal Anesthesia">Spinal Anesthesia</option>
                  <option value="Epidural Anesthesia">Epidural Anesthesia</option>
                  <option value="Regional Anesthesia">Regional Anesthesia</option>
                  <option value="Local Anesthesia + Sedation">Local + Sedation</option>
                </select>
              </div>
              {patients.length === 0 ? (
                <div className="text-center py-12">
                  <AlertCircle className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600">Tidak ada pasien sesuai filter saat ini</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {patients.map((patient) => (
                    <div
                      key={patient.id}
                      className="p-4 border rounded-lg hover:shadow-md transition-shadow"
                    >
                      <div className="flex items-start justify-between">
                        <div className="flex-1">
                          <div className="flex items-center gap-3 mb-2">
                            <h4 className="font-bold text-gray-900">
                              {patient.fullName}
                            </h4>
                            <Badge
                              variant="secondary"
                              className={
                                patient.status === "pending"
                                  ? "bg-yellow-100 text-yellow-800"
                                  : patient.status === "ready"
                                  ? "bg-green-100 text-green-800"
                                  : patient.status === "in_progress"
                                  ? "bg-blue-100 text-blue-800"
                                  : "bg-gray-100 text-gray-800"
                              }
                            >
                              {patient.status === "pending"
                                ? "Pending"
                                : patient.status === "ready"
                                ? "Ready"
                                : patient.status === "in_progress"
                                ? "In Progress"
                                : patient.status === "approved"
                                ? "Approved"
                                : "Completed"}
                            </Badge>
                          </div>

                          <div className="grid grid-cols-4 gap-4 text-sm">
                            <div>
                              <p className="text-xs text-gray-500">MRN</p>
                              <p className="font-semibold">{patient.mrn}</p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500">Operasi</p>
                              <p className="font-semibold">{patient.surgeryType}</p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500">Anestesi</p>
                              <p className="font-semibold text-blue-600">
                                {patient.anesthesiaType || (
                                  <span className="text-gray-400 italic">Belum dipilih</span>
                                )}
                              </p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500">Pemahaman</p>
                              <Badge
                                className={
                                  patient.comprehensionScore >= 80
                                    ? "bg-green-100 text-green-800"
                                    : patient.comprehensionScore >= 60
                                    ? "bg-yellow-100 text-yellow-800"
                                    : patient.comprehensionScore > 0
                                    ? "bg-red-100 text-red-800"
                                    : "bg-gray-100 text-gray-800"
                                }
                              >
                                {patient.comprehensionScore}%
                              </Badge>
                            </div>
                          </div>

                          {patient.scheduledConsentDate && (
                            <div className="mt-2 text-xs text-green-700 bg-green-50 p-2 rounded">
                              📅 Jadwal TTD:{" "}
                              {new Date(patient.scheduledConsentDate).toLocaleString("id-ID", {
                                day: "numeric",
                                month: "long",
                                year: "numeric",
                                hour: "2-digit",
                                minute: "2-digit",
                              })}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
              <div className="mt-4 flex items-center justify-between border-t pt-4">
                <p className="text-xs text-slate-500">
                  Menampilkan {patients.length} pasien pada halaman ini
                </p>
                <div className="flex items-center gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={patientsPage <= 1}
                    onClick={() => {
                      setPatientsPage((prev) => Math.max(1, prev - 1));
                    }}
                  >
                    Prev
                  </Button>
                  <span className="text-sm font-medium text-slate-700">Halaman {patientsPage}</span>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={!patientsHasNext}
                    onClick={() => {
                      if (!patientsHasNext) return;
                      setPatientsPage((prev) => prev + 1);
                    }}
                  >
                    Next
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Moderation Control Center */}
          <Card className="lg:col-span-2 border-purple-200">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <FileText className="w-5 h-5 text-purple-600" />
                Moderasi Admin
              </CardTitle>
              <CardDescription>
                Kontrol status user dan publish status konten. Semua aksi tercatat di audit trail immutable.
              </CardDescription>
            </CardHeader>
            <CardContent>
              {moderationMessage && (
                <div className="mb-4 rounded-md border border-green-200 bg-green-50 px-3 py-2 text-sm text-green-700">
                  {moderationMessage}
                </div>
              )}
              {moderationError && (
                <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
                  <p>{moderationError}</p>
                  {moderationErrorHint ? (
                    <p className="mt-1 text-xs text-red-700/90">{moderationErrorHint}</p>
                  ) : null}
                  {moderationErrorCode ? (
                    <p className="mt-1 text-xs text-red-700/80">
                      Kode: <span className="font-mono">{moderationErrorCode}</span>
                    </p>
                  ) : null}
                </div>
              )}

              <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
                <div>
                  <h4 className="font-semibold text-gray-900 mb-3">User Lifecycle</h4>
                  <div className="mb-3 grid grid-cols-1 gap-2 md:grid-cols-3">
                    <Input
                      value={moderationUserSearch}
                      onChange={(event) => {
                        setModerationUserSearch(event.target.value);
                        resetModerationUsersQuery();
                      }}
                      placeholder="Cari nama/email user"
                    />
                    <select
                      value={moderationUserRoleFilter || "all"}
                      onChange={(event) => {
                        setModerationUserRoleFilter(event.target.value as AdminModerationUserFilter["role"]);
                        resetModerationUsersQuery();
                      }}
                      className="h-10 rounded-md border border-slate-200 bg-white px-3 text-sm"
                    >
                      <option value="all">Semua role</option>
                      <option value="admin">Admin</option>
                      <option value="doctor">Doctor</option>
                      <option value="patient">Patient</option>
                    </select>
                    <select
                      value={moderationUserStatusFilter || "all"}
                      onChange={(event) => {
                        setModerationUserStatusFilter(event.target.value as AdminModerationUserFilter["status"]);
                        resetModerationUsersQuery();
                      }}
                      className="h-10 rounded-md border border-slate-200 bg-white px-3 text-sm"
                    >
                      <option value="all">Semua status</option>
                      <option value="active">Active</option>
                      <option value="suspended">Suspended</option>
                    </select>
                  </div>
                  <div className="space-y-2">
                    {moderationUsers.length === 0 ? (
                      <p className="text-sm text-gray-500">Tidak ada user sesuai filter saat ini.</p>
                    ) : (
                      moderationUsers.map((user) => {
                        const isAdminUser = user.role === "admin";
                        return (
                          <div
                            key={user.id}
                            className="border rounded-lg p-3 flex items-center justify-between gap-3"
                          >
                            <div>
                              <p className="font-semibold text-sm text-gray-900">{user.displayName}</p>
                              <p className="text-xs text-gray-500">{user.email}</p>
                              <div className="flex gap-2 mt-1">
                                <Badge className="bg-slate-100 text-slate-700">{user.role}</Badge>
                                <Badge
                                  className={
                                    user.status === "active"
                                      ? "bg-green-100 text-green-700"
                                      : "bg-red-100 text-red-700"
                                  }
                                >
                                  {user.status}
                                </Badge>
                              </div>
                            </div>
                            <Button
                              size="sm"
                              variant="outline"
                              disabled={
                                isAdminUser ||
                                actionLoadingKey === `user-${user.id}`
                              }
                              onClick={() => {
                                void handleUserLifecycleAction(user);
                              }}
                            >
                              {actionLoadingKey === `user-${user.id}`
                                ? "Memproses..."
                                : user.status === "suspended"
                                ? "Activate"
                                : "Suspend"}
                            </Button>
                          </div>
                        );
                      })
                    )}
                  </div>
                  <div className="mt-3 flex items-center justify-between">
                    <p className="text-xs text-slate-500">
                      Halaman {moderationUsersPage} · {moderationUsers.length} user
                    </p>
                    <div className="flex items-center gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        disabled={moderationUsersPage <= 1}
                        onClick={() => {
                          setModerationUsersPage((prev) => Math.max(1, prev - 1));
                        }}
                      >
                        Prev
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        disabled={!moderationUsersHasNext}
                        onClick={() => {
                          if (!moderationUsersHasNext) return;
                          setModerationUsersPage((prev) => prev + 1);
                        }}
                      >
                        Next
                      </Button>
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="font-semibold text-gray-900 mb-3">Content Publish Control</h4>
                  <div className="mb-3 grid grid-cols-1 gap-2 md:grid-cols-2">
                    <Input
                      value={moderationContentSearch}
                      onChange={(event) => {
                        setModerationContentSearch(event.target.value);
                        resetModerationContentsQuery();
                      }}
                      placeholder="Cari judul konten / nama dokter"
                    />
                    <select
                      value={moderationContentStatusFilter || "all"}
                      onChange={(event) => {
                        setModerationContentStatusFilter(
                          event.target.value as AdminModerationContentFilter["status"],
                        );
                        resetModerationContentsQuery();
                      }}
                      className="h-10 rounded-md border border-slate-200 bg-white px-3 text-sm"
                    >
                      <option value="all">Semua status</option>
                      <option value="draft">Draft</option>
                      <option value="published">Published</option>
                    </select>
                  </div>
                  <div className="space-y-2">
                    {moderationContents.length === 0 ? (
                      <p className="text-sm text-gray-500">Tidak ada konten sesuai filter saat ini.</p>
                    ) : (
                      moderationContents.map((content) => (
                        <div
                          key={content.id}
                          className="border rounded-lg p-3 flex items-center justify-between gap-3"
                        >
                          <div>
                            <p className="font-semibold text-sm text-gray-900">{content.title}</p>
                            <p className="text-xs text-gray-500">Dokter: {content.doctorName}</p>
                            <Badge
                              className={
                                content.status === "published"
                                  ? "mt-1 bg-green-100 text-green-700"
                                  : "mt-1 bg-yellow-100 text-yellow-700"
                              }
                            >
                              {content.status}
                            </Badge>
                          </div>
                          <Button
                            size="sm"
                            variant="outline"
                            disabled={actionLoadingKey === `content-${content.id}`}
                            onClick={() => {
                              void handleContentPublishAction(content);
                            }}
                          >
                            {actionLoadingKey === `content-${content.id}`
                              ? "Memproses..."
                              : content.status === "published"
                              ? "Unpublish"
                              : "Publish"}
                          </Button>
                        </div>
                      ))
                    )}
                  </div>
                  <div className="mt-3 flex items-center justify-between">
                    <p className="text-xs text-slate-500">
                      Halaman {moderationContentsPage} · {moderationContents.length} konten
                    </p>
                    <div className="flex items-center gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        disabled={moderationContentsPage <= 1}
                        onClick={() => {
                          setModerationContentsPage((prev) => Math.max(1, prev - 1));
                        }}
                      >
                        Prev
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        disabled={!moderationContentsHasNext}
                        onClick={() => {
                          if (!moderationContentsHasNext) return;
                          setModerationContentsPage((prev) => prev + 1);
                        }}
                      >
                        Next
                      </Button>
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      <AlertDialog
        open={Boolean(pendingModerationAction)}
        onOpenChange={(open) => {
          if (!open && !isConfirmingAction) {
            setPendingModerationAction(null);
          }
        }}
      >
        <AlertDialogContent className="max-w-md rounded-2xl border-slate-200 p-0 overflow-hidden">
          <div className="bg-gradient-to-r from-slate-50 to-purple-50 px-6 py-4 border-b border-slate-100">
            <AlertDialogHeader className="text-left">
              <AlertDialogTitle className="text-slate-900">
                Konfirmasi Aksi Moderasi
              </AlertDialogTitle>
              <AlertDialogDescription className="text-slate-600">
                {pendingModerationAction?.kind === "user"
                  ? `Ubah status user "${pendingModerationAction.user.displayName}" menjadi ${pendingModerationAction.targetStatus}?`
                  : pendingModerationAction?.kind === "content"
                  ? `Ubah status konten "${pendingModerationAction.content.title}" menjadi ${pendingModerationAction.targetStatus}?`
                  : ""}
              </AlertDialogDescription>
            </AlertDialogHeader>
          </div>
          <div className="px-6 py-4">
            <p className="text-sm text-slate-500">
              Aksi ini akan langsung disimpan dan tercatat pada audit trail.
            </p>
          </div>
          <AlertDialogFooter className="px-6 pb-6">
            <AlertDialogCancel disabled={isConfirmingAction}>Batal</AlertDialogCancel>
            <AlertDialogAction
              disabled={isConfirmingAction}
              onClick={(event) => {
                event.preventDefault();
                void executePendingModerationAction();
              }}
              className="bg-slate-900 text-white hover:bg-slate-800"
            >
              {isConfirmingAction ? "Memproses..." : "Ya, Lanjutkan"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

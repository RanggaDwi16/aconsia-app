import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Input } from "../../components/ui/input";
import {
  ArrowLeft,
  Download,
  Filter,
  Shield,
  Eye,
  Activity,
  Users,
  FileText,
  Search,
  Calendar,
  BarChart3,
} from "lucide-react";
import { getAdminAuditLogs, type AdminAuditLog } from "../../../modules/admin/services/adminAuditService";
import { userMessages } from "../../copy/userMessages";

export function AuditTrailPage() {
  const navigate = useNavigate();
  const [logs, setLogs] = useState<AdminAuditLog[]>([]);
  const [filteredLogs, setFilteredLogs] = useState<AdminAuditLog[]>([]);
  const [filterRole, setFilterRole] = useState<string>("all");
  const [filterAction, setFilterAction] = useState<string>("all");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [summary, setSummary] = useState<any>(null);
  const [loadError, setLoadError] = useState("");

  useEffect(() => {
    void loadLogs();
    const interval = setInterval(() => {
      void loadLogs();
    }, 5000); // Refresh every 5 seconds
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    applyFilters();
  }, [logs, filterRole, filterAction, searchQuery]);

  const buildSummary = (allLogs: AdminAuditLog[]) => {
    const byRole: Record<string, number> = {};
    const byAction: Record<string, number> = {};

    allLogs.forEach((log) => {
      byRole[log.userRole] = (byRole[log.userRole] || 0) + 1;
      byAction[log.action] = (byAction[log.action] || 0) + 1;
    });

    return {
      totalLogs: allLogs.length,
      byRole,
      byAction,
      recentActivity: allLogs.slice(0, 10),
    };
  };

  const loadLogs = async () => {
    try {
      const firestoreLogs = await getAdminAuditLogs();
      const mappedLogs: AdminAuditLog[] = firestoreLogs.map((log) => ({ ...log }));
      setLogs(mappedLogs);
      setSummary(buildSummary(mappedLogs));
      setLoadError("");
      return;
    } catch (error) {
      console.error("[AuditTrailPage] Firestore load failed", error);
      setLoadError(userMessages.admin.auditLoadError);
      setLogs([]);
      setSummary(buildSummary([]));
    }
  };

  const applyFilters = () => {
    let filtered = [...logs];

    // Filter by role
    if (filterRole !== "all") {
      filtered = filtered.filter((log) => log.userRole === filterRole);
    }

    // Filter by action
    if (filterAction !== "all") {
      filtered = filtered.filter((log) => log.action === filterAction);
    }

    // Search
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(
        (log) =>
          log.userName.toLowerCase().includes(query) ||
          log.action.toLowerCase().includes(query) ||
          log.details.toLowerCase().includes(query)
      );
    }

    setFilteredLogs(filtered);
  };

  const handleExportJSON = () => {
    const json = JSON.stringify(filteredLogs, null, 2);
    const blob = new Blob([json], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `audit-trail-${new Date().toISOString().split("T")[0]}.json`;
    a.click();
  };

  const handleExportCSV = () => {
    if (filteredLogs.length === 0) return;

    const headers = [
      "Timestamp",
      "User ID",
      "User Role",
      "User Name",
      "Action",
      "Target",
      "Details",
      "Status",
      "IP Address",
      "Session ID",
    ];

    const rows = filteredLogs.map((log) => [
      new Date(log.timestamp).toLocaleString("id-ID"),
      log.userId,
      log.userRole,
      log.userName,
      log.action,
      log.target,
      log.details,
      log.status,
      log.ipAddress || "-",
      log.sessionId || "-",
    ]);

    const csv = [headers, ...rows]
      .map((row) => row.map((cell) => `"${cell}"`).join(","))
      .join("\n");

    const blob = new Blob([csv], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `audit-trail-${new Date().toISOString().split("T")[0]}.csv`;
    a.click();
  };

  const getRoleColor = (role: string) => {
    switch (role) {
      case "patient":
        return "bg-blue-100 text-blue-800 border-blue-200";
      case "doctor":
        return "bg-green-100 text-green-800 border-green-200";
      case "admin":
        return "bg-purple-100 text-purple-800 border-purple-200";
      default:
        return "bg-gray-100 text-gray-800 border-gray-200";
    }
  };

  const getStatusColor = (status: string) => {
    return status === "success"
      ? "bg-green-100 text-green-800 border-green-200"
      : "bg-red-100 text-red-800 border-red-200";
  };

  // Get unique actions for filter
  const uniqueActions = Array.from(new Set(logs.map((log) => log.action))).sort();

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Header */}
      <div className="bg-white border-b shadow-sm sticky top-0 z-10">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Button variant="ghost" onClick={() => navigate("/admin")} className="gap-2">
                <ArrowLeft className="w-4 h-4" />
                Kembali
              </Button>
              <div>
                <h1 className="text-2xl font-bold text-slate-900 flex items-center gap-2">
                  <Shield className="w-6 h-6 text-purple-600" />
                  Audit Trail
                </h1>
                <p className="text-sm text-slate-600">
                  Log aktivitas sistem untuk keamanan & kepatuhan hukum
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <Button variant="outline" onClick={handleExportCSV} className="gap-2">
                <Download className="w-4 h-4" />
                Export CSV
              </Button>
              <Button onClick={handleExportJSON} className="bg-purple-600 hover:bg-purple-700 gap-2">
                <Download className="w-4 h-4" />
                Export JSON
              </Button>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-6 py-8">
        {/* Summary Statistics */}
        {summary && (
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <Card className="border-purple-200 bg-purple-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-purple-700 font-semibold">Total Aktivitas</p>
                    <p className="text-3xl font-bold text-purple-600">{summary.totalLogs}</p>
                  </div>
                  <Activity className="w-10 h-10 text-purple-600 opacity-50" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-blue-700 font-semibold">Aktivitas Pasien</p>
                    <p className="text-3xl font-bold text-blue-600">{summary.byRole.patient || 0}</p>
                  </div>
                  <Users className="w-10 h-10 text-blue-600 opacity-50" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-green-200 bg-green-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-green-700 font-semibold">Aktivitas Dokter</p>
                    <p className="text-3xl font-bold text-green-600">{summary.byRole.doctor || 0}</p>
                  </div>
                  <FileText className="w-10 h-10 text-green-600 opacity-50" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-purple-200 bg-purple-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-purple-700 font-semibold">Aktivitas Admin</p>
                    <p className="text-3xl font-bold text-purple-600">{summary.byRole.admin || 0}</p>
                  </div>
                  <Shield className="w-10 h-10 text-purple-600 opacity-50" />
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Filters & Search */}
        {loadError && (
          <Card className="mb-6 border-red-200 bg-red-50">
            <CardHeader>
              <CardTitle className="text-red-700 text-base">Gagal Memuat Data Audit</CardTitle>
              <CardDescription className="text-red-700">{loadError}</CardDescription>
            </CardHeader>
          </Card>
        )}

        <Card className="mb-6">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Filter className="w-5 h-5" />
              Filter & Pencarian
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label className="block text-sm font-semibold text-slate-700 mb-2">Role</label>
                <select
                  value={filterRole}
                  onChange={(e) => setFilterRole(e.target.value)}
                  className="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                >
                  <option value="all">Semua Role</option>
                  <option value="patient">Patient</option>
                  <option value="doctor">Doctor</option>
                  <option value="admin">Admin</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-semibold text-slate-700 mb-2">Action</label>
                <select
                  value={filterAction}
                  onChange={(e) => setFilterAction(e.target.value)}
                  className="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                >
                  <option value="all">Semua Action</option>
                  {uniqueActions.map((action) => (
                    <option key={action} value={action}>
                      {action}
                    </option>
                  ))}
                </select>
              </div>

              <div className="md:col-span-2">
                <label className="block text-sm font-semibold text-slate-700 mb-2">Pencarian</label>
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <Input
                    type="text"
                    placeholder="Cari user, action, atau details..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="pl-10"
                  />
                </div>
              </div>
            </div>

            <div className="mt-4 flex items-center justify-between">
              <p className="text-sm text-slate-600">
                Menampilkan <span className="font-bold">{filteredLogs.length}</span> dari{" "}
                <span className="font-bold">{logs.length}</span> aktivitas
              </p>
              <Button
                variant="outline"
                size="sm"
                onClick={() => {
                  setFilterRole("all");
                  setFilterAction("all");
                  setSearchQuery("");
                }}
              >
                Reset Filter
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Audit Logs Table */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Eye className="w-5 h-5" />
              Log Aktivitas
            </CardTitle>
            <CardDescription>
              Log real-time dari semua aktivitas pengguna (update setiap 5 detik)
            </CardDescription>
          </CardHeader>
          <CardContent>
            {filteredLogs.length === 0 ? (
              <div className="text-center py-12">
                <Activity className="w-16 h-16 text-slate-300 mx-auto mb-4" />
                <p className="text-slate-600 font-semibold mb-2">Tidak ada aktivitas yang cocok</p>
                <p className="text-sm text-slate-500">Coba ubah filter untuk melihat data lain</p>
              </div>
            ) : (
              <div className="space-y-3">
                {filteredLogs.map((log) => (
                  <div
                    key={log.id}
                    className="border border-slate-200 rounded-lg p-4 hover:shadow-md transition-shadow bg-white"
                  >
                    <div className="flex items-start justify-between gap-4">
                      <div className="flex-1">
                        {/* Header Row */}
                        <div className="flex items-center gap-2 mb-2 flex-wrap">
                          <Badge className={`${getRoleColor(log.userRole)} font-semibold`}>
                            {log.userRole.toUpperCase()}
                          </Badge>
                          <Badge variant="outline" className="font-mono text-xs">
                            {log.action}
                          </Badge>
                          <Badge className={getStatusColor(log.status)}>
                            {log.status === "success" ? "✓ Success" : "✗ Failed"}
                          </Badge>
                          <span className="text-xs text-slate-500 ml-auto">
                            {new Date(log.timestamp).toLocaleString("id-ID", {
                              day: "numeric",
                              month: "short",
                              year: "numeric",
                              hour: "2-digit",
                              minute: "2-digit",
                              second: "2-digit",
                            })}
                          </span>
                        </div>

                        {/* Main Info */}
                        <div className="mb-2">
                          <p className="text-sm font-semibold text-slate-900">
                            {log.userName} → {log.target}
                          </p>
                          <p className="text-sm text-slate-700">{log.details}</p>
                        </div>

                        {/* Technical Details */}
                        <div className="flex items-center gap-4 text-xs text-slate-500">
                          <span className="font-mono">ID: {log.userId}</span>
                          {log.ipAddress && <span>IP: {log.ipAddress}</span>}
                          {log.sessionId && (
                            <span className="font-mono truncate max-w-[200px]">
                              Session: {log.sessionId}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Legal Notice */}
        <div className="mt-8 bg-yellow-50 border-2 border-yellow-200 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <Shield className="w-5 h-5 text-yellow-700 flex-shrink-0 mt-0.5" />
            <div className="text-sm text-yellow-900">
              <p className="font-bold mb-1">⚖️ Kepatuhan Hukum & Keamanan Data</p>
              <ul className="list-disc list-inside space-y-1 text-xs">
                <li>
                  Semua aktivitas pengguna <strong>terekam secara otomatis</strong> untuk keperluan audit &
                  keamanan
                </li>
                <li>
                  Log ini dapat digunakan sebagai <strong>bukti hukum</strong> jika terjadi sengketa
                </li>
                <li>
                  Data audit <strong>tidak dapat diubah atau dihapus</strong> oleh pengguna biasa
                </li>
                <li>
                  Hanya <strong>administrator sistem</strong> yang memiliki akses penuh ke audit trail
                </li>
                <li>
                  Export data hanya untuk keperluan <strong>compliance & investigasi</strong>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

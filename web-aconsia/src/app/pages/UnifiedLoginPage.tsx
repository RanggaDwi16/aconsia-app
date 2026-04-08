import { useEffect, useState } from "react";
import { useNavigate } from "react-router";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Label } from "../components/ui/label";
import { Tooltip, TooltipContent, TooltipTrigger } from "../components/ui/tooltip";
import {
  ArrowLeft,
  AlertCircle,
  Eye,
  EyeOff,
  Shield,
  Stethoscope,
  UserPlus,
} from "lucide-react";
import { BrandLogo } from "../components/BrandLogo";
import { DesktopAuthError, signInDesktop } from "../../core/auth/service";
import {
  getDesktopSession,
  resolveDesktopSession,
} from "../../core/auth/session";
import { writeAuditLog } from "../../modules/admin/services/auditWriterService";
import {
  buildFirebaseMissingEnvMessage,
  isFirebaseEnvReady,
} from "../../core/firebase/env";
import {
  prefetchAdminArea,
  prefetchAdminAreaOnIdle,
  prefetchDoctorArea,
  prefetchDoctorAreaOnIdle,
} from "../routes/prefetch";
import {
  finishNavigationMetric,
  startNavigationMetric,
} from "../perf/navigationMetrics";
import { userMessages } from "../copy/userMessages";

type LoginRole = "doctor" | "admin";
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function UnifiedLoginPage() {
  const navigate = useNavigate();
  const firebaseReady = isFirebaseEnvReady();
  const firebaseEnvMessage = buildFirebaseMissingEnvMessage();
  const [selectedRole, setSelectedRole] = useState<LoginRole | null>(null);
  const [identifier, setIdentifier] = useState(""); // NIK for patient, email for doctor/admin
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [fieldErrors, setFieldErrors] = useState<{ identifier: string; password: string }>({
    identifier: "",
    password: "",
  });
  const [isResolvingSession, setIsResolvingSession] = useState(true);

  useEffect(() => {
    finishNavigationMetric("landing_to_login", { route: "/login" });
  }, []);

  useEffect(() => {
    let active = true;

    const redirectByRole = (role: string) => {
      if (role === "admin") {
        navigate("/admin", { replace: true });
        return true;
      }

      if (role === "doctor") {
        navigate("/doctor", { replace: true });
        return true;
      }

      return false;
    };

    const checkExistingSession = async () => {
      const hydratedSession = await resolveDesktopSession();
      if (!active) return;

      if (hydratedSession) {
        redirectByRole(hydratedSession.role);
        return;
      }

      setIsResolvingSession(false);
    };

    void checkExistingSession();

    return () => {
      active = false;
    };
  }, [navigate]);

  if (isResolvingSession) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-sm text-slate-600 font-medium">Mengecek sesi login...</p>
        </div>
      </div>
    );
  }

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    const email = identifier.trim().toLowerCase();
    const nextFieldErrors = {
      identifier: !email
        ? "Email wajib diisi"
        : !EMAIL_REGEX.test(email)
          ? "Format email tidak valid"
          : "",
      password: !password.trim()
        ? "Password wajib diisi"
        : password.length < 6
          ? "Password minimal 6 karakter"
          : "",
    };
    setFieldErrors(nextFieldErrors);
    if (nextFieldErrors.identifier || nextFieldErrors.password) {
      setError("Mohon periksa kembali input login Anda.");
      return;
    }

    if (!firebaseReady) {
      setError(firebaseEnvMessage);
      return;
    }

    if (selectedRole === "doctor") {
      void prefetchDoctorArea();
      startNavigationMetric("login_to_doctor_dashboard");
      try {
        await signInDesktop({
          email,
          password,
          expectedRole: "doctor",
        });

        const session = getDesktopSession();
        if (session) {
          await writeAuditLog({
            actorUid: session.uid,
            actorRole: "doctor",
            actorName: session.displayName || session.email,
            actionType: "LOGIN",
            entityType: "auth",
            message: "Doctor signed in from desktop portal",
          });
        }

        navigate("/doctor");
      } catch (err) {
        if (err instanceof DesktopAuthError) {
          setError(err.message);
        } else {
          setError(userMessages.auth.loginDoctorFailed);
        }
      }
      return;
    }

    if (selectedRole === "admin") {
      void prefetchAdminArea();
      startNavigationMetric("login_to_admin_dashboard");
      try {
        await signInDesktop({
          email,
          password,
          expectedRole: "admin",
        });

        const session = getDesktopSession();
        if (session) {
          await writeAuditLog({
            actorUid: session.uid,
            actorRole: "admin",
            actorName: session.displayName || session.email,
            actionType: "LOGIN",
            entityType: "auth",
            message: "Admin signed in from desktop portal",
          });
        }

        navigate("/admin");
      } catch (err) {
        if (err instanceof DesktopAuthError) {
          setError(err.message);
        } else {
          setError(userMessages.auth.loginAdminFailed);
        }
      }
      return;
    }

    setError("Pilih role terlebih dahulu!");
  };

  // Reset form when role changes
  const handleRoleChange = (role: LoginRole) => {
    if (role === "doctor") {
      void prefetchDoctorArea();
      prefetchDoctorAreaOnIdle();
    }
    if (role === "admin") {
      void prefetchAdminArea();
      prefetchAdminAreaOnIdle();
    }

    setSelectedRole(role);
    setIdentifier("");
    setPassword("");
    setShowPassword(false);
    setFieldErrors({ identifier: "", password: "" });
    setError("");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50 flex flex-col">
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-md">
          {/* Back Button */}
          <button
            onClick={() => navigate("/")}
            className="flex items-center gap-2 text-slate-600 hover:text-slate-900 mb-8 transition-colors group"
          >
            <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform" />
            <span className="font-medium">Kembali</span>
          </button>

          {/* Logo & Title */}
          <div className="text-center mb-12">
            <BrandLogo wrapperClassName="inline-flex items-center justify-center w-24 h-24 bg-white rounded-full mb-6 shadow-md" imageClassName="w-16 h-16 object-contain" />
            <h1 className="text-4xl font-bold text-slate-900 mb-3 tracking-tight">
              {selectedRole === null && "Selamat Datang"}
              {selectedRole === "doctor" && "Login Dokter"}
              {selectedRole === "admin" && "Login Admin"}
            </h1>
            <p className="text-base text-slate-600 font-medium">
              {selectedRole === null && "Pilih role untuk melanjutkan"}
              {selectedRole !== null && "Sistem Informasi Informed Consent Anestesi"}
            </p>
          </div>

          {/* Role Selection (if not selected yet) */}
          {selectedRole === null ? (
            <div className="space-y-3">
              {/* Dokter Card */}
              <button
                onClick={() => handleRoleChange("doctor")}
                onMouseEnter={() => void prefetchDoctorArea()}
                onFocus={() => void prefetchDoctorArea()}
                className="w-full bg-white rounded-2xl p-5 shadow-sm hover:shadow-xl transition-all duration-300 border border-slate-100 hover:border-green-300 hover:-translate-y-1 group relative overflow-hidden"
              >
                <div className="absolute inset-0 bg-gradient-to-r from-green-50 to-emerald-50 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                
                <div className="relative flex items-center gap-4">
                  <div className="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                    <Stethoscope className="w-8 h-8 text-white" />
                  </div>
                  
                  <div className="flex-1 text-left">
                    <h3 className="text-xl font-bold text-slate-900 mb-1 group-hover:text-green-600 transition-colors">Dokter</h3>
                    <p className="text-sm text-slate-600">Login dengan Email</p>
                  </div>
                  
                  <div className="w-10 h-10 bg-slate-100 rounded-xl flex items-center justify-center group-hover:bg-green-100 transition-colors">
                    <ArrowLeft className="w-5 h-5 text-slate-400 rotate-180 group-hover:text-green-600 group-hover:translate-x-1 transition-all" />
                  </div>
                </div>
              </button>

              {/* Admin Card */}
              <button
                onClick={() => handleRoleChange("admin")}
                onMouseEnter={() => void prefetchAdminArea()}
                onFocus={() => void prefetchAdminArea()}
                className="w-full bg-white rounded-2xl p-5 shadow-sm hover:shadow-xl transition-all duration-300 border border-slate-100 hover:border-purple-300 hover:-translate-y-1 group relative overflow-hidden"
              >
                <div className="absolute inset-0 bg-gradient-to-r from-purple-50 to-pink-50 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                
                <div className="relative flex items-center gap-4">
                  <div className="w-16 h-16 bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                    <Shield className="w-8 h-8 text-white" />
                  </div>
                  
                  <div className="flex-1 text-left">
                    <h3 className="text-xl font-bold text-slate-900 mb-1 group-hover:text-purple-600 transition-colors">Admin</h3>
                    <p className="text-sm text-slate-600">Login dengan Email</p>
                  </div>
                  
                  <div className="w-10 h-10 bg-slate-100 rounded-xl flex items-center justify-center group-hover:bg-purple-100 transition-colors">
                    <ArrowLeft className="w-5 h-5 text-slate-400 rotate-180 group-hover:text-purple-600 group-hover:translate-x-1 transition-all" />
                  </div>
                </div>
              </button>

              {/* Access Information */}
              <div className="bg-gradient-to-r from-slate-50 to-slate-100 rounded-2xl p-6 mt-8 border border-slate-200">
                <div className="flex items-start gap-3 mb-4">
                  <div className="w-8 h-8 bg-slate-900 rounded-lg flex items-center justify-center flex-shrink-0">
                    <span className="text-white text-sm">🔐</span>
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-slate-900 mb-1">Informasi Akses</h4>
                    <p className="text-xs text-slate-600">Pilih role sesuai akun yang Anda miliki</p>
                  </div>
                </div>
                <div className="space-y-3">
                  <div className="bg-white rounded-xl p-3 border border-slate-200">
                    <div className="flex items-center gap-2 mb-1">
                      <div className="w-6 h-6 bg-green-100 rounded-lg flex items-center justify-center">
                        <Stethoscope className="w-4 h-4 text-green-600" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Dokter</span>
                    </div>
                    <p className="text-xs text-slate-700 pl-8">Login menggunakan email dan password akun dokter</p>
                    <div className="pl-8 mt-3">
                      <Button
                        type="button"
                        variant="outline"
                        onClick={() => navigate("/doctor/register")}
                        className="h-8 px-3 text-xs border-green-200 text-green-700 hover:bg-green-50 hover:text-green-800"
                      >
                        <UserPlus className="w-3.5 h-3.5 mr-1.5" />
                        Daftar Akun Dokter
                      </Button>
                    </div>
                  </div>
                  <div className="bg-white rounded-xl p-3 border border-slate-200">
                    <div className="flex items-center gap-2 mb-1">
                      <div className="w-6 h-6 bg-purple-100 rounded-lg flex items-center justify-center">
                        <Shield className="w-4 h-4 text-purple-600" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Admin</span>
                    </div>
                    <p className="text-xs text-slate-700 pl-8">Admin menggunakan akun internal yang sudah terdaftar</p>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            /* Login Form (when role selected) */
            <div className="bg-white rounded-2xl shadow-lg border border-slate-200 overflow-hidden">
              {/* Header */}
              <div
                className={`px-8 py-6 text-center ${
                  selectedRole === "doctor"
                    ? "bg-green-600"
                    : "bg-purple-600"
                }`}
              >
                <div className="inline-flex items-center justify-center w-16 h-16 bg-white rounded-full mb-3">
                  {selectedRole === "doctor" && <Stethoscope className="w-8 h-8 text-green-600" />}
                  {selectedRole === "admin" && <Shield className="w-8 h-8 text-purple-600" />}
                </div>
                <h2 className="text-xl font-bold text-white mb-1">
                  {selectedRole === "doctor" && "Login Dokter"}
                  {selectedRole === "admin" && "Login Admin"}
                </h2>
                <p className="text-sm text-white/80">
                  {selectedRole === "doctor" && "Masukkan Email dan Password"}
                  {selectedRole === "admin" && "Masukkan Email dan Password"}
                </p>
              </div>

              {/* Form */}
              <form onSubmit={handleLogin} className="p-8">
                <div className="space-y-6">
                  {/* Error Alert */}
                  {error && (
                    <div className="bg-red-50 border-2 border-red-200 rounded-lg p-4 flex items-start gap-3">
                      <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                      <div className="flex-1">
                        <p className="text-sm font-semibold text-red-900 mb-1">Login Gagal</p>
                        <p className="text-sm text-red-700">{error}</p>
                      </div>
                    </div>
                  )}

                  {!firebaseReady && (
                    <div className="bg-amber-50 border-2 border-amber-200 rounded-lg p-4 flex items-start gap-3">
                      <AlertCircle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
                      <div className="flex-1">
                        <p className="text-sm font-semibold text-amber-900 mb-1">
                          Layanan Belum Siap
                        </p>
                        <p className="text-sm text-amber-800">{firebaseEnvMessage}</p>
                      </div>
                    </div>
                  )}

                  {/* Identifier Field (NIK or Email) */}
                  <div>
                    <Label htmlFor="identifier" className="text-slate-700 font-semibold mb-2 block">
                      Email
                    </Label>
                    <Input
                      id="identifier"
                      type="email"
                      value={identifier}
                      onChange={(e) => {
                        const value = e.target.value.trimStart();
                        setIdentifier(value);
                        if (fieldErrors.identifier) {
                          setFieldErrors((prev) => ({ ...prev, identifier: "" }));
                        }
                      }}
                      onBlur={() => {
                        const email = identifier.trim().toLowerCase();
                        setFieldErrors((prev) => ({
                          ...prev,
                          identifier: !email
                            ? "Email wajib diisi"
                            : !EMAIL_REGEX.test(email)
                              ? "Format email tidak valid"
                              : "",
                        }));
                      }}
                      placeholder="Masukkan email Anda"
                      className={`h-12 text-base ${fieldErrors.identifier ? "border-red-500" : ""}`}
                      autoComplete="email"
                      autoCapitalize="none"
                      aria-invalid={Boolean(fieldErrors.identifier)}
                    />
                    {fieldErrors.identifier && (
                      <p className="text-sm text-red-600 mt-2">{fieldErrors.identifier}</p>
                    )}
                  </div>

                  {/* Password Field */}
                  <div>
                    <Label htmlFor="password" className="text-slate-700 font-semibold mb-2 block">
                      Password
                    </Label>
                    <div className="relative">
                      <Input
                        id="password"
                        type={showPassword ? "text" : "password"}
                        value={password}
                        onChange={(e) => {
                          const value = e.target.value.slice(0, 64);
                          setPassword(value);
                          if (fieldErrors.password) {
                            setFieldErrors((prev) => ({ ...prev, password: "" }));
                          }
                        }}
                        onBlur={() => {
                          setFieldErrors((prev) => ({
                            ...prev,
                            password: !password.trim()
                              ? "Password wajib diisi"
                              : password.length < 6
                                ? "Password minimal 6 karakter"
                                : "",
                          }));
                        }}
                        placeholder="Masukkan password"
                        className={`h-12 text-base pr-12 ${fieldErrors.password ? "border-red-500" : ""}`}
                        autoComplete="current-password"
                        maxLength={64}
                        aria-invalid={Boolean(fieldErrors.password)}
                      />
                      <Tooltip>
                        <TooltipTrigger asChild>
                          <button
                            type="button"
                            onClick={() => setShowPassword((prev) => !prev)}
                            className="absolute right-3 top-1/2 -translate-y-1/2 rounded-md p-1 text-slate-500 hover:bg-slate-100 hover:text-slate-700 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-300"
                            aria-label={showPassword ? "Sembunyikan password" : "Tampilkan password"}
                            aria-pressed={showPassword}
                          >
                            {showPassword ? (
                              <EyeOff className="w-5 h-5" />
                            ) : (
                              <Eye className="w-5 h-5" />
                            )}
                          </button>
                        </TooltipTrigger>
                        <TooltipContent side="top" sideOffset={8}>
                          {showPassword ? "Sembunyikan password" : "Tampilkan password"}
                        </TooltipContent>
                      </Tooltip>
                    </div>
                    {fieldErrors.password && (
                      <p className="text-sm text-red-600 mt-2">{fieldErrors.password}</p>
                    )}
                  </div>

                  {/* Buttons */}
                  <div className="flex gap-3">
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => setSelectedRole(null)}
                      className="flex-1 h-12 text-base"
                    >
                      Kembali
                    </Button>
                    <Button
                      type="submit"
                      disabled={!firebaseReady}
                      className={`flex-1 h-12 text-base font-semibold ${
                        selectedRole === "doctor"
                          ? "bg-green-600 hover:bg-green-700"
                          : "bg-purple-600 hover:bg-purple-700"
                      }`}
                    >
                      Login
                    </Button>
                  </div>

                  {selectedRole === "doctor" && (
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => navigate("/doctor/register")}
                      className="w-full h-11 text-base border-green-200 text-green-700 hover:bg-green-50 hover:text-green-800"
                    >
                      <UserPlus className="w-4 h-4 mr-2" />
                      Belum Punya Akun? Daftar Dokter
                    </Button>
                  )}
                </div>
              </form>

              {/* Login Info */}
              <div className="bg-slate-50 px-8 py-4 border-t border-slate-200">
                <p className="text-xs text-slate-600 text-center">
                  {selectedRole === "doctor" && (
                    <>
                      Login menggunakan akun <strong>dokter</strong> yang aktif.
                    </>
                  )}
                  {selectedRole === "admin" && (
                    <>
                      Login menggunakan akun <strong>admin</strong> yang aktif.
                    </>
                  )}
                </p>
              </div>
            </div>
          )}

        </div>
      </div>
    </div>
  );
}

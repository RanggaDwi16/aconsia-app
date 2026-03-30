import { useState } from "react";
import { useNavigate } from "react-router";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Label } from "../components/ui/label";
import { ArrowLeft, AlertCircle, Shield, User, Stethoscope } from "lucide-react";
import logoImage from "figma:asset/1c448958f0817c176999b741d53bcc5ce9b3930d.png";
import { DesktopAuthError, signInDesktop } from "../../core/auth/service";
import { getDesktopSession } from "../../core/auth/session";
import { writeAuditLog } from "../../modules/admin/services/auditWriterService";

type LoginRole = "patient" | "doctor" | "admin";

export function UnifiedLoginPage() {
  const navigate = useNavigate();
  const [selectedRole, setSelectedRole] = useState<LoginRole | null>(null);
  const [identifier, setIdentifier] = useState(""); // NIK for patient, email for doctor/admin
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (!identifier.trim() || !password.trim()) {
      setError("Semua field wajib diisi");
      return;
    }

    if (selectedRole === "patient") {
      setError("Portal desktop hanya untuk dokter/admin. Pasien menggunakan aplikasi mobile.");
      return;
    }

    if (selectedRole === "doctor") {
      try {
        await signInDesktop({
          email: identifier.trim(),
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
          setError("Login dokter gagal. Periksa koneksi/Firebase config.");
        }
      }
      return;
    }

    if (selectedRole === "admin") {
      try {
        await signInDesktop({
          email: identifier.trim(),
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
          setError("Login admin gagal. Periksa koneksi/Firebase config.");
        }
      }
      return;
    }

    setError("Pilih role terlebih dahulu!");
  };

  // Reset form when role changes
  const handleRoleChange = (role: LoginRole) => {
    setSelectedRole(role);
    setIdentifier("");
    setPassword("");
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
            <div className="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-3xl mb-6 shadow-xl">
              <img src={logoImage} alt="ACONSIA Logo" className="w-16 h-16 object-contain brightness-0 invert" />
            </div>
            <h1 className="text-4xl font-bold text-slate-900 mb-3 tracking-tight">
              {selectedRole === null && "Selamat Datang"}
              {selectedRole === "patient" && "Login Pasien"}
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
              {/* Pasien Card */}
              <button
                onClick={() => handleRoleChange("patient")}
                className="w-full bg-white rounded-2xl p-5 shadow-sm hover:shadow-xl transition-all duration-300 border border-slate-100 hover:border-blue-300 hover:-translate-y-1 group relative overflow-hidden"
              >
                <div className="absolute inset-0 bg-gradient-to-r from-blue-50 to-cyan-50 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                
                <div className="relative flex items-center gap-4">
                  <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform duration-300">
                    <User className="w-8 h-8 text-white" />
                  </div>
                  
                  <div className="flex-1 text-left">
                    <h3 className="text-xl font-bold text-slate-900 mb-1 group-hover:text-blue-600 transition-colors">Pasien</h3>
                    <p className="text-sm text-slate-600">Login dengan NIK</p>
                  </div>
                  
                  <div className="w-10 h-10 bg-slate-100 rounded-xl flex items-center justify-center group-hover:bg-blue-100 transition-colors">
                    <ArrowLeft className="w-5 h-5 text-slate-400 rotate-180 group-hover:text-blue-600 group-hover:translate-x-1 transition-all" />
                  </div>
                </div>
              </button>

              {/* Dokter Card */}
              <button
                onClick={() => handleRoleChange("doctor")}
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

              {/* Environment Notes */}
              <div className="bg-gradient-to-r from-slate-50 to-slate-100 rounded-2xl p-6 mt-8 border border-slate-200">
                <div className="flex items-start gap-3 mb-4">
                  <div className="w-8 h-8 bg-slate-900 rounded-lg flex items-center justify-center flex-shrink-0">
                    <span className="text-white text-sm">🔐</span>
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-slate-900 mb-1">Catatan Login</h4>
                    <p className="text-xs text-slate-600">Desktop memakai Firebase Auth + role dari Firestore</p>
                  </div>
                </div>
                <div className="space-y-3">
                  <div className="bg-white rounded-xl p-3 border border-slate-200">
                    <div className="flex items-center gap-2 mb-1">
                      <div className="w-6 h-6 bg-blue-100 rounded-lg flex items-center justify-center">
                        <User className="w-4 h-4 text-blue-600" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Pasien</span>
                    </div>
                    <p className="text-xs text-slate-700 pl-8">Gunakan aplikasi mobile Flutter (bukan desktop)</p>
                  </div>
                  <div className="bg-white rounded-xl p-3 border border-slate-200">
                    <div className="flex items-center gap-2 mb-1">
                      <div className="w-6 h-6 bg-green-100 rounded-lg flex items-center justify-center">
                        <Stethoscope className="w-4 h-4 text-green-600" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Dokter</span>
                    </div>
                    <p className="text-xs text-slate-700 pl-8">Masuk dengan akun Firebase role `dokter`</p>
                  </div>
                  <div className="bg-white rounded-xl p-3 border border-slate-200">
                    <div className="flex items-center gap-2 mb-1">
                      <div className="w-6 h-6 bg-purple-100 rounded-lg flex items-center justify-center">
                        <Shield className="w-4 h-4 text-purple-600" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Admin</span>
                    </div>
                    <p className="text-xs text-slate-700 pl-8">Masuk dengan akun Firebase role `admin`</p>
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
                  selectedRole === "patient"
                    ? "bg-blue-600"
                    : selectedRole === "doctor"
                    ? "bg-green-600"
                    : "bg-purple-600"
                }`}
              >
                <div className="inline-flex items-center justify-center w-16 h-16 bg-white rounded-full mb-3">
                  {selectedRole === "patient" && <User className="w-8 h-8 text-blue-600" />}
                  {selectedRole === "doctor" && <Stethoscope className="w-8 h-8 text-green-600" />}
                  {selectedRole === "admin" && <Shield className="w-8 h-8 text-purple-600" />}
                </div>
                <h2 className="text-xl font-bold text-white mb-1">
                  {selectedRole === "patient" && "Login Pasien"}
                  {selectedRole === "doctor" && "Login Dokter"}
                  {selectedRole === "admin" && "Login Admin"}
                </h2>
                <p className="text-sm text-white/80">
                  {selectedRole === "patient" && "Masukkan NIK dan Password"}
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

                  {/* Identifier Field (NIK or Email) */}
                  <div>
                    <Label htmlFor="identifier" className="text-slate-700 font-semibold mb-2 block">
                      {selectedRole === "patient" ? "NIK" : "Email"}
                    </Label>
                    <Input
                      id="identifier"
                      type="text"
                      value={identifier}
                      onChange={(e) => setIdentifier(e.target.value)}
                      placeholder={
                        selectedRole === "patient"
                          ? "Masukkan NIK Anda"
                          : "Masukkan email Anda"
                      }
                      className="h-12 text-base"
                      autoComplete="off"
                    />
                    {selectedRole === "patient" && (
                      <p className="text-xs text-slate-500 mt-1">
                        Contoh: 3374012205950001 (16 digit)
                      </p>
                    )}
                  </div>

                  {/* Password Field */}
                  <div>
                    <Label htmlFor="password" className="text-slate-700 font-semibold mb-2 block">
                      Password
                    </Label>
                    <Input
                      id="password"
                      type="password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      placeholder="Masukkan password"
                      className="h-12 text-base"
                    />
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
                      className={`flex-1 h-12 text-base font-semibold ${
                        selectedRole === "patient"
                          ? "bg-blue-600 hover:bg-blue-700"
                          : selectedRole === "doctor"
                          ? "bg-green-600 hover:bg-green-700"
                          : "bg-purple-600 hover:bg-purple-700"
                      }`}
                    >
                      Login
                    </Button>
                  </div>
                </div>
              </form>

              {/* Login Info */}
              <div className="bg-slate-50 px-8 py-4 border-t border-slate-200">
                <p className="text-xs text-slate-600 text-center">
                  {selectedRole === "patient" && (
                    <>
                      Pasien menggunakan aplikasi mobile Flutter.
                    </>
                  )}
                  {selectedRole === "doctor" && (
                    <>
                      Login Firebase dengan role <strong>dokter</strong>.
                    </>
                  )}
                  {selectedRole === "admin" && (
                    <>
                      Login Firebase dengan role <strong>admin</strong>.
                    </>
                  )}
                </p>
              </div>
            </div>
          )}

          {/* Register Link (for patient only) */}
          {selectedRole === "patient" && (
            <div className="text-center mt-6">
              <span className="text-sm text-slate-600">
                Belum punya akun?{" "}
                <button
                  onClick={() => navigate("/register")}
                  className="text-blue-600 font-semibold hover:underline"
                >
                  Daftar Sekarang
                </button>
              </span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
import { useState } from "react";
import { useNavigate } from "react-router";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Label } from "../components/ui/label";
import { ArrowLeft, AlertCircle, Shield } from "lucide-react";
import logoImage from "figma:asset/1c448958f0817c176999b741d53bcc5ce9b3930d.png";

export function LoginPage() {
  const navigate = useNavigate();
  const [nik, setNik] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (!nik.trim() || !password.trim()) {
      setError("NIK dan Password wajib diisi");
      return;
    }

    // 1. Check demo patients first (using NIK login)
    const demoPatients = JSON.parse(localStorage.getItem('demoPatients') || '[]');
    const demoPatient = demoPatients.find((p: any) => p.nik === nik && p.password === password);

    if (demoPatient) {
      // Login success with demo account
      localStorage.setItem('userRole', 'patient');
      localStorage.setItem('currentPatient', JSON.stringify(demoPatient));
      navigate('/patient');
      return;
    }

    // 2. Check regular registered patients (legacy MRN login)
    const patients = JSON.parse(localStorage.getItem('patients') || '[]');
    const patient = patients.find((p: any) => p.nik === nik);

    if (!patient) {
      setError("NIK tidak ditemukan. Silakan daftar terlebih dahulu.");
      return;
    }

    // Check approval status
    if (patient.status === 'pending') {
      setError("Akun Anda masih menunggu persetujuan dokter. Silakan hubungi rumah sakit.");
      return;
    }

    if (patient.status === 'rejected') {
      setError("Pendaftaran Anda ditolak. Silakan hubungi rumah sakit untuk informasi lebih lanjut.");
      return;
    }

    // Login success
    localStorage.setItem('userRole', 'patient');
    localStorage.setItem('currentPatient', JSON.stringify(patient));
    navigate('/patient');
  };

  return (
    <div className="min-h-screen bg-white flex flex-col">
      
      {/* Main Content */}
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-md">
          
          {/* Back Button - Clean */}
          <button
            onClick={() => navigate('/')}
            className="flex items-center gap-2 text-slate-600 hover:text-slate-900 mb-8 transition-colors group"
          >
            <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform" />
            <span className="font-medium">Kembali</span>
          </button>

          {/* Card Container - Clean with subtle shadow */}
          <div className="bg-white rounded-2xl shadow-lg border border-slate-200 overflow-hidden">
            
            {/* Header - Clean Blue Solid */}
            <div className="bg-blue-600 px-8 py-12 text-center">
              <div className="inline-flex items-center justify-center w-20 h-20 bg-white rounded-full mb-4 shadow-md">
                <img 
                  src={logoImage} 
                  alt="ACONSIA Logo" 
                  className="w-14 h-14 object-contain"
                />
              </div>
              
              <h1 className="text-2xl font-bold text-white mb-2">
                Login Pasien
              </h1>
              <p className="text-sm text-blue-100">
                Masukkan NIK dan Password Anda
              </p>
            </div>

            {/* Form - Clean & Spacious */}
            <div className="p-8">
              <form onSubmit={handleLogin} className="space-y-6">
                
                {/* Error Alert - Simple */}
                {error && (
                  <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                    <div className="flex items-start gap-3">
                      <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                      <p className="text-sm text-red-800 leading-relaxed">{error}</p>
                    </div>
                  </div>
                )}

                {/* NIK Input - Clean */}
                <div className="space-y-2">
                  <Label htmlFor="nik" className="text-sm font-semibold text-slate-700">
                    Nomor Induk Kependudukan (NIK)
                  </Label>
                  <Input
                    id="nik"
                    type="text"
                    placeholder="Contoh: 1234567890123456"
                    value={nik}
                    onChange={(e) => setNik(e.target.value)}
                    className="h-12 text-base rounded-lg border-slate-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                  />
                </div>

                {/* Password Input - Clean */}
                <div className="space-y-2">
                  <Label htmlFor="password" className="text-sm font-semibold text-slate-700">
                    Password
                  </Label>
                  <Input
                    id="password"
                    type="password"
                    placeholder="Masukkan password Anda"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="h-12 text-base rounded-lg border-slate-300 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                  />
                </div>

                {/* Submit Button - Solid Blue */}
                <Button
                  type="submit"
                  className="w-full h-12 bg-blue-600 hover:bg-blue-700 text-white text-base font-semibold rounded-lg transition-colors"
                >
                  Masuk
                </Button>

                {/* Register Link - Clean */}
                <div className="text-center pt-4 border-t border-slate-100">
                  <p className="text-sm text-slate-600">
                    Belum punya akun?{" "}
                    <button
                      type="button"
                      onClick={() => navigate('/register')}
                      className="text-blue-600 font-semibold hover:text-blue-700 transition-colors hover:underline"
                    >
                      Daftar Sekarang
                    </button>
                  </p>
                </div>

              </form>
            </div>

          </div>

        </div>
      </div>

      {/* Clean Footer - Minimal */}
      <footer className="border-t border-slate-200 bg-white py-8 px-6">
        <div className="max-w-md mx-auto">
          
          {/* Security Badge - Simple */}
          <div className="flex items-center justify-center gap-2 mb-4">
            <Shield className="w-5 h-5 text-blue-600" />
            <span className="text-sm font-semibold text-slate-700">
              Medical Grade Security
            </span>
          </div>

          {/* Copyright - Clean */}
          <p className="text-xs text-slate-500 text-center mb-3">
            © 2025 ACONSIA - Sistem Informasi untuk Edukasi Pasien
          </p>

          {/* Security Notice - Minimal */}
          <p className="text-xs text-slate-600 text-center font-medium">
            🔒 Keamanan Data Pasien Terjamin
          </p>

        </div>
      </footer>

    </div>
  );
}
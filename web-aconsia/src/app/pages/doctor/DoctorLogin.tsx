import { useState } from "react";
import { useNavigate } from "react-router";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { ArrowLeft, AlertCircle, Shield } from "lucide-react";
import logoImage from "figma:asset/1c448958f0817c176999b741d53bcc5ce9b3930d.png";

export function DoctorLogin() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: "",
    password: "",
  });
  const [error, setError] = useState("");

  const handleChange = (field: string, value: string) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (!formData.email || !formData.password) {
      setError("Email dan password wajib diisi");
      return;
    }

    // Check if doctor exists
    const doctors = JSON.parse(localStorage.getItem('doctors') || '[]');
    const doctor = doctors.find(
      (d: any) => d.email === formData.email && d.password === formData.password
    );

    if (!doctor) {
      setError("Email atau password salah");
      return;
    }

    // Login success
    localStorage.setItem('userRole', 'doctor');
    localStorage.setItem('currentDoctor', JSON.stringify(doctor));
    localStorage.setItem('doctorId', doctor.id || 'doctor-001'); // ✅ Save doctor ID untuk filter
    navigate('/doctor/dashboard');
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
            
            {/* Header - Clean Emerald Solid */}
            <div className="bg-emerald-600 px-8 py-12 text-center">
              <div className="inline-flex items-center justify-center w-20 h-20 bg-white rounded-full mb-4 shadow-md">
                <img 
                  src={logoImage} 
                  alt="ACONSIA Logo" 
                  className="w-14 h-14 object-contain"
                />
              </div>
              
              <h1 className="text-2xl font-bold text-white mb-2">
                Login Dokter
              </h1>
              <p className="text-sm text-emerald-100">
                Akses Dashboard Dokter Anestesi
              </p>
            </div>

            {/* Form - Clean & Spacious */}
            <div className="p-8">
              <form onSubmit={handleSubmit} className="space-y-5">
                
                {/* Error Alert - Simple */}
                {error && (
                  <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                    <div className="flex items-start gap-3">
                      <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                      <p className="text-sm text-red-800 leading-relaxed">{error}</p>
                    </div>
                  </div>
                )}

                {/* Email - Clean */}
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-sm font-semibold text-slate-700">
                    Email
                  </Label>
                  <Input
                    id="email"
                    type="email"
                    placeholder="dokter@hospital.com"
                    value={formData.email}
                    onChange={(e) => handleChange("email", e.target.value)}
                    className="h-12 text-base rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 transition-all"
                  />
                </div>

                {/* Password - Clean */}
                <div className="space-y-2">
                  <Label htmlFor="password" className="text-sm font-semibold text-slate-700">
                    Password
                  </Label>
                  <Input
                    id="password"
                    type="password"
                    placeholder="••••••••"
                    value={formData.password}
                    onChange={(e) => handleChange("password", e.target.value)}
                    className="h-12 text-base rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 transition-all"
                  />
                </div>

                {/* Submit Button - Solid Emerald */}
                <Button
                  type="submit"
                  className="w-full h-12 bg-emerald-600 hover:bg-emerald-700 text-white text-base font-semibold rounded-lg transition-colors"
                >
                  Masuk
                </Button>

                {/* Register Link - Clean */}
                <div className="text-center pt-4 border-t border-slate-100">
                  <p className="text-sm text-slate-600">
                    Belum terdaftar?{" "}
                    <button
                      type="button"
                      onClick={() => navigate('/doctor/register')}
                      className="text-emerald-600 font-semibold hover:text-emerald-700 transition-colors hover:underline"
                    >
                      Daftar Sebagai Dokter
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
            <Shield className="w-5 h-5 text-emerald-600" />
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
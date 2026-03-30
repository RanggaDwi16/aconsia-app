import { useNavigate } from "react-router";
import { Button } from "../components/ui/button";
import { Smartphone, ArrowLeft } from "lucide-react";

export function DesktopPatientRedirectPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50 flex items-center justify-center px-6">
      <div className="max-w-lg w-full bg-white border border-slate-200 rounded-2xl p-8 text-center shadow-sm">
        <div className="w-16 h-16 mx-auto mb-4 rounded-2xl bg-blue-100 flex items-center justify-center">
          <Smartphone className="w-8 h-8 text-blue-600" />
        </div>

        <h1 className="text-2xl font-bold text-slate-900 mb-3">Portal Pasien di Mobile App</h1>
        <p className="text-slate-600 mb-6">
          Sesuai kebijakan Phase 2, akses pasien dipindahkan ke aplikasi mobile Flutter.
          Silakan gunakan aplikasi mobile ACONSIA untuk login dan belajar materi.
        </p>

        <div className="space-y-3">
          <Button
            className="w-full bg-blue-600 hover:bg-blue-700"
            onClick={() => navigate("/login")}
          >
            Kembali ke Login Desktop
          </Button>
          <Button variant="outline" className="w-full" onClick={() => navigate("/")}>
            <ArrowLeft className="w-4 h-4 mr-2" />
            Ke Landing Page
          </Button>
        </div>
      </div>
    </div>
  );
}

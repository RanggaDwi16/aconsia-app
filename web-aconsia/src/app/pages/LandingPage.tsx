import { Button } from "../components/ui/button";
import { useNavigate } from "react-router";
import { Shield } from "lucide-react";
import logoImage from "figma:asset/1c448958f0817c176999b741d53bcc5ce9b3930d.png";

export function LandingPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-white flex flex-col">
      
      {/* Main Content */}
      <div className="flex-1 flex items-center justify-center px-6 py-16">
        <div className="w-full max-w-md">
          
          {/* Logo & Title */}
          <div className="text-center mb-12">
            {/* Logo - Clean & Simple */}
            <div className="inline-flex items-center justify-center w-24 h-24 bg-white rounded-full shadow-md mb-8">
              <img 
                src={logoImage} 
                alt="ACONSIA Logo" 
                className="w-16 h-16 object-contain"
              />
            </div>
            
            {/* Title - Bold & Clean */}
            <h1 className="text-4xl font-bold text-slate-900 mb-3">
              ACONSIA
            </h1>
          </div>

          {/* Description - No Card, Just Text */}
          <div className="mb-10 px-4">
            <h2 className="text-lg font-semibold text-slate-900 mb-2 text-center">
              Platform Edukasi Anestesi Digital
            </h2>
            <p className="text-sm text-slate-600 text-center leading-relaxed">
              Menghubungkan dokter dan pasien untuk memahami prosedur anestesi dengan lebih baik sebelum operasi
            </p>
          </div>

          {/* Clean Buttons - NO Gradient */}
          <div className="space-y-3 mb-10">
            {/* Dokter Button - Solid Emerald */}
            <Button
              onClick={() => navigate('/login')}
              className="w-full h-14 bg-emerald-600 hover:bg-emerald-700 text-white text-base font-semibold rounded-lg transition-colors"
            >
              Masuk sebagai Dokter
            </Button>

            {/* Pasien Button - Outline */}
            <Button
              onClick={() => navigate('/login')}
              variant="outline"
              className="w-full h-14 border-2 border-slate-300 hover:border-blue-600 text-slate-700 hover:text-blue-600 hover:bg-blue-50 text-base font-semibold rounded-lg transition-colors"
            >
              Pasien: gunakan aplikasi mobile
            </Button>

            {/* Admin Button - NEW! */}
            <Button
              onClick={() => navigate('/login')}
              variant="outline"
              className="w-full h-14 border-2 border-purple-300 hover:border-purple-600 text-purple-700 hover:text-purple-600 hover:bg-purple-50 text-base font-semibold rounded-lg transition-colors"
            >
              Masuk sebagai Admin
            </Button>
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
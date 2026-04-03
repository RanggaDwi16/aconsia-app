import { useEffect, useState } from "react";
import { Button } from "../components/ui/button";
import { useNavigate } from "react-router";
import { Shield } from "lucide-react";
import { BrandLogo } from "../components/BrandLogo";
import {
  resolveDesktopSession,
} from "../../core/auth/session";
import {
  prefetchCriticalRoutesOnIdle,
  prefetchLoginPage,
} from "../routes/prefetch";
import { startNavigationMetric } from "../perf/navigationMetrics";

export function LandingPage() {
  const navigate = useNavigate();
  const [isResolvingSession, setIsResolvingSession] = useState(true);

  useEffect(() => {
    let active = true;

    const routeBySession = (role: string) => {
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

    const resolveSession = async () => {
      const hydratedSession = await resolveDesktopSession();
      if (!active) return;

      if (hydratedSession && routeBySession(hydratedSession.role)) {
        return;
      }

      prefetchCriticalRoutesOnIdle();
      setIsResolvingSession(false);
    };

    void resolveSession();

    return () => {
      active = false;
    };
  }, [navigate]);

  if (isResolvingSession) {
    return (
      <div className="min-h-screen bg-white flex items-center justify-center px-6">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-sm text-slate-600 font-medium">
            Mengecek sesi login...
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white flex flex-col">
      
      {/* Main Content */}
      <div className="flex-1 flex items-center justify-center px-6 py-16">
        <div className="w-full max-w-md">
          
          {/* Logo & Title */}
          <div className="text-center mb-12">
            {/* Logo - Clean & Simple */}
            <BrandLogo wrapperClassName="inline-flex items-center justify-center w-24 h-24 bg-white rounded-full shadow-md mb-8" imageClassName="w-16 h-16 object-contain" />
            
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
            <p className="text-xs text-slate-500 text-center">
              Portal desktop khusus dokter dan admin. Pasien menggunakan aplikasi mobile.
            </p>

            {/* Dokter Button - Solid Emerald */}
            <Button
              onMouseEnter={() => void prefetchLoginPage()}
              onFocus={() => void prefetchLoginPage()}
              onClick={() => {
                startNavigationMetric("landing_to_login");
                navigate('/login');
              }}
              className="w-full h-14 bg-emerald-600 hover:bg-emerald-700 text-white text-base font-semibold rounded-lg transition-colors"
            >
              Masuk sebagai Dokter
            </Button>

            {/* Admin Button - NEW! */}
            <Button
              onMouseEnter={() => void prefetchLoginPage()}
              onFocus={() => void prefetchLoginPage()}
              onClick={() => {
                startNavigationMetric("landing_to_login");
                navigate('/login');
              }}
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

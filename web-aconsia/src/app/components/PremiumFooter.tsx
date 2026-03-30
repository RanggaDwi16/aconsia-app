import { Shield } from "lucide-react";

interface PremiumFooterProps {
  variant?: "blue" | "emerald" | "purple";
}

export function PremiumFooter({ variant = "blue" }: PremiumFooterProps) {
  const colorClasses = {
    blue: {
      badgeBg: "bg-blue-100",
      badgeIcon: "text-blue-600",
    },
    emerald: {
      badgeBg: "bg-emerald-100",
      badgeIcon: "text-emerald-600",
    },
    purple: {
      badgeBg: "bg-purple-100",
      badgeIcon: "text-purple-600",
    },
  };

  const colors = colorClasses[variant];

  return (
    <footer className="border-t border-slate-200 bg-white/80 backdrop-blur-sm py-6 px-6">
      <div className="max-w-md mx-auto">
        
        {/* Security Badge */}
        <div className="flex items-center justify-center gap-2 mb-3">
          <div className={`flex items-center justify-center w-8 h-8 ${colors.badgeBg} rounded-lg`}>
            <Shield className={`w-5 h-5 ${colors.badgeIcon}`} />
          </div>
          <span className="text-sm font-semibold text-slate-700">
            Medical Grade Security
          </span>
        </div>

        {/* Copyright */}
        <p className="text-xs text-slate-500 text-center mb-2">
          © 2025 ACONSIA - Sistem Informasi untuk Edukasi Pasien
        </p>

        {/* Security Notice */}
        <div className="bg-slate-50 rounded-lg px-4 py-2 border border-slate-200">
          <p className="text-xs text-slate-600 text-center font-medium">
            🔒 Keamanan Data Pasien Terjamin
          </p>
        </div>

      </div>
    </footer>
  );
}

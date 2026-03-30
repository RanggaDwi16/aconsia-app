import { ReactNode } from "react";
import { useNavigate, useLocation } from "react-router";
import { LayoutDashboard, User, Users, FileText, LogOut } from "lucide-react";
import { Button } from "../components/ui/button";
import { signOutDesktop } from "../../core/auth/service";
import { getDesktopSession } from "../../core/auth/session";
import { writeAuditLog } from "../../modules/admin/services/auditWriterService";

interface DoctorLayoutProps {
  children: ReactNode;
}

export function DoctorLayout({ children }: DoctorLayoutProps) {
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = async () => {
    const session = getDesktopSession();
    if (session) {
      await writeAuditLog({
        actorUid: session.uid,
        actorRole: "doctor",
        actorName: session.displayName || session.email,
        actionType: "LOGOUT",
        entityType: "auth",
        message: "Doctor signed out from desktop portal",
      });
    }

    await signOutDesktop();
    navigate("/login");
  };

  const menuItems = [
    {
      icon: LayoutDashboard,
      label: "Dashboard",
      path: "/doctor/dashboard",
    },
    {
      icon: User,
      label: "Profil Saya",
      path: "/doctor/profile",
    },
    {
      icon: Users,
      label: "Pasien Saya",
      path: "/doctor/patients",
    },
    {
      icon: FileText,
      label: "Konten Edukasi",
      path: "/doctor/content",
    },
  ];

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className="min-h-screen bg-gray-50 flex">
      {/* Sidebar */}
      <aside className="w-64 bg-white border-r border-gray-200 flex flex-col">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-green-600 p-6 text-white">
          <h1 className="text-xl font-bold">Informed Consent</h1>
          <p className="text-sm text-blue-100 mt-1">Sistem Edukasi AI</p>
        </div>

        {/* Menu */}
        <nav className="flex-1 p-4 space-y-2">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const active = isActive(item.path);
            return (
              <button
                key={item.path}
                onClick={() => navigate(item.path)}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                  active
                    ? "bg-blue-50 text-blue-600 font-semibold"
                    : "text-gray-700 hover:bg-gray-50"
                }`}
              >
                <Icon className="w-5 h-5" />
                <span>{item.label}</span>
              </button>
            );
          })}
        </nav>

        {/* Logout */}
        <div className="p-4 border-t border-gray-200">
          <Button
            variant="outline"
            onClick={handleLogout}
            className="w-full border-red-300 text-red-600 hover:bg-red-50"
          >
            <LogOut className="w-4 h-4 mr-2" />
            Logout
          </Button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">{children}</main>
    </div>
  );
}

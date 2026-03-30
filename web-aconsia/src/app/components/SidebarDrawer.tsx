import { useNavigate } from "react-router";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import {
  Home,
  User,
  BookOpen,
  MessageCircle,
  Phone,
  LogOut,
  X,
  Calendar,
  ClipboardCheck,
} from "lucide-react";

interface SidebarDrawerProps {
  isOpen: boolean;
  onClose: () => void;
  patientData: {
    fullName: string;
    mrn: string;
    comprehensionScore: number;
    anesthesiaType: string | null;
  } | null;
}

export function SidebarDrawer({ isOpen, onClose, patientData }: SidebarDrawerProps) {
  const navigate = useNavigate();

  const handleNavigation = (path: string) => {
    navigate(path);
    onClose();
  };

  const handleLogout = () => {
    localStorage.removeItem("currentPatient");
    navigate("/login");
  };

  const menuItems = [
    {
      icon: Home,
      label: "Dashboard",
      path: "/patient",
      color: "text-blue-600",
    },
    {
      icon: User,
      label: "Profil Saya",
      path: "/patient/profile",
      color: "text-purple-600",
    },
    {
      icon: ClipboardCheck,
      label: "Asesmen Pra-Operasi",
      path: "/patient/pre-operative-assessment",
      color: "text-orange-600",
    },
    {
      icon: BookOpen,
      label: "Materi Edukasi",
      path: "/patient/education",
      color: "text-green-600",
    },
    {
      icon: MessageCircle,
      label: "Chat AI Assistant",
      path: "/patient/chat-hybrid",
      color: "text-pink-600",
    },
    {
      icon: Phone,
      label: "Hubungi Dokter",
      path: "/patient/contact-doctor",
      color: "text-cyan-600",
    },
    {
      icon: Calendar,
      label: "Jadwal Tanda Tangan",
      path: "/patient/schedule-signature",
      color: "text-emerald-600",
    },
  ];

  return (
    <>
      {/* Overlay Backdrop */}
      <div
        className={`fixed inset-0 bg-black/50 z-40 transition-opacity duration-300 ${
          isOpen ? "opacity-100" : "opacity-0 pointer-events-none"
        }`}
        onClick={onClose}
      />

      {/* Sidebar Drawer */}
      <div
        className={`fixed top-0 left-0 h-full w-[280px] bg-white shadow-2xl z-50 transform transition-transform duration-300 ${
          isOpen ? "translate-x-0" : "-translate-x-full"
        }`}
      >
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-cyan-600 p-4 relative">
          {/* Close Button */}
          <Button
            variant="ghost"
            size="sm"
            className="absolute top-2 right-2 text-white hover:bg-white/20"
            onClick={onClose}
          >
            <X className="w-5 h-5" />
          </Button>

          {/* User Info */}
          <div className="mt-2">
            <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center mb-3">
              <User className="w-8 h-8 text-blue-600" />
            </div>
            <h2 className="text-white font-bold text-lg truncate">
              {patientData?.fullName || "Pasien"}
            </h2>
            <p className="text-blue-100 text-sm">MRN: {patientData?.mrn || "-"}</p>
            
            {/* Progress Badge */}
            <div className="mt-3 flex items-center gap-2">
              <Badge className="bg-white/20 text-white border-white/30 text-xs">
                Pemahaman: {patientData?.comprehensionScore || 0}%
              </Badge>
              {patientData?.anesthesiaType && (
                <Badge className="bg-white/20 text-white border-white/30 text-xs">
                  {patientData.anesthesiaType}
                </Badge>
              )}
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="p-3 space-y-1 overflow-y-auto" style={{ maxHeight: "calc(100vh - 280px)" }}>
          {menuItems.map((item) => (
            <button
              key={item.path}
              onClick={() => handleNavigation(item.path)}
              className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-100 transition-colors text-left group"
            >
              <item.icon className={`w-5 h-5 ${item.color}`} />
              <span className="text-gray-900 font-medium">{item.label}</span>
            </button>
          ))}
        </div>

        {/* Logout Button */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-200 bg-white">
          <Button
            variant="outline"
            className="w-full gap-2 text-red-600 border-red-300 hover:bg-red-50"
            onClick={handleLogout}
          >
            <LogOut className="w-4 h-4" />
            Keluar
          </Button>
        </div>
      </div>
    </>
  );
}

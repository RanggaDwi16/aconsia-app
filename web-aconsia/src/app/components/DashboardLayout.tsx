import { ReactNode } from "react";
import { useNavigate } from "react-router";
import { Button } from "./ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { 
  LayoutDashboard, 
  Users, 
  FileText, 
  User, 
  BookOpen, 
  MessageSquare, 
  ClipboardCheck,
  LogOut,
  BarChart3
} from "lucide-react";

interface DashboardLayoutProps {
  children: ReactNode;
  role: 'admin' | 'doctor' | 'patient';
  userName?: string;
  userAvatar?: string;
}

export function DashboardLayout({ children, role, userName = "User", userAvatar }: DashboardLayoutProps) {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('userRole');
    localStorage.removeItem('userId');
    navigate('/');
  };

  const getNavItems = () => {
    if (role === 'admin') {
      return [
        { icon: LayoutDashboard, label: "Dashboard", path: "/admin" },
        { icon: Users, label: "Kelola Dokter", path: "/admin/doctors" },
        { icon: Users, label: "Kelola Pasien", path: "/admin/patients" },
        { icon: BarChart3, label: "Statistik", path: "/admin/stats" },
      ];
    } else if (role === 'doctor') {
      return [
        { icon: LayoutDashboard, label: "Dashboard", path: "/doctor" },
        { icon: User, label: "Profil Saya", path: "/doctor/profile" },
        { icon: Users, label: "Pasien Saya", path: "/doctor/patients" },
        { icon: FileText, label: "Konten Edukasi", path: "/doctor/content" },
      ];
    } else {
      return [
        { icon: LayoutDashboard, label: "Dashboard", path: "/patient" },
        { icon: BookOpen, label: "Materi Edukasi", path: "/patient/education" },
        { icon: MessageSquare, label: "Chatbot AI", path: "/patient/chatbot" },
        { icon: ClipboardCheck, label: "Kuis Pemahaman", path: "/patient/quiz" },
      ];
    }
  };

  const getRoleColor = () => {
    if (role === 'admin') return 'bg-purple-600';
    if (role === 'doctor') return 'bg-blue-600';
    return 'bg-green-600';
  };

  const getRoleLabel = () => {
    if (role === 'admin') return 'Administrator';
    if (role === 'doctor') return 'Dokter Anestesi';
    return 'Pasien';
  };

  return (
    <div className="flex min-h-screen">
      {/* Sidebar */}
      <aside className="w-64 bg-white shadow-lg flex flex-col">
        <div className={`${getRoleColor()} text-white p-6`}>
          <h1 className="text-xl font-bold">Informed Consent</h1>
          <p className="text-sm opacity-90 mt-1">Sistem Edukasi AI</p>
        </div>

        <nav className="flex-1 p-4 space-y-2">
          {getNavItems().map((item) => (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-100 transition-colors text-left"
            >
              <item.icon className="w-5 h-5 text-gray-600" />
              <span className="text-gray-700">{item.label}</span>
            </button>
          ))}
        </nav>

        <div className="p-4 border-t">
          <div className="flex items-center gap-3 mb-4">
            <Avatar>
              <AvatarImage src={userAvatar} />
              <AvatarFallback className={getRoleColor()}>
                {userName.charAt(0).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <p className="font-medium text-sm">{userName}</p>
              <p className="text-xs text-gray-500">{getRoleLabel()}</p>
            </div>
          </div>
          <Button 
            variant="outline" 
            className="w-full gap-2" 
            onClick={handleLogout}
          >
            <LogOut className="w-4 h-4" />
            Logout
          </Button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 p-8 overflow-auto">
        {children}
      </main>
    </div>
  );
}

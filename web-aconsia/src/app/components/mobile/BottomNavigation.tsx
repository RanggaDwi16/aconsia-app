import { useNavigate, useLocation } from "react-router";
import { Home, BookOpen, MessageCircle, User } from "lucide-react";

interface NavItem {
  icon: React.ElementType;
  label: string;
  path: string;
}

const navItems: NavItem[] = [
  { icon: Home, label: "Beranda", path: "/patient" },
  { icon: BookOpen, label: "Materi", path: "/patient/education" },
  { icon: MessageCircle, label: "Hubungi", path: "/patient/contact-doctor" },
  { icon: User, label: "Profil", path: "/patient/profile" }
];

export function BottomNavigation() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-slate-200 safe-area-bottom z-50">
      <div className="flex items-center justify-around h-16 max-w-lg mx-auto px-2">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.path;
          
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              className={`flex flex-col items-center justify-center flex-1 h-full transition-colors ${
                isActive 
                  ? "text-blue-600" 
                  : "text-slate-400 hover:text-slate-600"
              }`}
            >
              <Icon className="w-6 h-6 mb-1" strokeWidth={isActive ? 2.5 : 2} />
              <span className={`text-xs ${isActive ? "font-semibold" : "font-medium"}`}>
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}

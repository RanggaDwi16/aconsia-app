import { ReactNode } from "react";
import { BottomNavigation } from "../components/mobile/BottomNavigation";

interface MobileLayoutProps {
  children: ReactNode;
  showBottomNav?: boolean;
}

export function MobileLayout({ children, showBottomNav = true }: MobileLayoutProps) {
  return (
    <div className="min-h-screen bg-slate-50 flex flex-col">
      {/* Main Content */}
      <div className={`flex-1 overflow-y-auto ${showBottomNav ? 'pb-16' : ''}`}>
        {children}
      </div>
      
      {/* Bottom Navigation */}
      {showBottomNav && <BottomNavigation />}
    </div>
  );
}

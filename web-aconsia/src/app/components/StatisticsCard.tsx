import { Card, CardContent } from "./ui/card";
import { LucideIcon } from "lucide-react";

interface StatisticsCardProps {
  title: string;
  value: string | number;
  icon: LucideIcon;
  change?: string;
  color: string;
}

export function StatisticsCard({ title, value, icon: Icon, change, color }: StatisticsCardProps) {
  return (
    <Card className="hover:shadow-lg transition-shadow">
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-gray-600">{title}</p>
            <p className="text-3xl font-bold mt-2">{value}</p>
            {change && <p className="text-xs text-gray-500 mt-2">{change}</p>}
          </div>
          <div className={`${color} p-3 rounded-lg`}>
            <Icon className="w-6 h-6 text-white" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

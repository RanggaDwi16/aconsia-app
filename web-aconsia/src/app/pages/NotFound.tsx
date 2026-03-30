import { useNavigate } from "react-router";
import { Button } from "../components/ui/button";
import { Home } from "lucide-react";

export function NotFound() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <div className="text-center">
        <h1 className="text-9xl font-bold text-blue-600">404</h1>
        <h2 className="text-2xl font-semibold text-gray-900 mt-4">Halaman Tidak Ditemukan</h2>
        <p className="text-gray-600 mt-2 mb-8">
          Maaf, halaman yang Anda cari tidak tersedia.
        </p>
        <Button 
          onClick={() => navigate('/')}
          className="bg-blue-600 hover:bg-blue-700 gap-2"
        >
          <Home className="w-4 h-4" />
          Kembali ke Beranda
        </Button>
      </div>
    </div>
  );
}

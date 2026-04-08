import { isRouteErrorResponse, useNavigate, useRouteError } from "react-router";
import { userMessages } from "../copy/userMessages";

function getErrorInfo(error: unknown): {
  title: string;
  message: string;
  statusCode?: number;
} {
  if (isRouteErrorResponse(error)) {
    if (error.status === 404) {
      return {
        title: "Halaman Tidak Ditemukan",
        message:
          "Rute yang Anda buka tidak tersedia. Periksa URL atau kembali ke halaman utama.",
        statusCode: 404,
      };
    }

    if (error.status === 401 || error.status === 403) {
      return {
        title: "Akses Ditolak",
        message:
          "Anda tidak memiliki izin untuk membuka halaman ini. Silakan login dengan akun yang sesuai.",
        statusCode: error.status,
      };
    }

    return {
      title: "Terjadi Kesalahan Aplikasi",
      message: error.statusText || "Terjadi kesalahan saat memuat halaman.",
      statusCode: error.status,
    };
  }

  if (error instanceof Error) {
    if (error.message.includes("auth/invalid-api-key")) {
      return {
        title: "Layanan Sedang Bermasalah",
        message: userMessages.routeError.serviceUnavailable,
      };
    }

    return {
      title: "Terjadi Kesalahan Aplikasi",
      message: userMessages.routeError.generic,
    };
  }

  return {
    title: "Terjadi Kesalahan Aplikasi",
    message: "Kesalahan tidak diketahui. Silakan refresh halaman.",
  };
}

export function RouteErrorPage() {
  const navigate = useNavigate();
  const error = useRouteError();
  const info = getErrorInfo(error);

  return (
    <div className="min-h-screen bg-slate-50 flex items-center justify-center px-6">
      <div className="w-full max-w-lg bg-white border border-slate-200 rounded-2xl shadow-sm p-8">
        {info.statusCode ? (
          <p className="text-sm font-semibold text-blue-700 mb-2">Error {info.statusCode}</p>
        ) : null}
        <h1 className="text-2xl font-bold text-slate-900 mb-3">{info.title}</h1>
        <p className="text-slate-600 mb-6">{info.message}</p>
        <div className="flex flex-wrap gap-3">
          <button
            onClick={() => navigate("/")}
            className="h-11 px-5 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 transition-colors"
          >
            Kembali ke Beranda
          </button>
          <button
            onClick={() => window.location.reload()}
            className="h-11 px-5 rounded-lg border border-slate-300 text-slate-700 font-semibold hover:bg-slate-100 transition-colors"
          >
            Muat Ulang Halaman
          </button>
        </div>
      </div>
    </div>
  );
}

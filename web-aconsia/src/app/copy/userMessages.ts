export const userMessages = {
  common: {
    loadError: "Terjadi kendala memuat data. Silakan coba lagi.",
    saveError: "Perubahan belum dapat disimpan. Silakan coba lagi.",
    createError: "Data belum berhasil dibuat. Silakan coba lagi.",
    updateError: "Data belum berhasil diperbarui. Silakan coba lagi.",
    deleteError: "Data belum berhasil dihapus. Silakan coba lagi.",
    contactAdmin: "Jika masalah berlanjut, hubungi tim admin.",
  },
  auth: {
    accessDenied: "Akses Anda belum tersedia untuk data ini. Silakan hubungi admin.",
    serviceUnavailable:
      "Layanan belum siap digunakan saat ini. Silakan coba lagi dalam beberapa saat.",
    loginDoctorFailed:
      "Login dokter belum berhasil. Silakan periksa kembali data login Anda.",
    loginAdminFailed:
      "Login admin belum berhasil. Silakan periksa kembali data login Anda.",
    profileNotFound:
      "Data akun Anda belum ditemukan. Silakan hubungi tim admin.",
    invalidRole: "Akun Anda belum memiliki akses ke halaman ini.",
    wrongDoctorRole: "Akun ini belum terdaftar sebagai dokter.",
    wrongAdminRole: "Akun ini belum terdaftar sebagai admin.",
    missingConfig:
      "Layanan belum siap digunakan saat ini. Silakan coba lagi nanti atau hubungi tim admin.",
  },
  doctorContent: {
    subtitle: "Kelola konten edukasi untuk pasien Anda.",
    createDialogDescription:
      "Konten baru akan disimpan sebagai draft dan dapat diperbarui kapan saja.",
    listDescription: "Daftar konten edukasi yang telah Anda buat.",
    editDialogDescription: "Perubahan konten akan langsung diperbarui.",
    loadError: "Terjadi kendala memuat konten edukasi. Silakan coba lagi.",
    createError: "Konten belum berhasil dibuat. Silakan coba lagi.",
    updateError: "Perubahan konten belum berhasil disimpan. Silakan coba lagi.",
    deleteError: "Konten belum berhasil dihapus. Silakan coba lagi.",
  },
  doctorPatients: {
    subtitle: "Daftar pasien yang saat ini menjadi tanggung jawab Anda.",
    infoBanner:
      "Penambahan pasien dilakukan melalui proses registrasi dan penugasan yang tersedia di sistem.",
    loadError: "Terjadi kendala memuat data pasien. Silakan coba lagi.",
  },
  doctorChats: {
    subtitle: "Daftar percakapan chat langsung dengan pasien Anda.",
    infoBanner:
      "Komunikasi pada halaman ini bersifat chat-only. Fitur telepon dan video call tidak tersedia pada fase ini.",
    loadError: "Terjadi kendala memuat daftar chat pasien. Silakan coba lagi.",
    permissionDenied:
      "Akses chat belum tersedia untuk akun ini. Pastikan akun dokter Anda sesuai dengan data penugasan pasien.",
    authMismatch:
      "Sesi akun tidak sinkron. Silakan logout lalu login kembali.",
  },
  doctorMonitoring: {
    subtitle: "Pemantauan progres pasien diperbarui otomatis setiap 10 detik.",
    loadError: "Terjadi kendala memuat data monitoring. Silakan coba lagi.",
  },
  doctorProfile: {
    loadError: "Terjadi kendala memuat profil dokter. Silakan coba lagi.",
    saveError: "Perubahan profil belum berhasil disimpan. Silakan coba lagi.",
  },
  doctorDashboard: {
    loadError: "Terjadi kendala memuat dashboard dokter. Silakan coba lagi.",
    notAuthenticated:
      "Sesi login Anda sudah berakhir. Silakan login kembali untuk melanjutkan.",
    sessionMismatch:
      "Sesi Anda tidak sinkron. Silakan logout lalu login kembali.",
    assignAnesthesiaError:
      "Penetapan jenis anestesi belum berhasil. Silakan coba lagi.",
  },
  doctorRegistration: {
    submitError: "Registrasi dokter belum berhasil. Silakan coba lagi.",
  },
  patientApproval: {
    notFound: "Data pasien tidak ditemukan.",
    loadError: "Terjadi kendala memuat data pasien. Silakan coba lagi.",
    approveError: "Persetujuan pasien belum berhasil. Silakan coba lagi.",
    rejectError: "Penolakan pasien belum berhasil. Silakan coba lagi.",
  },
  admin: {
    dashboardLoadError: "Terjadi kendala memuat dashboard. Silakan coba lagi.",
    auditLoadError: "Terjadi kendala memuat data audit. Silakan coba lagi.",
    reportsLoadError: "Terjadi kendala memuat laporan. Silakan coba lagi.",
    moderationPreflight:
      "Layanan moderasi belum siap. Silakan muat ulang halaman atau login ulang sebagai admin.",
    publishUnauthenticated: "Sesi admin telah berakhir. Silakan login ulang.",
    publishAccessDenied:
      "Akun ini belum memiliki akses untuk mengubah status konten. Silakan hubungi admin utama.",
    publishNotFound: "Konten tidak ditemukan. Silakan muat ulang data dan coba lagi.",
    publishInvalidArgument:
      "Permintaan perubahan status konten tidak valid. Silakan coba lagi.",
    publishUnknown:
      "Perubahan status konten belum berhasil. Silakan coba lagi.",
    lifecycleUnauthenticated: "Sesi admin telah berakhir. Silakan login ulang.",
    lifecycleAccessDenied:
      "Akun ini belum memiliki akses untuk mengubah status pengguna.",
    lifecycleNotFound: "Pengguna tidak ditemukan. Silakan muat ulang data dan coba lagi.",
    lifecycleInvalidArgument:
      "Permintaan perubahan status pengguna tidak valid. Silakan coba lagi.",
    lifecycleUnknown:
      "Perubahan status pengguna belum berhasil. Silakan coba lagi.",
    hintReloginAdmin: "Silakan logout lalu login ulang menggunakan akun admin.",
    hintCheckAdminRole:
      "Pastikan users/{uid}.role bernilai admin dan custom claim role sudah terpasang.",
    hintCheckContentExists: "Periksa apakah konten masih tersedia di daftar konten.",
    hintTryAgain: "Muat ulang halaman lalu coba lagi beberapa saat.",
  },
  routeError: {
    generic: "Terjadi kesalahan saat memuat halaman. Silakan coba lagi.",
    serviceUnavailable:
      "Layanan sedang mengalami kendala. Silakan muat ulang halaman atau coba beberapa saat lagi.",
  },
} as const;

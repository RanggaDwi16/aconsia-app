# Legacy Surface Freeze (Desktop)

Tanggal: 31 Maret 2026

Dokumen ini menandai surface lama yang **bukan** bagian dari path aktif production desktop.

## Active Production Surface

- Landing desktop
- Unified login desktop (dokter/admin)
- Doctor module (`DoctorDashboardNew`, `PatientApprovalNew`, dst)
- Admin module (`EnhancedAdminDashboard`, `ReportsPage`, `AuditTrailPage`)
- Desktop patient redirect (mobile-only policy)

## Frozen / Non-Active Surface

Komponen berikut tidak dipakai oleh router aktif production:

- `src/app/pages/PrototypeDemo.tsx`
- `src/app/pages/DemoOptionsPage.tsx`
- `src/app/pages/LoginPage.tsx`
- `src/app/pages/admin/AdminDashboard.tsx`
- `src/app/pages/doctor/DoctorDashboard.tsx`
- `src/app/pages/doctor/DoctorLogin.tsx`
- `src/app/pages/doctor/DoctorRegistration.tsx`
- `src/app/pages/doctor/EnhancedDoctorDashboard.tsx`
- `src/app/pages/doctor/PatientApproval.tsx`
- Halaman pasien legacy di `src/app/pages/patient/*` (desktop diarahkan ke mobile-only)

## Kebijakan

1. Jangan menambah route baru ke surface frozen tanpa ADR/approval.
2. Semua perubahan produksi harus masuk ke surface aktif saja.
3. Cleanup fisik file frozen dilakukan terpisah setelah freeze window berakhir.

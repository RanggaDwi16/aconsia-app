# Phase 2 Execution Log

Tanggal: 30 Maret 2026

## Selesai Dikerjakan

1. Dokumen strategi lintas platform:
- [PHASE_2_CROSS_PLATFORM_PRD.md](PHASE_2_CROSS_PLATFORM_PRD.md)
- [PHASE_2_RBAC_MATRIX.md](PHASE_2_RBAC_MATRIX.md)
- [FIRESTORE_V2_MIGRATION_PLAYBOOK.md](FIRESTORE_V2_MIGRATION_PLAYBOOK.md)
- [DESKTOP_CONVERSION_IMPLEMENTATION_PLAN.md](DESKTOP_CONVERSION_IMPLEMENTATION_PLAN.md)

2. Firestore governance:
- [firestore.rules](firestore.rules)
- [firestore.indexes.json](firestore.indexes.json)
- [firebase.json](firebase.json) telah diupdate untuk rules/indexes firestore.

3. Mobile Flutter (pasien-only enforcement awal):
- [lib/presentation/auth/pages/welcome_page.dart](lib/presentation/auth/pages/welcome_page.dart)
- [lib/core/routers/go_router_provider.dart](lib/core/routers/go_router_provider.dart)

4. Desktop web-aconsia (fondasi production auth):
- Firebase Web SDK ditambahkan di [web-aconsia/package.json](web-aconsia/package.json)
- Firebase client:
  - [web-aconsia/src/core/firebase/client.ts](web-aconsia/src/core/firebase/client.ts)
- Auth desktop:
  - [web-aconsia/src/core/auth/service.ts](web-aconsia/src/core/auth/service.ts)
  - [web-aconsia/src/core/auth/session.ts](web-aconsia/src/core/auth/session.ts)
  - [web-aconsia/src/core/auth/RequireRole.tsx](web-aconsia/src/core/auth/RequireRole.tsx)
  - [web-aconsia/src/core/auth/types.ts](web-aconsia/src/core/auth/types.ts)
- Route guard dokter/admin:
  - [web-aconsia/src/app/routes.tsx](web-aconsia/src/app/routes.tsx)
- Unified login sudah pakai Firebase Auth + role Firestore:
  - [web-aconsia/src/app/pages/UnifiedLoginPage.tsx](web-aconsia/src/app/pages/UnifiedLoginPage.tsx)
- Demo auto-seed dimatikan default (opsional via env):
  - [web-aconsia/src/app/App.tsx](web-aconsia/src/app/App.tsx)
- Setup env:
  - [web-aconsia/.env.example](web-aconsia/.env.example)
  - [web-aconsia/README.md](web-aconsia/README.md)

5. Desktop doctor dashboard mulai migrasi ke Firestore:
- Service query pasien scope dokter:
  - [web-aconsia/src/modules/doctor/services/doctorDashboardService.ts](web-aconsia/src/modules/doctor/services/doctorDashboardService.ts)
- Dashboard load Firestore dengan fallback localStorage:
  - [web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx](web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx)

6. Desktop admin module mulai migrasi ke Firestore:
- Service pasien admin dashboard:
  - [web-aconsia/src/modules/admin/services/adminDashboardService.ts](web-aconsia/src/modules/admin/services/adminDashboardService.ts)
- Service audit logs admin:
  - [web-aconsia/src/modules/admin/services/adminAuditService.ts](web-aconsia/src/modules/admin/services/adminAuditService.ts)
- Admin dashboard load Firestore + logout via centralized auth:
  - [web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx](web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx)
- Reports page load Firestore dengan fallback:
  - [web-aconsia/src/app/pages/admin/ReportsPage.tsx](web-aconsia/src/app/pages/admin/ReportsPage.tsx)
- Audit trail load Firestore `admin_audit_logs` + export dari filtered state:
  - [web-aconsia/src/app/pages/admin/AuditTrailPage.tsx](web-aconsia/src/app/pages/admin/AuditTrailPage.tsx)

7. Desktop doctor write-path mulai migrasi ke Firestore:
- Assign jenis anestesi kini menulis ke `pasien_profiles` via Firestore terlebih dahulu (dengan fallback):
  - [web-aconsia/src/modules/doctor/services/doctorDashboardService.ts](web-aconsia/src/modules/doctor/services/doctorDashboardService.ts)
  - [web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx](web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx)

8. Flow approval pasien dokter mulai migrasi ke Firestore:
- Read patient detail approval dari `pasien_profiles` + fallback:
  - [web-aconsia/src/modules/doctor/services/patientApprovalService.ts](web-aconsia/src/modules/doctor/services/patientApprovalService.ts)
  - [web-aconsia/src/app/pages/doctor/PatientApprovalNew.tsx](web-aconsia/src/app/pages/doctor/PatientApprovalNew.tsx)
- Approve/reject action menulis ke Firestore terlebih dahulu + fallback local mode.

9. Audit logging writer ditambahkan (best-effort ke `admin_audit_logs`):
- [web-aconsia/src/modules/admin/services/auditWriterService.ts](web-aconsia/src/modules/admin/services/auditWriterService.ts)
- Dipakai pada flow approve/reject pasien dokter.

10. Penegasan policy desktop phase 2 (pasien-mobile only):
- Semua route patient web diarahkan ke halaman pemberitahuan mobile-only:
  - [web-aconsia/src/app/pages/DesktopPatientRedirectPage.tsx](web-aconsia/src/app/pages/DesktopPatientRedirectPage.tsx)
  - [web-aconsia/src/app/routes.tsx](web-aconsia/src/app/routes.tsx)

11. Hardening auth flow desktop dokter/admin:
- Audit log untuk login dokter/admin dari desktop:
  - [web-aconsia/src/app/pages/UnifiedLoginPage.tsx](web-aconsia/src/app/pages/UnifiedLoginPage.tsx)
- Audit log logout dokter/admin + centralized signout:
  - [web-aconsia/src/app/layouts/DoctorLayout.tsx](web-aconsia/src/app/layouts/DoctorLayout.tsx)
  - [web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx](web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx)

12. Hardening server-side immutable audit + moderation callables:
- Firebase Functions scaffold ditambahkan:
  - [functions/package.json](functions/package.json)
  - [functions/index.js](functions/index.js)
  - [functions/.gitignore](functions/.gitignore)
- Callable function diimplementasikan:
  - `writeAdminAuditLog`
  - `assignPasienAnesthesia`
  - `approvePasienProfile`
  - `rejectPasienProfile`
- Desktop web dipindah ke callable function untuk audit dan approval/reject:
  - [web-aconsia/src/modules/admin/services/auditWriterService.ts](web-aconsia/src/modules/admin/services/auditWriterService.ts)
  - [web-aconsia/src/modules/doctor/services/patientApprovalService.ts](web-aconsia/src/modules/doctor/services/patientApprovalService.ts)
  - [web-aconsia/src/app/pages/doctor/PatientApprovalNew.tsx](web-aconsia/src/app/pages/doctor/PatientApprovalNew.tsx)
  - [web-aconsia/src/modules/doctor/services/doctorDashboardService.ts](web-aconsia/src/modules/doctor/services/doctorDashboardService.ts)
  - [web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx](web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx)
- Firebase client desktop ditambah `firebaseFunctions`:
  - [web-aconsia/src/core/firebase/client.ts](web-aconsia/src/core/firebase/client.ts)
- Rules diperketat untuk mencegah dokter mengubah field approval/rejection sensitif via direct client write:
  - [firestore.rules](firestore.rules)
- Env typing + env contoh diperbarui:
  - [web-aconsia/src/vite-env.d.ts](web-aconsia/src/vite-env.d.ts)
  - [web-aconsia/.env.example](web-aconsia/.env.example)

13. Real data alignment untuk admin dashboard + desktop login policy UX:
- Performa dokter pada dashboard admin kini dihitung dari data Firestore `users` + `pasien_profiles` (menghapus mock statis dokter):
  - [web-aconsia/src/modules/admin/services/adminDashboardService.ts](web-aconsia/src/modules/admin/services/adminDashboardService.ts)
  - [web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx](web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx)
- Login desktop dipertegas hanya dokter/admin (opsi pasien dihapus dari UI login desktop):
  - [web-aconsia/src/app/pages/UnifiedLoginPage.tsx](web-aconsia/src/app/pages/UnifiedLoginPage.tsx)
- Dokumentasi desktop setup diperbarui:
  - [web-aconsia/README.md](web-aconsia/README.md)

14. Migrasi `ReportsPage` ke Firestore-only path:
- `ReportsPage` tidak lagi bergantung pada localStorage fallback; data laporan diambil dari Firestore, dengan state loading dan error eksplisit.
  - [web-aconsia/src/app/pages/admin/ReportsPage.tsx](web-aconsia/src/app/pages/admin/ReportsPage.tsx)
- Kontrak data pasien admin diperkaya agar field laporan (nik, diagnosis, materials, dll) tersedia dari service Firestore.
  - [web-aconsia/src/modules/admin/services/adminDashboardService.ts](web-aconsia/src/modules/admin/services/adminDashboardService.ts)

15. Hardening flow dokter (eliminasi fallback localStorage pada path aktif):
- `DoctorDashboardNew` kini Firestore/callable-only untuk load + assign anestesi (tanpa sinkronisasi localStorage), dengan state loading/error eksplisit.
  - [web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx](web-aconsia/src/app/pages/doctor/DoctorDashboardNew.tsx)
- `PatientApprovalNew` kini Firestore/callable-only untuk load + approve/reject (tanpa fallback localStorage), dengan state loading/error eksplisit.
  - [web-aconsia/src/app/pages/doctor/PatientApprovalNew.tsx](web-aconsia/src/app/pages/doctor/PatientApprovalNew.tsx)
- Surface route dokter lama dipangkas dari router aktif (`dashboard-old`, `approval-old` dihapus; `doctor/register` diarahkan ke login).
  - [web-aconsia/src/app/routes.tsx](web-aconsia/src/app/routes.tsx)
- Env config migration dirapikan (hapus flag localStorage fallback yang tidak dipakai lagi).
  - [web-aconsia/.env.example](web-aconsia/.env.example)
  - [web-aconsia/src/vite-env.d.ts](web-aconsia/src/vite-env.d.ts)

16. Enforcement callable-only untuk action sensitif aktif:
- Service dokter untuk assign/approve/reject sekarang hanya lewat callable backend (tidak ada lagi direct Firestore fallback di service aktif).
  - [web-aconsia/src/modules/doctor/services/doctorDashboardService.ts](web-aconsia/src/modules/doctor/services/doctorDashboardService.ts)
  - [web-aconsia/src/modules/doctor/services/patientApprovalService.ts](web-aconsia/src/modules/doctor/services/patientApprovalService.ts)
- Writer audit desktop sekarang callable-only (direct write fallback dihapus, sesuai policy immutable audit).
  - [web-aconsia/src/modules/admin/services/auditWriterService.ts](web-aconsia/src/modules/admin/services/auditWriterService.ts)
- Environment flags legacy yang tidak relevan untuk path aktif telah dibersihkan.
  - [web-aconsia/.env.example](web-aconsia/.env.example)
  - [web-aconsia/src/vite-env.d.ts](web-aconsia/src/vite-env.d.ts)

17. Batch Finalisasi-1 (admin hardening + runtime shell isolation):
- Runtime shell desktop dipastikan React-first; prototype statis lama di-isolasi dalam `<template>` agar tidak dieksekusi pada runtime aktif.
  - [web-aconsia/index.html](web-aconsia/index.html)
- `EnhancedAdminDashboard` sekarang Firestore-only untuk path aktif (fallback localStorage dihapus), dengan state error eksplisit.
  - [web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx](web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx)
- `AuditTrailPage` sekarang Firestore-only untuk path aktif (fallback `auditTrail` lokal dihapus), dengan state error eksplisit.
  - [web-aconsia/src/app/pages/admin/AuditTrailPage.tsx](web-aconsia/src/app/pages/admin/AuditTrailPage.tsx)
- Callable baru untuk moderation admin ditambahkan di backend:
  - `setUserLifecycleStatus` (`active`/`suspended`)
  - `setKontenPublishStatus` (`draft`/`published`)
  - [functions/index.js](functions/index.js)
- Wrapper service desktop untuk callable moderation admin ditambahkan.
  - [web-aconsia/src/modules/admin/services/adminModerationService.ts](web-aconsia/src/modules/admin/services/adminModerationService.ts)
- Flag env fallback admin lama dihapus dari kontrak env desktop.
  - [web-aconsia/src/vite-env.d.ts](web-aconsia/src/vite-env.d.ts)
  - [web-aconsia/.env.example](web-aconsia/.env.example)

18. Batch Finalisasi-2 (rules hardening + moderation wiring + test gate baseline):
- Firestore rules diperketat agar field lifecycle user dan publish moderation konten tidak bisa diubah langsung dari client (harus lewat callable/system):
  - helper baru `userLifecycleNotChanged`
  - helper baru `kontenModerationFieldsNotChanged`
  - update rule `users/{uid}` dan `konten/{kontenId}`
  - [firestore.rules](firestore.rules)
- Dashboard admin ditambah panel moderasi untuk:
  - suspend/activate user (`active`/`suspended`)
  - publish/unpublish konten (`draft`/`published`)
  - semua aksi via callable server-side + audit immutable
  - [web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx](web-aconsia/src/app/pages/admin/EnhancedAdminDashboard.tsx)
- Service data moderasi admin ditambahkan (snapshot users + konten untuk UI):
  - [web-aconsia/src/modules/admin/services/adminModerationDataService.ts](web-aconsia/src/modules/admin/services/adminModerationDataService.ts)
- Service callable moderasi admin dipakai untuk aksi UI:
  - [web-aconsia/src/modules/admin/services/adminModerationService.ts](web-aconsia/src/modules/admin/services/adminModerationService.ts)
- Baseline rules test gate ditambahkan:
  - script `test:rules` + dependency rules-unit-testing + firebase-tools
  - test cases untuk deny/allow matrix kritikal di:
    - [functions/tests/firestore.rules.test.js](functions/tests/firestore.rules.test.js)
    - [functions/package.json](functions/package.json)
- Validasi:
  - `web-aconsia` build sukses
  - `functions/index.js` syntax check sukses
  - Catatan environment: eksekusi `test:rules` saat ini terblokir karena host dev belum punya JDK 21+ (prasyarat firebase emulator terbaru)

19. Batch Finalisasi-3 (CI gate + legacy route freeze):
- CI workflow lintasan Phase 2 ditambahkan untuk otomatisasi quality gate pada push/PR:
  - Job build desktop (`web-aconsia`): `npm ci` + `npm run build`
  - Job backend/rules (`functions`): setup Node 20 + Java 21, `npm ci`, `node --check index.js`, `npm run test:rules`
  - [.github/workflows/phase2-ci.yml](.github/workflows/phase2-ci.yml)
- Surface route demo legacy dibekukan dari router aktif production desktop (hapus `demo` dan `demo-options`).
  - [web-aconsia/src/app/routes.tsx](web-aconsia/src/app/routes.tsx)
- Validasi:
  - `web-aconsia` build sukses setelah route cleanup.
  - Tidak ada error editor pada workflow YAML dan router.

20. Batch Finalisasi-4 (route hardening + release readiness docs):
- Route lockout pasien desktop disederhanakan menjadi wildcard (`patient/*`) agar maintenance lebih ringkas dan anti-miss pada route baru.
  - [web-aconsia/src/app/routes.tsx](web-aconsia/src/app/routes.tsx)
- Dokumen freeze surface legacy desktop ditambahkan untuk mencegah reaktivasi path lama tanpa approval.
  - [web-aconsia/LEGACY_SURFACE_FREEZE.md](web-aconsia/LEGACY_SURFACE_FREEZE.md)
- Checklist rilis staging -> production ditambahkan (security gate, UAT gate, deploy & rollback plan, monitoring 24 jam).
  - [PHASE_2_RELEASE_CHECKLIST.md](PHASE_2_RELEASE_CHECKLIST.md)
- Validasi:
  - Build desktop sukses setelah perubahan router.

21. Batch Finalisasi-5 (final governance pass):
- Policy governance Phase 2 difinalkan untuk menjaga konsistensi arsitektur (platform scope, callable-only security, immutable audit, change management, exception process).
  - [PHASE_2_GOVERNANCE_POLICY.md](PHASE_2_GOVERNANCE_POLICY.md)
- Template sign-off release lintas fungsi ditambahkan.
  - [PHASE_2_RELEASE_SIGNOFF_TEMPLATE.md](PHASE_2_RELEASE_SIGNOFF_TEMPLATE.md)
- Matriks verifikasi pasca-deploy (T+0 sampai T+24h) ditambahkan.
  - [PHASE_2_POST_DEPLOY_VERIFICATION_MATRIX.md](PHASE_2_POST_DEPLOY_VERIFICATION_MATRIX.md)

Status akhir batch finalisasi:
- Finalisasi-1 ✅
- Finalisasi-2 ✅
- Finalisasi-3 ✅
- Finalisasi-4 ✅
- Finalisasi-5 ✅

---

## Next Recommended Technical Steps

1. Deploy functions + rules + indexes ke project staging, lalu validasi E2E flow doctor/admin.
2. Migrasi action sensitif admin lain (moderation publish/unpublish, user status changes) ke callable backend agar direct write sensitif tertutup penuh.
3. Tambah emulator/integration test untuk `firestore.rules` dan callable authorization matrix.
4. Freeze/hapus route dan halaman legacy yang masih localStorage-centric (`DoctorRegistration`, `EnhancedDoctorDashboard`, `PatientApproval` lama).
5. Tambah observability minimum (error telemetry + action trace id) untuk flow callable kritikal.
6. Siapkan release checklist staging -> production (claims sync, rollback plan, monitoring).

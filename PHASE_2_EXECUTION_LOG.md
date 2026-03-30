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

---

## Next Recommended Technical Steps

1. Deploy functions + rules + indexes ke project staging, lalu validasi E2E flow doctor/admin.
2. Migrasi action sensitif lain ke callable backend (assign anestesi, moderation admin lain) agar direct write sensitif tertutup penuh.
3. Tambah emulator/integration test untuk `firestore.rules` dan callable authorization matrix.
4. Hapus fallback localStorage bertahap setelah staging parity lulus.
5. Integrasi dashboard admin dengan statistik dokter real (hapus mock dokter statis).
6. Siapkan release checklist staging -> production (claims sync, rollback plan, monitoring).

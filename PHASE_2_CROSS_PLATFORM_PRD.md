# PRD Phase 2 ACONSIA (Cross-Platform)

## 1) Ringkasan Eksekutif

Phase 2 mengubah ACONSIA menjadi arsitektur **multi-app, single-backend**:

- **Mobile Flutter (Android/iOS):** fokus **pasien**.
- **Desktop App:** fokus **dokter + admin**.
- **Backend tetap Firebase (Auth + Firestore + Storage + Functions)**.

Target utama:
1. Pemisahan role tegas per platform.
2. Hardening data model Firestore untuk skala klinis.
3. Konversi UI web-aconsia menjadi desktop production-ready.
4. Governance & audit trail untuk admin.

---

## 2) Kondisi Saat Ini (As-Is Audit)

### 2.1 Mobile Flutter (repo utama)

Observasi utama:
- App menggunakan Firebase + Riverpod + GoRouter.
- Login saat ini masih membuka role dokter/pasien di welcome.
- Collection Firestore operasional sudah cukup banyak (`users`, `dokter_profiles`, `pasien_profiles`, `konten`, `konten_sections`, `konten_assignments`, `chat_sessions`, `chat_messages`, `notifications`, `ai_recommendations`, plus `reading_sessions`, `quiz_results`).

Temuan teknis penting:
- Arsitektur dokumentasi dan implementasi sudah mulai drift; ada provider layer lama yang dikomentari.
- Beberapa model masih belum konsisten typing field (contoh timestamp/string/list) sehingga berisiko inkonsistensi data lintas fitur.
- Belum ditemukan file Firestore rules yang versioned di repo (hanya storage rules yang ada).

Referensi:
- [lib/main.dart](lib/main.dart)
- [lib/core/routers/go_router_provider.dart](lib/core/routers/go_router_provider.dart)
- [lib/presentation/auth/pages/welcome_page.dart](lib/presentation/auth/pages/welcome_page.dart)
- [lib/core/main/data/models](lib/core/main/data/models)
- [firebase.json](firebase.json)
- [storage.rules](storage.rules)

### 2.2 Web-ACONSIA (folder web-aconsia)

Observasi utama:
- Stack React + Vite + Tailwind, route dokter/admin/pasien sudah ada.
- State data saat ini dominan **localStorage seed demo**, belum production backend integration.
- Ini sangat bagus sebagai basis UI/UX, tapi belum siap langsung jadi production desktop app.

Referensi:
- [web-aconsia/package.json](web-aconsia/package.json)
- [web-aconsia/src/app/routes.tsx](web-aconsia/src/app/routes.tsx)
- [web-aconsia/src/app/App.tsx](web-aconsia/src/app/App.tsx)
- [web-aconsia/src/utils/seedDoctorData.ts](web-aconsia/src/utils/seedDoctorData.ts)

---

## 3) Product Scope Phase 2 (To-Be)

### 3.1 Scope Platform

#### A. Mobile Flutter (Pasien-only)
- Login/register pasien saja.
- Fitur edukasi, assignment, progress, quiz/chat tetap di mobile.
- Dokter/admin dilarang akses app mobile via guard role + custom claim.

#### B. Desktop App (Dokter + Admin)
- Dokter: manajemen pasien, approve, assign konten, monitoring progress, komunikasi.
- Admin: user lifecycle, konten governance, audit trail, reporting.
- Desktop app bisa online-first, optional offline draft terbatas.

### 3.2 Out of Scope (Phase 2)
- Integrasi HIS/EMR eksternal penuh.
- Multi-tenant hospital billing.
- Telemedicine/video consultation native.

---

## 4) Rekomendasi Arsitektur Jangka Panjang (Best Practice)

## Keputusan yang direkomendasikan

### Frontend Strategy

- **Pertahankan Flutter untuk mobile pasien.**
- **Gunakan web-aconsia sebagai basis UI desktop dokter/admin.**
- Packaging desktop:
  - **Utama:** Web app + deploy internal (paling cepat stabil).
  - **Opsional installable desktop:** Bungkus dengan **Tauri** (lebih ringan dari Electron).

Kenapa ini paling cocok:
1. UI desktop Anda sudah ada di web-aconsia (hemat waktu besar).
2. Mobile pasien sudah stabil di Flutter (tidak perlu rewrite).
3. Backend bisa disatukan di Firebase (single source of truth).
4. Tauri memungkinkan distribusi app desktop tanpa memaksa rewrite ke Flutter desktop.

### Backend Strategy

- Firebase Auth + Firestore tetap core.
- Tambah **Custom Claims** (`role`, `hospitalId`, `permissions`).
- Tambah **Cloud Functions** untuk proses sensitif:
  - assign pasien ↔ dokter,
  - update score agregat,
  - audit log immutable,
  - admin actions.
- Security rules role-based + tenant-scoped.

---

## 5) PRD Detail

### 5.1 Personas & Goal

1. **Pasien (Mobile)**
   - Tujuan: paham prosedur anestesi pra operasi.
2. **Dokter (Desktop)**
   - Tujuan: edukasi pasien terarah dan terpantau.
3. **Admin (Desktop)**
   - Tujuan: governance, keamanan, pelaporan.

### 5.2 KPI

- % pasien mencapai skor pemahaman ≥ 80 sebelum tindakan.
- Median waktu dari registrasi hingga approved.
- % assignment selesai sebelum jadwal operasi.
- Error rate auth/rules < 1%.
- Audit event coverage 100% untuk aksi admin/dokter kritikal.

### 5.3 Functional Requirements (Ringkas)

#### Mobile Pasien
- FR-M1: pasien dapat register/login/logout.
- FR-M2: pasien lihat assignment konten terurut.
- FR-M3: pasien progres membaca + quiz/chat tersimpan.
- FR-M4: pasien menerima notifikasi update assignment.

#### Desktop Dokter
- FR-D1: dokter login & lihat panel pasien ter-assign.
- FR-D2: approve pasien dan set teknik anestesi.
- FR-D3: assign/reassign konten, monitor progres real-time.
- FR-D4: melihat hasil quiz + ringkasan pemahaman.

#### Desktop Admin
- FR-A1: kelola akun dokter/admin.
- FR-A2: moderation konten dan publikasi.
- FR-A3: melihat laporan operasional.
- FR-A4: audit trail tak dapat diubah dari UI.

### 5.4 Non-Functional Requirements

- NFR-1: p95 load dashboard < 2.5s (desktop LAN/internet normal).
- NFR-2: RBAC strict, least privilege.
- NFR-3: semua mutasi kritikal lewat function terautentikasi.
- NFR-4: observability (error logging + action logs).
- NFR-5: backup/restore prosedur terdokumentasi.

---

## 6) Firestore v2 Design (Perubahan yang Direkomendasikan)

> Tujuan: stabilkan skema, support role admin, dan siap scale.

## 6.1 Collection Utama

1. `users/{uid}`
- `email`, `displayName`
- `role`: `pasien | dokter | admin`
- `status`: `active | suspended | invited`
- `hospitalId`
- `isProfileCompleted`
- `createdAt`, `updatedAt`, `lastLoginAt`

2. `dokter_profiles/{uid}`
- profil profesional + metadata verifikasi.

3. `pasien_profiles/{uid}`
- data identitas + medis dasar + `assignedDokterId`.

4. `konten/{kontenId}`
- metadata konten + owner + publish state.

5. `konten/{kontenId}/sections/{sectionId}`
- **Rekomendasi pindah dari top-level `konten_sections` ke subcollection** untuk query locality.

6. `assignments/{assignmentId}`
- relasi pasien-konten-dokter + status + progress ringkas.

7. `reading_sessions/{sessionId}`
- event aktivitas membaca (opsional TTL/archive).

8. `quiz_results/{resultId}`
- skor detail + insight.

9. `chat_sessions/{sessionId}` + `chat_sessions/{sessionId}/messages/{messageId}`
- **Rekomendasi pindah message jadi subcollection** agar index dan access control lebih mudah.

10. `notifications/{notificationId}`
- notifikasi user.

11. `admin_audit_logs/{logId}`
- actor, action, target, before/after hash, timestamp.

## 6.2 Tambahan yang Wajib

- `hospitals/{hospitalId}` untuk future multi-hospital.
- `role_permissions/{role}` (opsional, jika policy dinamis).

## 6.3 Indexing Strategy (contoh)

- assignments by `pasienId + status + updatedAt desc`
- assignments by `assignedBy + status + updatedAt desc`
- quiz_results by `pasienId + completedAt desc`
- chat_sessions by `dokterId/pasienId + lastMessageAt desc`

---

## 7) Security & Access Control

## 7.1 Auth
- Firebase Auth + email/password.
- Custom claims dipakai sebagai sumber role final.
- Dokumen `users.role` tetap ada untuk query UI, tapi validasi rules mengacu claims.

## 7.2 Firestore Rules Policy

- Pasien:
  - read/write profil sendiri (field whitelist).
  - read assignment miliknya.
  - write progress miliknya via endpoint aman (disarankan lewat function untuk event penting).

- Dokter:
  - read pasien yang memang di-assign ke dia.
  - create/update assignment hanya untuk pasien dalam scope.
  - read quiz result pasien scope-nya.

- Admin:
  - akses governance collection terbatas.
  - tindakan sensitif via callable function + audit.

## 7.3 Audit & Compliance
- Semua aksi admin dan aksi dokter kritikal -> `admin_audit_logs`.
- Simpan `requestId`, `ip/device` (jika tersedia), `actorUid`, `actionType`.

---

## 8) Rencana Konversi web-aconsia -> Desktop Production

## 8.1 Gap yang harus ditutup

Saat ini web-aconsia masih demo-centric (localStorage). Untuk production:
1. Ganti localStorage auth menjadi Firebase Auth.
2. Ganti seed data ke Firestore query real.
3. Tambah route guards by role.
4. Tambah API service layer + repository pattern.
5. Tambah error boundary, loading skeleton, dan telemetry.

## 8.2 Blueprint Teknis

Struktur target (web-aconsia):
- `src/core/auth` (session, claims, guards)
- `src/core/firebase` (init, firestore converters)
- `src/modules/admin/*`
- `src/modules/doctor/*`
- `src/shared/ui/*`
- `src/shared/services/*` (notification, audit logger)

## 8.3 Packaging Desktop

Tahap 1 (wajib): deploy sebagai web desktop-first.
Tahap 2 (opsional): Tauri wrapper untuk installer `.dmg/.exe`.

Catatan:
- Jika tim ingin 1 codebase penuh Flutter, itu memungkinkan, tapi effort rewrite UI web-aconsia cukup besar.

---

## 9) Implementation Plan (Detail)

## Phase 0 - Discovery & Alignment (1 minggu)
- Finalisasi scope role/platform.
- Freeze data contract v2.
- Definisikan acceptance criteria per modul.

Deliverables:
- PRD final (dokumen ini).
- ERD + RBAC matrix.

## Phase 1 - Backend Foundation (2 minggu)
- Implement custom claims & admin invitation flow.
- Tambah Firestore collections baru (`admin_audit_logs`, `hospitals` minimal seed).
- Tulis Firestore rules v2 + test emulator.
- Tambah Cloud Functions untuk aksi sensitif.

Deliverables:
- rules + functions + emulator tests lulus.

## Phase 2 - Mobile Hard Split (1-2 minggu)
- Hide/remove login/register dokter dari mobile.
- Terapkan guard pasien-only di mobile route.
- Migrasi screen yang masih dokter ke desktop ownership.

Deliverables:
- APK pasien-only.

## Phase 3 - Desktop App Core (3-4 minggu)
- Refactor web-aconsia dari localStorage ke Firebase service.
- Implement auth dokter/admin + route guard.
- Integrasi dashboard dokter dan admin ke Firestore real data.

Deliverables:
- Desktop web app MVP internal.

## Phase 4 - Workflow & Quality (2-3 minggu)
- Monitoring progress real-time.
- Audit trail UI + export laporan.
- Hardening error handling, loading, empty states.
- UAT dengan data staging.

Deliverables:
- Release candidate.

## Phase 5 - Desktop Packaging (opsional, 1-2 minggu)
- Tauri integration.
- Build pipeline installer Mac/Windows.
- Smoke test distribusi internal.

Deliverables:
- Installer desktop.

---

## 10) Migration Plan Firestore (Aman)

1. Tambah field/collection baru tanpa memutus lama.
2. Backfill script (admin SDK) untuk data lama:
   - normalisasi role,
   - isi `hospitalId` default,
   - normalisasi timestamps.
3. Aktifkan rules v2 bertahap (staging -> canary -> prod).
4. Cutover frontend desktop ke collection baru.
5. Hapus field legacy setelah freeze period.

Rollback:
- simpan snapshot sebelum migrasi.
- toggle feature flag pada frontend.

---

## 11) Risks & Mitigations

1. **Drift model antara kode dan Firestore**
- Mitigasi: schema contract tunggal + converter test.

2. **Rules terlalu longgar/ketat**
- Mitigasi: emulator tests per role wajib di CI.

3. **Desktop masih demo logic**
- Mitigasi: phase refactor service layer dulu, baru feature.

4. **Performa query dashboard**
- Mitigasi: composite index + agregasi via function.

5. **Konflik dua stack frontend (Flutter + React)**
- Mitigasi: backend contract-first + design system token konsisten.

---

## 12) Acceptance Criteria Ringkas

- Mobile hanya pasien (UI, route, rule, claim).
- Desktop login role dokter/admin berjalan dari Firebase Auth.
- Semua dashboard desktop membaca Firestore (bukan localStorage).
- Audit log tercatat untuk aksi kritikal.
- Rules emulator test pass untuk pasien/dokter/admin.
- Tidak ada P0/P1 bug pada UAT akhir.

---

## 13) Prioritas Eksekusi (Rekomendasi Praktis)

1. Finalkan kontrak data + rules.
2. Split role mobile vs desktop.
3. Refactor web-aconsia auth/data layer.
4. Integrasi dashboard dokter, lalu admin.
5. Baru pertimbangkan packaging desktop installer.

---

## 14) Pertanyaan Kunci yang Perlu Anda Putuskan (Agar Eksekusi Cepat)

1. Desktop akan dipakai internal rumah sakit (web browser) dulu, atau langsung wajib installer?
2. Admin akan 1 level saja atau multi-level (super-admin vs operator)?
3. Scope data medis sensitif apa saja yang boleh tampil di admin?
4. Target pertama rilis: macOS saja atau macOS+Windows?

---

## 15) Kesimpulan

Dengan kondisi kode saat ini, jalur paling efektif dan aman jangka panjang adalah:

- **Flutter tetap untuk pasien mobile**.
- **web-aconsia dijadikan desktop dokter/admin** dengan refactor ke Firebase production.
- **Firestore v2 + RBAC + audit trail** sebagai pondasi skalabilitas dan keamanan.

Ini memberi kecepatan delivery terbaik tanpa mengorbankan maintainability.

---

## Lampiran Eksekusi Teknis

Dokumen operasional lanjutan:

- [PHASE_2_RBAC_MATRIX.md](PHASE_2_RBAC_MATRIX.md)
- [FIRESTORE_V2_MIGRATION_PLAYBOOK.md](FIRESTORE_V2_MIGRATION_PLAYBOOK.md)
- [DESKTOP_CONVERSION_IMPLEMENTATION_PLAN.md](DESKTOP_CONVERSION_IMPLEMENTATION_PLAN.md)
- [firestore.rules](firestore.rules)
- [firestore.indexes.json](firestore.indexes.json)

# UI Parity Implementation Plan (Referensi React `web-aconsia/src/app`)

Dokumen ini menjadi rencana eksekusi resmi untuk menyamakan UI Flutter dengan referensi React terbaru di `web-aconsia/src/app`.

## 1. Keputusan Referensi

- Referensi desain utama: `web-aconsia/src/app/...` (React terbaru).
- Tujuan: parity visual dan UX semaksimal mungkin pada Flutter app.
- Prinsip: **token -> komponen -> halaman -> QA parity**.
- Scope platform:
  - Flutter mobile: hanya **dokter + pasien**.
  - Web React: **dokter + admin**.
  - Admin surface tidak diimplementasikan pada Flutter.

## 2. Hasil Audit (Status Terkini)

### 2.1 Ringkasan

- Status global: **masih belum parity penuh**, tetapi fondasi utama sudah terpasang.
- Gap terbesar saat ini:
  1. Sistem desain global (token, warna semantik, radius, shadow, spacing).
  2. Komponen dasar belum seragam (button/input/card/footer/header).
  3. Struktur layout per halaman belum konsisten dengan pola React.
  4. Belum ada mekanisme visual regression parity.

### 2.2 Halaman yang Sudah Ditangani

- Auth:
  - `welcome_page.dart` -> diarahkan ke struktur `LandingPage.tsx`.
  - `login_dokter_page.dart`, `login_pasien_page.dart`, `forgot_password_page.dart` -> shell auth baru lebih konsisten.
  - `splash_page.dart` -> visual awal diselaraskan.
- Branding:
  - Logo web sudah dipakai di Flutter (`assets/logo/aconsia_logo.png`), bukan placeholder huruf.
- Foundation UI:
  - `lib/core/ui/tokens/ui_palette.dart`
  - `lib/core/ui/components/aconsia_surface.dart`
  - `lib/core/ui/components/aconsia_brand_logo.dart`
- Doctor surface:
  - `dokter/home/home_page.dart` + `dashboard_summary_widget.dart` diselaraskan ke arah dashboard web.
  - `dokter/konten/konten_page.dart` dan `dokter/profile/profile_page.dart` sudah masuk shell baru.
  - `main_dokter_page.dart` (bottom nav) sudah diseragamkan.
- Patient surface:
  - `home_pasien_page.dart`, `ai_recommendation_widget.dart`
  - `konten_pasien_page.dart`, `profile_pasien_page.dart`
  - `detail_konten_page.dart` (refactor struktur materi + section cards)
  - `quiz_chat_ai_page.dart`, `quiz_result_page.dart`
  - `chat_ai_page.dart`, `hasil_chat_ai_page.dart` (flow lama juga sudah dirapikan)
  - `main_pasien_page.dart` (bottom nav) sudah diseragamkan.
- Build blocker utama:
  - AGP dinaikkan ke `8.2.1`.
  - Penanganan `.env` lebih aman (tidak crash saat kosong/tidak ada).
  - Asset path wajib disiapkan (`assets/logo`, `assets/navbar`).

## 3. Matriks Mapping Halaman React -> Flutter

### 3.1 Public/Auth

1. React `LandingPage.tsx` -> Flutter `welcome_page.dart` (in progress, parity menengah).
2. React `UnifiedLoginPage.tsx` -> Flutter `login_dokter_page.dart` + `login_pasien_page.dart` (in progress, parity menengah-rendah).
3. React `DesktopPatientRedirectPage.tsx` -> Flutter belum ada padanan langsung (perlu keputusan produk karena Flutter adalah mobile app pasien).

### 3.2 Doctor Surface

1. React `doctor/DoctorDashboardNew.tsx` -> Flutter `dokter/home/home_page.dart`.
2. React `doctor/DoctorPatients.tsx` -> Flutter `dokter/home/list_active_pasien_page.dart` + `detail_pasien_page.dart`.
3. React `doctor/DoctorContent.tsx` -> Flutter `dokter/konten/konten_page.dart` + `add_konten_page.dart` + `edit_konten_page.dart`.
4. React `doctor/DoctorProfile.tsx` -> Flutter `dokter/profile/profile_page.dart` + `edit_profile_page.dart`.
5. React `doctor/DoctorRegistration.tsx` -> Flutter `register_dokter_page.dart`.
6. React `doctor/PatientApprovalNew.tsx` -> Flutter belum setara penuh.
7. React `doctor/DoctorMonitoring.tsx` -> Flutter belum setara penuh.

### 3.3 Admin Surface (React only)

1. React `admin/EnhancedAdminDashboard.tsx` -> belum ada UI Flutter setara.
2. React `admin/AuditTrailPage.tsx` -> belum ada UI Flutter setara.
3. React `admin/ReportsPage.tsx` -> belum ada UI Flutter setara.

Catatan scope: item admin di atas **tetap web-only** dan tidak masuk backlog parity Flutter.

### 3.4 Patient Surface (Flutter mobile scope)

Banyak halaman pasien Flutter sudah ada, tetapi belum parity visual terhadap bahasa desain React terbaru (spacing, hierarchy, card, empty-state, footer, dll).

## 4. Arsitektur Implementasi (Wajib)

## 4.1 Layer A: Design Tokens

Buat token tunggal di Flutter:

1. Color semantic: slate, blue, emerald, surface, border, muted.
2. Radius scale: 10/12/16/20.
3. Spacing scale: 4/8/12/16/20/24/32/40/48.
4. Elevation/shadow presets.
5. Typography scale untuk heading/body/caption/button.

Output:

- `lib/core/ui/tokens/ui_colors.dart`
- `lib/core/ui/tokens/ui_spacing.dart`
- `lib/core/ui/tokens/ui_radius.dart`
- `lib/core/ui/tokens/ui_typography.dart`

## 4.2 Layer B: Reusable UI Components

Bangun komponen reusable setara React primitives:

1. `AuthScaffold` (back button, centered container, footer).
2. `AconsiaFooter` (copyright + security line).
3. `AconsiaCard` (border + radius + shadow konsisten).
4. `AconsiaPrimaryButton` dan `AconsiaOutlineButton`.
5. `AconsiaTextField` (label, helper, error state).
6. `Status/AlertBanner` untuk error/success/info.

Output:

- `lib/core/ui/components/...`

## 4.3 Layer C: Page Composition

Semua page dibangun dari komponen layer B, bukan inline styling acak.

## 5. Rencana Eksekusi Bertahap

### Phase 1 - Foundation (2-3 hari)

1. Finalisasi token sistem.
2. Komponen dasar reusable.
3. Refactor auth pages agar consume token+components.
4. Buat guideline parity singkat.

Definition of Done:

1. Semua halaman auth memakai komponen layer B.
2. Tidak ada hard-coded style besar di halaman auth.
3. Screenshot auth setara referensi dalam batas toleransi.

### Phase 2 - Doctor Core Pages (4-6 hari)

1. `home_page.dart` + summary cards.
2. list pasien + detail pasien.
3. konten list/add/edit.
4. profile + edit profile.

Definition of Done:

1. Hierarki visual, spacing, CTA placement setara React doctor pages.
2. Semua loading/error/empty states rapi.

### Phase 3 - Patient Core Pages (4-7 hari)

1. home pasien.
2. konten/detail/chat/quiz/result.
3. profile/edit profile.
4. notifikasi dan assignment.

Definition of Done:

1. Konsistensi shell, card system, typografi, button hierarchy.
2. Tidak ada halaman pasien dengan style legacy.

Status: **in progress (major progress)**. Halaman inti pasien sudah banyak bermigrasi, namun masih perlu pemerataan di halaman turunan dan edge-state.

### Phase 4 - Missing Feature Surfaces (opsional, keputusan produk)

1. Admin UI di Flutter (jika memang diinginkan).
2. Doctor monitoring + patient approval parity penuh.

Definition of Done:

1. Route + UI + state management + role guard jelas.

### Phase 5 - QA & Stabilization (2-3 hari)

1. Visual regression snapshot.
2. Smoke test route utama.
3. Performance pass (jank/frame skip).
4. Final polish spacing/typography.

## 6. Standar QA Parity (Wajib)

Per halaman, checklist berikut wajib lulus:

1. Struktur layout sama (header/body/footer).
2. Jarak antar elemen (spacing) konsisten.
3. Warna tombol/teks/border sesuai semantic token.
4. Radius + shadow sesuai standar.
5. Ukuran font dan weight sesuai hierarchy.
6. Empty/error/loading states ada dan konsisten.
7. Mobile small screen tidak overflow.

## 7. Risiko & Mitigasi

1. Risiko: Flutter saat ini campuran style lama dan baru.
   - Mitigasi: wajib migrasi bertahap via component layer.
2. Risiko: parity 100% sulit jika behavior web berbeda konteks platform.
   - Mitigasi: parity visual + interaction prioritas, behavior beda didokumentasikan.
3. Risiko: regressions karena refactor besar.
   - Mitigasi: phase-based rollout + analyze/build/run tiap modul.

## 8. Prioritas Implementasi Berikutnya (Immediate Next Sprint)

1. Finalisasi parity patient flow turunan:
   - assignment list/detail, notification list, all recommendation page, edit profile pasien.
2. Hilangkan style legacy di widget granular:
   - tag widgets, konten cards, profile form sections, dialog styles.
3. Validasi parity lintas device:
   - ukuran kecil (Android compact) + tablet portrait.
4. Perkuat komponen reusable:
   - tambah token spacing/typography/radius terpisah agar konsisten menyeluruh.
5. QA parity checklist per-route + dokumentasi screenshot before/after.

## 9. Acceptance Criteria Final (Project-Level)

1. 90%+ halaman utama punya parity visual tinggi terhadap referensi React.
2. Semua halaman utama memakai design token dan reusable components.
3. Tidak ada style legacy dominan pada halaman utama.
4. QA checklist lulus untuk public/auth + doctor + patient core flows.

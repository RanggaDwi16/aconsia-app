# ACONSIA Mobile Reflection Plan (Web-First, Lib-First)

Dokumen ini menjadi rencana implementasi resmi untuk menyelaraskan aplikasi mobile (`lib/`) dengan produk web ACONSIA terbaru.

## 1. Keputusan Arsitektur

1. Single source of truth produk: `web-aconsia` (fitur, rules bisnis, alur role).
2. Implementasi mobile: tetap di folder `lib/` (Flutter), bukan membuat codebase mobile baru di folder lain.
3. Role target mobile tahap ini: `pasien` dan `dokter`.
4. Role `admin` tetap fokus di web desktop.

## 2. Kondisi Awal Saat Ini

1. Web role dokter/admin sudah aktif dengan route modern.
2. Web pasien lama belum dijadikan flow production aktif.
3. Flutter (`lib/`) masih membawa struktur lama, namun sudah punya auth + dashboard pasien/dokter.
4. Sebelum plan ini, akses dokter di Flutter sempat di-hard redirect ke welcome (mode pasien-only).

## 3. Tujuan Implementasi

1. Menjadikan Flutter mobile sebagai refleksi UI/UX dari web untuk role pasien + dokter.
2. Menyamakan data contract Firestore antara web dan mobile.
3. Menghindari duplikasi logic dan dummy flow.
4. Menyediakan jalur scale-up ke release Android/iOS tanpa rework besar.

## 4. Scope Pekerjaan

### In-Scope

1. Alignment route dan auth mobile untuk role pasien+dokter.
2. Penyesuaian UI mobile mengikuti web aktif.
3. Sinkronisasi model data Firestore mobile dengan web.
4. QA lintas role untuk login, register, dashboard utama, dan profile.

### Out-of-Scope (sementara)

1. Admin panel full di Flutter.
2. Migrasi total semua halaman legacy sekaligus dalam satu sprint.
3. Fitur baru non-prioritas (mis. modul tambahan yang belum aktif di web production).

## 5. Roadmap Eksekusi

## Phase A - Fondasi Navigasi & Role Gate (lib)

1. Aktifkan kembali akses dokter di router Flutter.
2. Ubah welcome agar role pasien + dokter tersedia.
3. Pertahankan admin sebagai desktop-only message di mobile.
4. Pastikan sesi login mengarahkan ke home role masing-masing.

Deliverable:

1. Welcome mobile baru (dua role).
2. Redirect logic role-based yang konsisten.

## Phase B - Data Contract Unification

1. Tetapkan skema dokumen Firestore final untuk:
   - `users`
   - `dokter_profiles`
   - `pasien_profiles`
   - `konten`
   - `reading_sessions`
   - `quiz_results`
2. Samakan field wajib web vs mobile.
3. Audit semua mapper model Flutter agar kompatibel.
4. Tambah fallback aman untuk field opsional.

Deliverable:

1. Tabel contract field per koleksi.
2. Update model + datasource di `lib/`.

Catatan kemungkinan update DB:

1. Mungkin diperlukan backfill field lama agar terbaca konsisten di mobile.
2. Jika ada mismatch role string (`dokter` vs `doctor`), perlu normalisasi.

## Phase C - UI Reflection Pasien (Mobile)

1. Prioritaskan halaman core pasien:
   - Dashboard
   - Materi edukasi
   - Quiz/assessment
   - Profil
2. Refleksikan copywriting, state, dan CTA dari web aktif.
3. Pastikan semua aksi utama membaca/menulis Firestore production.

Deliverable:

1. Pasien flow mobile parity v1 dengan web.

## Phase D - UI Reflection Dokter (Mobile)

1. Prioritaskan halaman core dokter:
   - Dashboard
   - Daftar pasien
   - Approval pasien
   - Konten edukasi
   - Profil
2. Optimasi mobile layout untuk list panjang dan form kompleks.
3. Pastikan statistik berasal dari data real, bukan lokal dummy.

Deliverable:

1. Dokter flow mobile parity v1 dengan web.

## Phase E - Stabilization & Hardening

1. Validasi error handling auth dan network.
2. Verifikasi rule Firestore lintas role.
3. Tambah regression checklist untuk role pasien/dokter.
4. Bersihkan kode legacy yang tidak lagi dipakai (bertahap dan aman).

Deliverable:

1. Build stabil, flow utama lolos QA.

## 6. Strategi Migrasi Aman

1. Gunakan pendekatan strangler: halaman baru diprioritaskan, legacy dipensiunkan bertahap.
2. Hindari big-bang rewrite agar risiko regressions rendah.
3. Tiap phase wajib punya checkpoint:
   - lint/analyze
   - smoke test login
   - smoke test role navigation

## 7. Risiko & Mitigasi

1. Risiko: mismatch field web-mobile.
   - Mitigasi: contract schema + mapper fallback.
2. Risiko: role drift (`dokter/doctor`).
   - Mitigasi: normalisasi role di service layer.
3. Risiko: legacy page masih ikut terbaca router.
   - Mitigasi: audit route aktif setiap phase.

## 8. Definisi Selesai (Definition of Done)

1. Mobile (`lib/`) punya flow pasien+dokter yang berjalan real data.
2. Tidak ada ketergantungan dummy pada flow aktif.
3. Sesi login stabil dan redirect benar per role.
4. QA checklist lintas role terpenuhi.

## 9. Langkah Lanjutan Setelah Dokumen Ini

1. Jalankan Phase B (data contract audit) sebagai prioritas berikutnya.
2. Lanjut Phase C dan D paralel per modul.
3. Laporkan kebutuhan update Firestore/Rules segera saat ditemukan gap.

## 10. Progress Eksekusi (Update 2026-04-03)

1. Phase A selesai:
   - Router mobile role dokter sudah diaktifkan kembali.
   - Welcome mobile sudah mendukung masuk sebagai dokter + pasien.
2. Phase B (sebagian besar) selesai:
   - Role normalizer ditambahkan di mobile.
   - Mapper user/profile diselaraskan untuk kompatibilitas web-mobile.
   - Script normalisasi kontrak Firestore dibuat:
     - `functions/scripts/normalize-mobile-web-contract.js`
     - `npm run db:normalize-contract` (dry-run/apply)
   - Normalisasi data sudah dijalankan ke project `aconsia` (apply).
3. Phase C dan D (parity UI mobile) berjalan aktif:
   - Halaman login dokter/pasien sudah diselaraskan ke pola UI web (card layout + state error + CTA jelas).
   - Dashboard mobile dokter/pasien sudah ditingkatkan untuk meniru hirarki informasi web (banner status, quick action, KPI card).
   - Halaman konten dokter/pasien sudah ditingkatkan (gradient background, info banner, heading parity).
   - Halaman profil dokter/pasien sudah ditingkatkan (header profile card, status chip, konsistensi visual dengan flow web).
4. Quality gate terbaru:
   - `flutter analyze` untuk halaman konten + profil dokter/pasien: `No issues found`.
5. Lanjutan parity flow dokter (pasien/review):
   - Halaman daftar pasien dokter ditingkatkan: search aktif, banner ringkasan pasien, refresh state.
   - Halaman detail pasien ditingkatkan: profile header card, loading/error state yang jelas, dan layout konsisten dengan page profile.
   - Halaman input informasi medis pasien ditingkatkan agar konsisten dengan gaya web-reflection.
   - Komponen item list pasien ditingkatkan ke card style modern + affordance navigasi.
   - `flutter analyze` pada file flow pasien dokter terbaru: `No issues found`.
6. Lanjutan parity review/approval dokter:
   - Home dokter kini menampilkan ringkasan `Menunggu Review` vs `Siap Edukasi` berbasis data medis real pasien.
   - Quick action diperjelas menjadi `Review Pasien Baru`.
   - List pasien dokter kini mendukung filter mode (`Semua`, `Menunggu Review`, `Siap Edukasi`) tanpa data dummy.
   - Detail pasien kini menampilkan banner status review + CTA dinamis (`Lengkapi` / `Perbarui` informasi medis).
   - `flutter analyze` untuk file home/list/detail pasien dokter: `No issues found`.
7. Lanjutan parity status real-time + performa dokter:
   - Provider performa dokter berbasis Firestore (`quiz_results`) ditambahkan di mobile.
   - Home dokter kini menampilkan kartu `Performa Dokter` (rata-rata nilai, total quiz, dan butuh follow-up).
   - Home dokter kini menampilkan kartu `Status Pasien Real-Time` dengan daftar pasien yang sedang membaca (nama + jam mulai).
   - Semua metrik memakai data real Firestore, bukan dummy.
   - `flutter analyze` file provider + halaman home/list/detail terkait: `No issues found`.
8. Lanjutan parity dashboard pasien:
   - Provider ringkasan belajar pasien berbasis Firestore ditambahkan (`pasien_learning_summary_provider`).
   - Home pasien kini menampilkan kartu `Status Belajar Saat Ini` (progress, selesai, belum selesai) dan `Insight Quiz` (nilai rata-rata + quiz terakhir).
   - Refresh dashboard pasien kini ikut invalidate provider ringkasan belajar agar data tetap sinkron.
   - Semua insight memakai data real (`konten` + `quiz_results`) tanpa dummy.
   - `flutter analyze` untuk provider + halaman home pasien: `No issues found`.
9. Lanjutan parity profil pasien:
   - Halaman profil pasien kini memiliki tab `Informasi` dan `Performa`.
   - Tab `Performa` menampilkan ringkasan progress belajar dan hasil quiz terbaru berbasis provider real Firestore.
   - Refresh profil pasien kini ikut menyegarkan provider ringkasan performa.
   - Halaman edit profil pasien dirapikan (hapus debug print/import tidak terpakai + perbaikan assignment tanggal lahir).
   - `flutter analyze` untuk profile/home pasien terkait: `No issues found`.
10. Final consistency polish pass:
   - Dashboard dokter kini memakai background gradient yang konsisten dengan halaman dokter lain.
   - Copywriting dashboard dokter dirapikan (`Daftar Pasien Sakit` menjadi `Total Pasien`).
   - Komponen alert pasien membaca ditingkatkan (visual lebih konsisten + action tap ke daftar pasien).
   - Halaman edit profil pasien diselaraskan visualnya (header card + gradient background).
   - `flutter analyze` untuk file polish pass: `No issues found`.
11. QA hardening pass (auth flow):
   - Error handling Firebase Auth dinormalisasi agar pesan login/register/forgot lebih jelas dan konsisten di bahasa Indonesia.
   - Validasi input register dokter dan register pasien ditingkatkan (nama, format email, panjang password, konfirmasi password).
   - Validasi input forgot password ditingkatkan (required + format email).
   - Copywriting auth dirapikan untuk konsistensi.
   - `flutter analyze` untuk file auth terkait: `No issues found`.
12. QA hardening pass (session & route guard):
   - Router kini memakai global redirect guard berbasis session (`uid`, `role`, `isProfileCompleted`) untuk mencegah akses silang role.
   - Akses route publik/auth kini otomatis diarahkan ke halaman target role saat user sudah login.
   - Akses route protected kini otomatis kembali ke welcome bila session tidak valid.
   - Splash flow diperbaiki (otomatis lanjut ke welcome) agar bootstrap route tidak macet.
   - `flutter analyze` untuk file router/splash/auth terkait: `No issues found`.
13. Final QA package:
   - Checklist QA manual end-to-end lintas role dokter/pasien dibuat.
   - Checklist mencakup auth, dashboard, konten, profil, quiz, session persistence, dan route guard.
   - Dokumen output: `MOBILE_E2E_QA_CHECKLIST.md`.

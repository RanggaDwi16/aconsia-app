# Phase 2 Release Checklist (Staging -> Production)

Tanggal: 31 Maret 2026

## 1) Pre-Release Gate (Wajib Lulus)

- [ ] CI `phase2-ci` hijau untuk PR terakhir
  - [ ] Job `Web Aconsia Build` sukses
  - [ ] Job `Functions + Rules Gate` sukses
- [ ] Build lokal desktop sukses (`web-aconsia`)
- [ ] Syntax check functions sukses (`functions/index.js`)
- [ ] Tidak ada error kritikal pada halaman aktif:
  - [ ] Landing desktop
  - [ ] Unified login desktop
  - [ ] Doctor dashboard + approval
  - [ ] Admin dashboard + reports + audit

## 2) Security Gate

- [ ] Rules terbaru sudah dipakai:
  - [ ] `users` lifecycle sensitif tidak bisa direct client write
  - [ ] `konten` moderation field tidak bisa direct client write
  - [ ] `admin_audit_logs` tetap immutable (`update/delete: false`)
- [ ] Sensitive action desktop sudah callable-only:
  - [ ] `assignPasienAnesthesia`
  - [ ] `approvePasienProfile`
  - [ ] `rejectPasienProfile`
  - [ ] `setUserLifecycleStatus`
  - [ ] `setKontenPublishStatus` (opsional bila mode Blaze/callable aktif)
  - [ ] Jika mode Spark/free: publish konten via direct Firestore admin + rules valid
- [ ] Claims role (`doctor/admin`) tervalidasi untuk akun uji
  - [ ] `users/{uid}.role` konsisten dengan role akun uji
  - [ ] Custom claim role sesuai (khusus admin: `role=admin`)
  - [ ] Setelah update claim, sudah diverifikasi dengan logout/login ulang

## 3) Data & Migration Gate

- [ ] Firestore index sinkron dengan source repo
- [ ] Tidak ada ketergantungan path aktif ke fallback localStorage
- [ ] Snapshot data staging sehat:
  - [ ] `pasien_profiles`
  - [ ] `users`
  - [ ] `konten`
  - [ ] `admin_audit_logs`

## 4) UAT Gate (Smoke E2E)

- [ ] Login dokter desktop sukses
- [ ] Login admin desktop sukses
- [ ] Pasien akses desktop diarahkan ke halaman mobile-only
- [ ] Dokter assign anestesi -> data pasien berubah -> audit log tercatat
- [ ] Dokter approve/reject pasien -> status pasien berubah -> audit log tercatat
- [ ] Admin suspend/activate user -> status user berubah -> audit log tercatat
- [ ] Admin publish/unpublish konten -> status konten berubah -> audit log tercatat
  - [ ] Jika gagal, jalankan runbook: `web-aconsia/docs/ADMIN_PUBLISH_INCIDENT_RUNBOOK.md`
- [ ] Export report/admin audit tetap berfungsi

## 5) Deployment Steps

1. Deploy Functions:
   - `firebase deploy --only functions`
   - Verifikasi `setKontenPublishStatus` tersedia di region target
2. Deploy Firestore Rules + Indexes:
   - `firebase deploy --only firestore:rules,firestore:indexes`
3. Deploy desktop web hosting (sesuai pipeline/project)
4. Verify post-deploy smoke test di environment target

## 6) Rollback Plan

- [ ] Tag release sebelum deploy production
- [ ] Simpan artefak build terakhir yang stabil
- [ ] Jika insiden kritikal:
  - rollback functions ke versi sebelumnya
  - rollback rules/indexes ke commit stabil terakhir
  - rollback deployment web ke artefak stabil

## 7) Monitoring 24 Jam Pertama

- [ ] Pantau error login desktop
- [ ] Pantau error callable (`permission-denied`, `invalid-argument`)
- [ ] Pantau error callable `setKontenPublishStatus` (`unauthenticated`, `permission-denied`, `not-found`)
- [ ] Pantau latensi fungsi moderation
- [ ] Pantau anomali audit logs (jumlah drop signifikan)

## Catatan Operasional

- Rules test lokal butuh JDK 21+ untuk Firestore emulator terbaru.
- CI sudah dikonfigurasi setup Java 21 otomatis pada workflow Phase 2.

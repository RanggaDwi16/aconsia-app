# Phase 2 Governance Policy

Tanggal berlaku: 31 Maret 2026

## 1. Tujuan

Menetapkan guardrail operasional agar arsitektur Phase 2 tetap konsisten:
- Mobile untuk pasien
- Desktop untuk dokter/admin
- Aksi sensitif lewat callable backend
- Audit trail immutable

## 2. Platform Scope Policy

1. Desktop (`web-aconsia`) hanya untuk role `doctor` dan `admin`.
2. Semua akses desktop pasien harus diarahkan ke halaman mobile-only.
3. Route/halaman legacy non-aktif dilarang diaktifkan ulang tanpa approval formal.

## 3. Security Enforcement Policy

1. Operasi sensitif berikut **wajib callable-only**:
   - approve/reject pasien
   - assign anestesi
   - suspend/activate user
   - publish/unpublish konten
2. Direct client write untuk field sensitif harus ditolak Firestore rules.
3. `admin_audit_logs` wajib immutable (`create-only`, no update/delete).

## 4. Change Management Policy

1. Semua perubahan Phase 2 wajib lewat Pull Request.
2. PR wajib lulus workflow CI `phase2-ci`.
3. Perubahan yang memengaruhi RBAC/rules/function harus:
   - memperbarui dokumen eksekusi
   - menambahkan/menyesuaikan test gate yang relevan

## 5. Release Governance

Sebelum deploy production, wajib:
- checklist release lengkap
- sign-off lintas fungsi (Product, Tech Lead, Security, Release Manager)
- rollback plan siap pakai

Referensi:
- [PHASE_2_RELEASE_CHECKLIST.md](PHASE_2_RELEASE_CHECKLIST.md)
- [PHASE_2_RELEASE_SIGNOFF_TEMPLATE.md](PHASE_2_RELEASE_SIGNOFF_TEMPLATE.md)
- [PHASE_2_POST_DEPLOY_VERIFICATION_MATRIX.md](PHASE_2_POST_DEPLOY_VERIFICATION_MATRIX.md)

## 6. Exception Process

Jika butuh pengecualian policy:
1. Ajukan justifikasi tertulis.
2. Cantumkan dampak risiko + mitigasi.
3. Butuh approval minimal Tech Lead + Security.
4. Pengecualian harus memiliki expiry date.

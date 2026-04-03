# Phase 2 Release Sign-off Template

Tanggal: ____ / ____ / ______
Environment: [ ] Staging  [ ] Production
Release ID / Tag: ______________________
Commit SHA: ____________________________

## A. Scope Sign-off

Ringkasan perubahan release:
- __________________________________________
- __________________________________________
- __________________________________________

Out of scope (tegas):
- __________________________________________
- __________________________________________

## B. Mandatory Quality Gates

- [ ] CI `phase2-ci` hijau pada commit release
- [ ] `web-aconsia` build sukses
- [ ] `functions/index.js` syntax check sukses
- [ ] Rules test lulus (CI/emulator)
- [ ] Tidak ada blocker severity P0/P1

## C. Security & RBAC Gates

- [ ] Desktop login hanya dokter/admin
- [ ] Desktop pasien ter-lockout ke halaman mobile-only
- [ ] Aksi sensitif berjalan callable-only:
  - [ ] assign anestesi
  - [ ] approve/reject pasien
  - [ ] suspend/activate user
  - [ ] publish/unpublish konten
- [ ] `admin_audit_logs` immutable tervalidasi

## D. Data Integrity Gates

- [ ] Rules + indexes deployed sesuai repo
- [ ] Tidak ada fallback localStorage pada path aktif
- [ ] Sampling data valid:
  - [ ] `users`
  - [ ] `pasien_profiles`
  - [ ] `konten`
  - [ ] `admin_audit_logs`

## E. UAT Gates (Minimum)

- [ ] Dokter login + lihat dashboard
- [ ] Dokter assign anestesi + audit log tercatat
- [ ] Dokter approve/reject pasien + audit log tercatat
- [ ] Admin buka dashboard/reports/audit
- [ ] Admin moderasi user lifecycle + audit log tercatat
- [ ] Admin moderasi publish konten + audit log tercatat

## F. Rollback Readiness

- [ ] Artefak release sebelumnya tersedia
- [ ] Langkah rollback terdokumentasi
- [ ] On-call owner siap 24 jam pertama

## G. Approval Signatures

Product Owner:
- Nama: ______________________
- Tanda tangan: ______________
- Waktu: _____________________

Tech Lead:
- Nama: ______________________
- Tanda tangan: ______________
- Waktu: _____________________

Security/Compliance:
- Nama: ______________________
- Tanda tangan: ______________
- Waktu: _____________________

Release Manager:
- Nama: ______________________
- Tanda tangan: ______________
- Waktu: _____________________

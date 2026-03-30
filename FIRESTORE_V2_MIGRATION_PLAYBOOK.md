# Firestore v2 Migration Playbook (Phase 2)

Dokumen eksekusi migrasi dari skema saat ini ke skema v2 lintas mobile + desktop.

## 1) Tujuan Migrasi

1. Menambahkan role `admin` end-to-end.
2. Menegaskan pemisahan platform:
   - mobile = pasien,
   - desktop = dokter/admin.
3. Menstabilkan struktur data untuk scale dan auditability.

---

## 2) Strategi Migrasi

Strategi: **expand -> backfill -> dual-read -> cutover -> contract**

1. **Expand**: tambah field/collection baru tanpa menghapus yang lama.
2. **Backfill**: isi data lama ke format baru.
3. **Dual-read**: frontend baca format lama+baru sementara.
4. **Cutover**: fitur utama pindah ke skema baru.
5. **Contract**: hapus dependensi ke struktur lama.

---

## 3) Persiapan

Checklist:
- [ ] Buat project Firebase staging terpisah.
- [ ] Snapshot backup Firestore production.
- [ ] Pastikan seluruh tim freeze schema change manual selama migrasi.
- [ ] Aktifkan emulator tests untuk rules.
- [ ] Siapkan feature flag `useFirestoreV2` pada frontend.

---

## 4) Perubahan Schema v2

### Wajib ditambahkan
- `users.role` menerima nilai: `pasien|dokter|admin`.
- `users.status`: `active|suspended|invited`.
- `users.hospitalId`.
- collection baru `admin_audit_logs`.
- collection baru `hospitals` (minimal default hospital).

### Reorganisasi bertahap
- `konten_sections` -> `konten/{kontenId}/sections`.
- `chat_messages` -> `chat_sessions/{sessionId}/messages`.

Catatan: reorganisasi dilakukan bertahap dan tidak memblokir operasi aktif.

---

## 5) Backfill Plan

## Batch A (users)

- Input: seluruh `users`.
- Aturan:
  - jika role kosong, infer dari profile (`dokter_profiles`/`pasien_profiles`).
  - isi `hospitalId` default (`hospital-default`).
  - isi `status='active'` jika kosong.

Validasi:
- 100% user punya role valid.
- 100% user punya hospitalId.

## Batch B (pasien_profiles)

- Tambah/normalisasi `assignedDokterId`.
- Normalisasi timestamp ke `Timestamp` Firestore.

## Batch C (konten + sections)

- Copy semua dokumen `konten_sections` ke subcollection baru.
- Tandai dokumen lama dengan `migrated=true`.

Validasi:
- jumlah section per konten sama sebelum/sesudah migrasi.

## Batch D (chat)

- Copy `chat_messages` ke subcollection `chat_sessions/{id}/messages` berdasarkan `sessionId`.
- Verifikasi urutan `createdAt` konsisten.

## Batch E (audit)

- Inisialisasi `admin_audit_logs`.
- Untuk aksi historis yang penting, buat event `migration_seed`.

---

## 6) Cutover Plan

### Step 1: Deploy rules & indexes v2
- Deploy [firestore.rules](firestore.rules)
- Deploy [firestore.indexes.json](firestore.indexes.json)
- Jalankan emulator test suite wajib.

### Step 2: Enable dual-read pada app
- Mobile & desktop membaca data v2 jika ada, fallback ke legacy.

### Step 3: Enable dual-write pada endpoint sensitif
- Assignment/chat baru ditulis ke struktur v2.
- Legacy write optional selama masa transisi (maks 2 minggu).

### Step 4: Switch read primary ke v2
- Setelah parity valid, matikan fallback legacy bertahap.

### Step 5: Cleanup
- Arsipkan collection legacy.
- Hapus query/index legacy yang tidak dipakai.

---

## 7) Rollback Plan

Trigger rollback jika:
- error auth/rules melonjak > 5%, atau
- data mismatch kritikal > 1% pada sampling.

Langkah rollback:
1. matikan flag `useFirestoreV2`.
2. rollback deploy frontend ke versi sebelumnya.
3. rollback rules ke versi stable terakhir.
4. restore data dari snapshot bila dibutuhkan.

---

## 8) Verification Script Checklist

- [ ] Compare count users by role sebelum/sesudah.
- [ ] Compare count assignments by pasien.
- [ ] Compare count messages per session.
- [ ] Random sample 100 pasien: progress & assignment parity.
- [ ] Random sample 50 chat sessions: order parity.

---

## 9) UAT Gates

Go-Live hanya jika:
- [ ] Semua test rules pass.
- [ ] p95 query dashboard stabil.
- [ ] Tidak ada P0/P1 issue.
- [ ] Tim dokter/admin UAT sign-off.

---

## 10) Tanggung Jawab

- Backend Lead: rules, functions, migration jobs.
- Frontend Mobile Lead: pasien-only guard + v2 read.
- Frontend Desktop Lead: auth desktop + v2 modules.
- QA Lead: parity tests + UAT sign-off.
- PM: release gate & rollback decision.

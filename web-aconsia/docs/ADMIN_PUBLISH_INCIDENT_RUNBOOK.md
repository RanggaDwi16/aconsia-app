# Admin Publish Incident Runbook

Dokumen ini dipakai saat aksi **Publish/Unpublish konten** di dashboard admin gagal.

Catatan mode saat ini:
- Publish/unpublish konten sudah menggunakan **direct Firestore write** dari admin web (tanpa Cloud Functions), agar tetap kompatibel dengan plan Spark.
- Aksi moderation lain bisa tetap memakai callable sesuai implementasi masing-masing.

## Gejala

- Tombol `Publish` / `Unpublish` ditekan tetapi status konten tidak berubah.
- Muncul pesan gagal di panel moderasi.
- Audit log aksi publish tidak bertambah.

## Tujuan Pemulihan

1. Pulihkan aksi publish agar kembali sukses.
2. Pastikan akar masalah terdokumentasi agar tidak berulang.

## Checklist Diagnostik Cepat

1. **Validasi session admin**
- Login menggunakan akun admin aktif.
- Lakukan logout lalu login ulang untuk refresh token.

2. **Validasi role pada user profile**
- Cek `users/{uid}.role` harus `admin`.
- Jika belum `admin`, perbaiki profile user dan ulangi login.

3. **Validasi custom claim role**
- Claim auth user harus berisi `role=admin`.
- Jika claim baru diubah, user wajib logout/login ulang.

4. **Validasi Firestore Rules**
- Pastikan rules terbaru sudah terdeploy.
- Rekomendasi deploy:
  - `firebase deploy --only firestore:rules --project aconsia`

5. **Validasi region function**
- Region function server harus sama dengan `VITE_FIREBASE_FUNCTIONS_REGION`.
- Default saat ini: `us-central1`.

6. **Validasi data konten target**
- Dokumen `konten/{kontenId}` harus ada.
- Nilai `status` harus valid (`draft` / `published`).

## Langkah Pemulihan Operasional

1. Jalankan script upgrade admin jika perlu:
- `cd functions`
- `node scripts/create-admin-user.js --email=<email-admin> --password=<password> --name="<nama>"`

2. Deploy ulang Firestore rules:
- `firebase deploy --only firestore:rules --project aconsia`

3. Logout/login ulang admin di web.

4. Uji ulang Publish pada 1 konten draft:
- Status berubah ke `published`.
- Audit log bertambah dengan action `PUBLISH_CONTENT`.

## Verifikasi Pasca-Insiden

1. Uji `Unpublish` ke `draft`.
2. Uji aksi moderation lain:
- `setUserLifecycleStatus`
- `approvePasienProfile`
- `rejectPasienProfile`
- `assignPasienAnesthesia`
3. Catat penyebab dan tindakan di log insiden tim.

## Catatan

- Error code seperti `permission-denied`, `unauthenticated`, `not-found`, dan `invalid-argument` sudah dipetakan di UI admin agar diagnosis lebih cepat.

# ACONSIA Mobile E2E QA Checklist

Checklist ini dipakai untuk final sign-off flow mobile (`lib/`) untuk role `dokter` dan `pasien`.

## 1. Persiapan Uji

1. Jalankan aplikasi mobile Flutter di environment QA/dev yang terhubung ke project Firebase ACONSIA.
2. Siapkan minimal 2 akun:
   - 1 akun dokter valid.
   - 1 akun pasien valid.
3. Pastikan data Firestore tidak kosong:
   - `users`
   - `dokter_profiles`
   - `pasien_profiles`
   - `konten`
   - `quiz_results` (opsional untuk uji performa)
4. Pastikan koneksi internet aktif.

## 2. Template Hasil Uji

Untuk setiap test case, isi:

1. Status: `PASS` / `FAIL`
2. Bukti: screenshot singkat
3. Catatan error (jika ada)

## 3. Auth Umum

### AUTH-01: Splash ke Welcome

1. Buka app dari kondisi cold start.
2. Tunggu splash selesai.

Expected:

1. Splash tampil singkat lalu otomatis ke halaman welcome.
2. Tidak stuck di splash.

### AUTH-02: Guard Belum Login

1. Logout dari akun aktif.
2. Coba akses route protected (jika ada deep link/path internal).

Expected:

1. User diarahkan ke welcome/login.
2. Tidak bisa masuk dashboard tanpa login.

### AUTH-03: Lupa Password Validasi

1. Buka halaman lupa password.
2. Uji input kosong, format email salah, lalu email valid.

Expected:

1. Empty email: muncul error wajib isi.
2. Format salah: muncul error format email.
3. Email valid: dialog sukses kirim reset password.

## 4. Role Dokter

### DOK-01: Login Dokter Sukses

1. Login dengan akun dokter valid.

Expected:

1. Login sukses.
2. Redirect ke `mainDokter` jika profil lengkap, atau `editProfile` jika belum.

### DOK-02: Login Dokter Gagal

1. Coba email/password salah.
2. Coba format email salah.

Expected:

1. Pesan error jelas dan tidak mentah.
2. Tidak crash.

### DOK-03: Register Dokter Validasi

1. Buka register dokter.
2. Uji semua validasi: nama kosong, email tidak valid, password < 6, konfirmasi tidak sama.
3. Uji registrasi valid.

Expected:

1. Semua validasi tampil sesuai kondisi.
2. Registrasi valid berhasil dan akun tercatat di `users`.

### DOK-04: Dashboard Dokter

1. Masuk dashboard dokter.
2. Cek ringkasan:
   - total konten
   - total pasien
   - menunggu review vs siap edukasi
   - performa dokter
   - status pasien real-time

Expected:

1. Semua kartu tampil stabil.
2. Data berasal dari Firestore (bukan teks dummy).
3. Pull-to-refresh bekerja.

### DOK-05: Review Pasien Baru

1. Masuk ke list pasien.
2. Uji filter: `Semua`, `Menunggu Review`, `Siap Edukasi`.
3. Uji search nama/no rekam medis.

Expected:

1. Filter bekerja sesuai status medis.
2. Search bekerja.
3. Tap item pasien membuka detail pasien.

### DOK-06: Detail Pasien dan Input Informasi Medis

1. Dari detail pasien, cek banner status.
2. Lanjut ke input informasi medis.
3. Simpan data medis pasien.

Expected:

1. Banner status berubah sesuai kelengkapan data.
2. Simpan berhasil, data tersimpan di `pasien_profiles`.

### DOK-07: Konten Dokter

1. Buka halaman manajemen konten.
2. Uji search konten.
3. Buka tambah konten (dan edit jika tersedia data).

Expected:

1. List konten tampil.
2. Search dan navigasi halaman konten berjalan.

### DOK-08: Profil Dokter

1. Buka profil dokter.
2. Uji refresh.
3. Buka edit profil dan simpan perubahan.

Expected:

1. Data profil tampil dan update.
2. Tidak ada error permission/firestore.

## 5. Role Pasien

### PAS-01: Login Pasien Sukses

1. Login dengan akun pasien valid.

Expected:

1. Login sukses.
2. Redirect ke `mainPasien` jika profil lengkap, atau `editProfilePasien` jika belum.

### PAS-02: Login Pasien Gagal

1. Uji email/password salah.
2. Uji format email salah.

Expected:

1. Pesan error jelas.
2. Tidak crash.

### PAS-03: Register Pasien Validasi

1. Buka register pasien.
2. Uji seluruh validasi input.
3. Uji registrasi valid.

Expected:

1. Validasi berjalan.
2. Registrasi sukses dan data user tersimpan.

### PAS-04: Dashboard Pasien

1. Buka dashboard pasien.
2. Cek kartu:
   - status belajar
   - insight quiz
   - rekomendasi AI

Expected:

1. Data tampil konsisten dengan Firestore (`konten`, `quiz_results`).
2. Pull-to-refresh berjalan.

### PAS-05: Konten Pasien

1. Buka daftar materi.
2. Uji search.
3. Buka detail konten.

Expected:

1. List konten tampil sesuai dokter yang ditugaskan.
2. Search bekerja.
3. Navigasi detail konten normal.

### PAS-06: Quiz Flow

1. Dari detail konten, jalankan quiz/chat ai sampai selesai.
2. Cek halaman hasil quiz.

Expected:

1. Hasil quiz tampil.
2. Data quiz tersimpan ke `quiz_results`.
3. Dashboard/profil pasien menampilkan perubahan performa.

### PAS-07: Profil Pasien

1. Buka profil pasien.
2. Cek tab `Informasi` dan `Performa`.
3. Buka edit profil lalu simpan.

Expected:

1. Dua tab tampil normal.
2. Performa sinkron dengan data quiz.
3. Perubahan profil tersimpan.

## 6. Guard dan Session

### SES-01: Persist Session

1. Login sebagai dokter/pasien.
2. Tutup app lalu buka kembali.

Expected:

1. User tidak kembali ke login jika session valid.
2. User diarahkan ke halaman role yang benar.

### SES-02: Cross-Role Route Guard

1. Login dokter, coba akses route khusus pasien.
2. Login pasien, coba akses route khusus dokter.

Expected:

1. User otomatis diarahkan ke home/profile role masing-masing.
2. Tidak bisa membuka halaman role lain.

### SES-03: Logout

1. Logout dari role dokter dan pasien.
2. Buka kembali app.

Expected:

1. Session bersih.
2. User kembali ke flow welcome/login.

## 7. Kriteria Sign-Off

Rilis mobile siap final jika:

1. Semua test case critical (`AUTH`, `DOK`, `PAS`, `SES`) berstatus `PASS`.
2. Tidak ada blocker terkait auth, route guard, dan write Firestore.
3. Tidak ada crash pada flow utama.
4. Issue minor terdokumentasi dengan workaround yang jelas.

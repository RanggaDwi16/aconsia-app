# Desktop Route QA Checklist

## A. Public Routes
- [ ] `/` menampilkan Landing Page.
- [ ] Klik tombol dokter/admin mengarah ke `/login`.
- [ ] `/login` tampil normal tanpa error route.
- [ ] `/doctor/login` tampil normal.
- [ ] `/register` mengarah ke halaman redirect desktop pasien.

## B. Auth Guard Behavior
- [ ] Akses `/admin` tanpa session redirect ke `/login`.
- [ ] Akses `/doctor` tanpa session redirect ke `/login`.
- [ ] Session role `doctor` bisa akses `/doctor/*`.
- [ ] Session role `doctor` ditolak di `/admin*` (redirect ke `/login`).
- [ ] Session role `admin` bisa akses `/admin*` dan `/doctor*`.

## C. Error Handling
- [ ] Route tidak valid (contoh `/abc-unknown`) menampilkan `NotFound`.
- [ ] Error route internal menampilkan `RouteErrorPage` (bukan default React Router error).
- [ ] Tombol "Kembali ke Beranda" pada error page berfungsi.
- [ ] Tombol "Muat Ulang Halaman" pada error page berfungsi.

## D. Firebase Readiness
- [ ] Jika env Firebase belum lengkap, form login menampilkan peringatan konfigurasi.
- [ ] Tombol login disabled saat env Firebase belum lengkap.
- [ ] Pesan error menyebut key env yang hilang.
- [ ] Setelah env lengkap, login bisa diproses normal.

## E. Regression Smoke
- [ ] Refresh berulang di `/login` tidak blank.
- [ ] Hard refresh di `/doctor/dashboard` setelah login tidak memunculkan 404.
- [ ] Build sukses: `npm run build`.

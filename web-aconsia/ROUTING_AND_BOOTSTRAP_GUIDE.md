# ACONSIA Desktop Routing and Bootstrap Guide

## 1) Tujuan Dokumen
- Menjelaskan arsitektur routing desktop web ACONSIA.
- Menstandarkan proses troubleshooting jika terjadi halaman kosong, 404, atau redirect tidak sesuai.
- Menjadi referensi onboarding untuk pengembangan fitur route baru.

## 2) Arsitektur Routing
- Entry router: `src/app/routes.tsx`
- Route publik: `src/app/routes/publicRoutes.tsx`
- Route admin: `src/app/routes/adminRoutes.tsx`
- Route dokter: `src/app/routes/doctorRoutes.tsx`
- Layout global: `src/app/layouts/RootLayout.tsx`
- Error route fallback: `src/app/pages/RouteErrorPage.tsx`

Prinsip:
- Semua page selain landing dimuat dengan lazy loading (on-demand).
- Route terlindungi dibungkus `RequireRole`.
- Error routing ditangani oleh `errorElement` agar tidak muncul tampilan error default React Router.

## 3) Guard dan Session
- Guard komponen: `src/core/auth/RequireRole.tsx`
- Session helper: `src/core/auth/session.ts`
- Session key utama: `aconsia_desktop_session`

Flow:
- Jika session kosong: redirect ke `/login`
- Jika role tidak sesuai: redirect ke `/login`
- Jika role sesuai: render halaman tujuan

## 4) Bootstrap Firebase Desktop
- Client Firebase: `src/core/firebase/client.ts`
- Validator env: `src/core/firebase/env.ts`
- Auth service: `src/core/auth/service.ts`

Env wajib desktop:
- `VITE_FIREBASE_API_KEY`
- `VITE_FIREBASE_AUTH_DOMAIN`
- `VITE_FIREBASE_PROJECT_ID`
- `VITE_FIREBASE_APP_ID`

Perilaku saat env belum lengkap:
- Login diblokir di UI dengan pesan yang jelas.
- Auth service mengembalikan `DesktopAuthError` dengan detail missing env.

## 5) Runbook: Jika Halaman Kosong
1. Jalankan dari folder `web-aconsia`: `npm run dev`
2. Buka `http://127.0.0.1:5173`
3. Hard refresh: `Cmd + Shift + R`
4. Cek apakah route basic (`/`, `/login`) bisa terbuka.
5. Jika protected route gagal, cek session di localStorage:
   - `aconsia_desktop_session`
   - `userRole`
6. Jika login gagal, cek isi `.env` (salin dari `.env.example` jika belum ada).

## 5.1) Runbook: Firebase `auth/invalid-api-key`
1. Pastikan file `web-aconsia/.env` ada.
2. Isi `VITE_FIREBASE_API_KEY` dari Firebase Console:
   - Firebase Console -> Project Settings -> General -> Your apps -> Web app config.
3. Pastikan API key milik project yang sama dengan:
   - `VITE_FIREBASE_AUTH_DOMAIN`
   - `VITE_FIREBASE_PROJECT_ID`
   - `VITE_FIREBASE_APP_ID`
4. Restart dev server setelah update `.env`:
   - stop `npm run dev`
   - jalankan lagi `npm run dev`
5. Hard refresh browser (`Cmd + Shift + R`).

## 6) Checklist Saat Menambah Route Baru
1. Tentukan domain route: public/admin/doctor.
2. Jika protected, pastikan dibungkus `RequireRole`.
3. Gunakan lazy loading + `withSuspense`.
4. Tambahkan test navigasi manual minimal:
   - buka route langsung via URL
   - akses tanpa login (jika protected)
   - akses setelah login role sesuai
5. Verifikasi build: `npm run build`

## 7) Catatan Stabilitas
- `RootLayout` memakai guarded widgets agar kegagalan komponen global tidak mematikan seluruh page.
- Service Worker dibersihkan di mode dev agar cache lama tidak mengganggu debugging.

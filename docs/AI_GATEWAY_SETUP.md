# Setup AI Gateway (Pasien Mobile)

Dokumen ini untuk koneksi AI pasien dengan arsitektur aman (API key hanya di backend).

## 1) Siapkan OpenAI API di akun client

1. Login ke platform API OpenAI menggunakan akun client.
2. Aktifkan billing/project API.
3. Buat API key baru.

Catatan: akun `chatgpt.com` saja tidak otomatis berarti API aktif.

## 2) Simpan secret di Firebase Functions

Jalankan dari root project:

```bash
cd functions
npx firebase-tools functions:secrets:set OPENAI_API_KEY
```

Masukkan API key saat diminta.

## 3) Konfigurasi env aplikasi Flutter

Gunakan nilai ini di `.env` untuk production:

```env
USE_MOCK_AI=false
AI_GATEWAY_ENABLED=true
AI_GATEWAY_REGION=us-central1
AI_GATEWAY_CALLABLE=aiGatewayChat
```

Untuk development lokal tanpa API:

```env
USE_MOCK_AI=true
AI_GATEWAY_ENABLED=true
```

## 4) Deploy backend gateway

```bash
cd functions
npx firebase-tools deploy --only functions:aiGatewayChat
```

## 5) Verifikasi cepat

1. Login sebagai pasien di mobile.
2. Buka sesi AI pembelajaran.
3. Kirim 1-2 pesan.
4. Pastikan respons muncul dan tidak ada error `missing_api_key` di mobile.

## 6) Rotasi API key (tanpa update app)

```bash
cd functions
npx firebase-tools functions:secrets:set OPENAI_API_KEY
npx firebase-tools deploy --only functions:aiGatewayChat
```

App mobile tidak perlu release baru selama nama callable/region tidak berubah.

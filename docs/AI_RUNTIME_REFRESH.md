# AI Runtime Refresh Checklist (Flutter Mobile)

Gunakan langkah ini setiap kali mengubah `.env` terkait AI agar runtime membaca konfigurasi terbaru.

## 1) Stop proses yang berjalan
- Hentikan `flutter run` (`q` di terminal)
- Pastikan emulator tidak menjalankan instance lama aplikasi

## 2) Hapus app dari emulator
- Uninstall aplikasi dari emulator/device

## 3) Refresh build dan dependency
```bash
flutter clean
flutter pub get
```

## 4) Jalankan ulang
```bash
flutter run
```

## 5) Verifikasi log startup (wajib)
Cari log:
```text
[ENV][AI] USE_MOCK_AI=false | AI_PROVIDER=openai_direct | OPENAI_API_KEY_PRESENT=true | openAiReady=true | reason=ready
[AI] OpenAIService initialized | mockModeActive=false | provider=openai_direct | apiKeyPresent=true | openAiReady=true | reason=ready
```

## 6) Verifikasi log halaman Chat AI
Saat halaman dibuka:
```text
[CHAT_AI] bootstrap | aiOnlineReady=true | ... | reason=ready
```

Saat evaluasi jawaban:
```text
[CHAT_AI] evaluate | mode=openai_direct_attempt | ...
[CHAT_AI] evaluate_result | mode=openai_direct_success | ...
```

Jika fallback terjadi, cek reason eksplisit:
- `ai_not_ready_mock_enabled`
- `ai_not_ready_missing_key`
- `ai_not_ready_provider_mismatch`
- `ai_request_failed_timeout`
- `ai_request_failed_upstream`

## Catatan warning emulator (non-blocking untuk AI)
Log berikut bukan indikator gagal koneksi OpenAI:
- `E/libEGL ... called unimplemented OpenGL ES API`
- `GoogleApiManager ... SecurityException ... com.google.android.gms`

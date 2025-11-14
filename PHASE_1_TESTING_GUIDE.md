# 🧪 PHASE 1 TESTING GUIDE

## ✅ PERSIAPAN

### 1. Setup OpenAI API Key

```env
# File: .env (d:\FASTWORK\aconsia_app\.env)
# Ganti dengan API key Anda:
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxxxxx
```

**Cara dapatkan API Key:**

1. Buka https://platform.openai.com/signup
2. Sign up atau login
3. Ke https://platform.openai.com/api-keys
4. Klik "Create new secret key"
5. Copy key yang dimulai dengan `sk-proj-...`
6. Paste ke file `.env`

**Note:** Free tier memberikan $5 credit untuk 3 bulan pertama.

---

## 🔧 SETUP DATABASE

### Pastikan Firestore Ada Data:

**Collection: `dokter_profiles`**

- Minimal 1 dokter dengan uid yang valid
- Field `uid`, `email`, `namaLengkap`, dll

**Collection: `pasien_profiles`**

- Minimal 1 pasien dengan:
  - `uid` (user ID pasien)
  - `dokterId` (uid dokter yang menangani)
  - `namaLengkap`, `jenisKelamin`, dll

**Collection: `konten`**

- Minimal 1 konten dengan:
  - `dokterId` (uid dokter pembuat)
  - `judul`, `jenisAnestesi`, `tataCara`, dll
  - `status: 'published'`

**Collection: `konten_sections`**

- Minimal 1 section untuk setiap konten:
  - `kontenId` (id dari konten)
  - `judulBagian`, `isiKonten`
  - `urutan: 1`

---

## 🚀 TESTING FLOW

### Step 1: Login sebagai Pasien

```
1. flutter run
2. Pilih device (Chrome/Android/iOS)
3. Login dengan akun pasien yang sudah ada di Firestore
```

### Step 2: Check Home Page

**Expected:**

- ✅ Nama pasien muncul di AppBar
- ✅ List konten dari dokter muncul (max 5)
- ✅ Setiap konten card punya button "Mulai Belajar"
- ✅ Klik card atau button → Navigate ke Detail Konten

**Jika konten tidak muncul:**

- Check: Apakah `pasien_profiles.dokterId` sudah diisi?
- Check: Apakah dokter punya konten dengan `status: 'published'`?

### Step 3: Buka Detail Konten

**Expected:**

- ✅ Judul konten muncul
- ✅ Tags (jenis anestesi, tata cara, dll) muncul
- ✅ Gambar konten muncul (jika ada)
- ✅ Sections konten muncul
- ✅ Button "Mulai Quiz Pembelajaran" muncul di bottom
- ✅ **PENTING**: Reading session sudah start (check di dokter dashboard)

**Test Reading Session:**

```
DOKTER SIDE:
1. Buka app dengan login dokter (device lain / browser lain)
2. Dashboard dokter harus show alert:
   "X pasien sedang membaca"
3. Alert muncul real-time tanpa refresh
```

### Step 4: Mulai Quiz AI

**Expected:**

- ✅ Klik "Mulai Quiz Pembelajaran"
- ✅ Loading indicator muncul (AI generate questions)
- ✅ 5 pertanyaan muncul satu per satu
- ✅ Progress bar update (1/5, 2/5, dst)
- ✅ Setiap pertanyaan punya difficulty badge (Mudah/Sedang/Sulit)

**Jika error "OpenAI API":**

- Check: API Key sudah benar di `.env`?
- Check: Internet connection aktif?
- Check: Credit OpenAI belum habis?

### Step 5: Jawab Pertanyaan

**Expected:**

- ✅ Ketik jawaban di text field
- ✅ Klik icon send
- ✅ Loading indicator muncul (AI evaluate)
- ✅ Popup muncul dengan:
  - Skor /100 dengan warna (Green ≥70, Orange ≥50, Red <50)
  - Feedback dari AI
  - Penjelasan tambahan (jika skor < 70)
- ✅ Klik "Lanjut" → Pertanyaan berikutnya

**Test Multiple Answers:**

```
Pertanyaan 1: Jawab singkat → Expect: Skor rendah + penjelasan
Pertanyaan 2: Jawab lengkap → Expect: Skor tinggi + feedback positif
Pertanyaan 3: Jawab ngasal → Expect: Skor sangat rendah + clarification
```

### Step 6: Lihat Result

**Expected setelah 5 pertanyaan:**

- ✅ Auto-navigate ke Quiz Result Page
- ✅ Overall score card muncul dengan:
  - Status (Excellent/Good/Fair/Needs Improvement)
  - Trophy icon sesuai performance
  - Skor rata-rata /100
- ✅ Section "Yang Sudah Dikuasai" muncul
- ✅ Section "Perlu Dipelajari Lebih Lanjut" muncul
- ✅ Rangkuman pembelajaran dari AI
- ✅ Rekomendasi konten selanjutnya (opsional)
- ✅ Pesan motivasi dari AI
- ✅ Button "Kembali ke Beranda" dan "Review Materi Kembali"

**Test Reading Session End:**

```
DOKTER SIDE:
1. Check dashboard dokter
2. Alert "X pasien sedang membaca" HARUS HILANG
3. Hilang otomatis tanpa refresh
```

### Step 7: Assignment Auto-Complete (Optional)

**Jika konten dari assignment:**

- ✅ Score ≥ 70 → Assignment auto-marked complete
- ✅ Check di Firestore: `konten_assignments.isCompleted = true`

---

## 🐛 TROUBLESHOOTING

### Error: "OpenAI API Key tidak ditemukan"

**Solution:**

```dart
// Check file .env
OPENAI_API_KEY=sk-proj-xxx... // Pastikan ada
```

### Error: "Konten tidak muncul"

**Solution:**

```
1. Check Firestore:
   - pasien_profiles.dokterId != null
   - konten.dokterId == pasien_profiles.dokterId
   - konten.status == 'published'

2. Reload app (hot restart)
```

### Error: "Reading session tidak start"

**Solution:**

```
1. Check console log untuk error
2. Pastikan konten punya sections
3. Pastikan uid pasien dan dokterId valid
```

### Error: "Quiz tidak generate"

**Solution:**

```
1. Check internet connection
2. Check OpenAI API Key valid
3. Check OpenAI credit tidak habis
4. Check console untuk error message spesifik

ALTERNATIVE:
- Ganti model ke gpt-4o-mini-instruct (lebih murah)
- Atau comment out response_format di openai_service.dart
```

### Error: "Popup feedback tidak muncul"

**Solution:**

```
1. Check console untuk JSON parse error
2. AI mungkin response tidak sesuai format
3. Retry dengan jawaban berbeda
```

---

## 📊 CHECKLIST TESTING

### Home Page

- [ ] Konten list muncul dari Firestore
- [ ] Button "Mulai Belajar" berfungsi
- [ ] Search konten berfungsi
- [ ] Navigate ke detail konten OK

### Detail Konten Page

- [ ] Reading session start automatically
- [ ] Dokter dashboard show alert real-time
- [ ] Button "Mulai Quiz" muncul di bottom
- [ ] Button navigate ke quiz page

### Quiz Chat AI Page

- [ ] AI generate 5 pertanyaan
- [ ] Progress bar update
- [ ] Difficulty badge muncul
- [ ] User bisa jawab setiap pertanyaan
- [ ] AI evaluate setiap jawaban
- [ ] Feedback popup muncul dengan score
- [ ] Navigate ke pertanyaan berikutnya
- [ ] Setelah 5 pertanyaan → Result page

### Quiz Result Page

- [ ] AI summary generated
- [ ] Overall score muncul
- [ ] Strengths section ada
- [ ] Areas to improve ada
- [ ] Recommendations ada
- [ ] Motivational message ada
- [ ] Reading session ended
- [ ] Dokter alert hilang real-time
- [ ] Button "Kembali" dan "Review" berfungsi

---

## ✅ EXPECTED FINAL STATE

Setelah testing lengkap:

```
✅ Pasien bisa lihat konten dari dokternya
✅ Pasien bisa buka detail konten
✅ Reading session start otomatis → Dokter dapat alert
✅ Pasien bisa klik "Mulai Quiz"
✅ AI generate 5 pertanyaan berbeda
✅ Pasien jawab satu-satu
✅ AI evaluate setiap jawaban dengan score
✅ Setelah 5 pertanyaan → Result page dengan summary
✅ Reading session end otomatis → Dokter alert hilang
✅ Assignment auto-complete jika score ≥ 70
```

---

## 📝 NOTES

### Database Requirements

Minimal data untuk testing:

- 1 dokter account
- 1 pasien account (dengan dokterId)
- 1 konten (dengan status 'published')
- 1 konten_section (untuk konten tersebut)

### OpenAI Cost Estimation

Untuk testing Phase 1:

- Generate quiz (5 questions): ~$0.01
- Evaluate 5 answers: ~$0.05
- Generate summary: ~$0.02
- **Total per test**: ~$0.08

Free tier $5 = ~60 full test runs

### Performance

- Quiz generation: ~3-5 detik
- Answer evaluation: ~2-3 detik per answer
- Summary generation: ~3-5 detik

---

## 🚀 NEXT STEPS

Jika Phase 1 berhasil:

1. ✅ Mark Phase 1 as COMPLETE
2. ⏳ Start Phase 2: Assignment Module UI
3. ⏳ Continue to remaining phases

Jika ada error:

1. ❌ Share screenshot error
2. 🔧 Fix error terlebih dahulu
3. 🔄 Retry testing

---

**Ready to test? Run `flutter run` dan ikuti step-by-step di atas!** 🎯

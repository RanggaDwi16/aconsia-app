# 🧪 END-TO-END TESTING GUIDE

## 📋 **TESTING CHECKLIST**

Ikuti langkah-langkah ini untuk test seluruh flow aplikasi dari awal sampai akhir.

---

## 🎯 **TEST 1: LANDING PAGE & DEMO**

### **Objective:** Memastikan halaman landing dan demo berfungsi

#### **Steps:**
```
1. Open browser → http://localhost:5173/
2. ✅ VERIFY: Landing page muncul dengan desain yang bagus
3. ✅ VERIFY: Ada tombol [Coba Demo Interaktif]
4. Click [Coba Demo Interaktif]
5. ✅ VERIFY: Redirect ke /demo
6. ✅ VERIFY: Demo page dengan 9 stages muncul
7. Click through Stage 1 → Stage 9
8. ✅ VERIFY: Semua stage berfungsi tanpa error
9. Click [Mulai Sekarang] di akhir demo
10. ✅ VERIFY: Redirect ke /register
```

#### **Expected Results:**
- ✅ Landing page load < 2 seconds
- ✅ Demo interactive & smooth
- ✅ All 9 stages work correctly
- ✅ Navigation flows properly

---

## 🎯 **TEST 2: PATIENT REGISTRATION (PROFESSIONAL INPUT)**

### **Objective:** Test form validation, auto-format, error messages

#### **Steps:**
```
1. Navigate to /register
2. ✅ VERIFY: Form dengan fields lengkap muncul
3. Fill data SALAH (test validation):
   
   a) Phone: "12345" (invalid)
      ✅ VERIFY: Error "Format nomor telepon tidak valid"
   
   b) Email: "invalid" (no @)
      ✅ VERIFY: Error "Format email tidak valid"
   
   c) Leave Name empty
      ✅ VERIFY: Error "Nama lengkap wajib diisi"

4. Fill data BENAR:
   
   Full Name: Jordan Smith
   MRN: MRN-2026-001
   Date of Birth: 15/01/1985 (use date picker)
   Age: 41 (auto-calculate from DOB)
   Gender: Male
   Phone: 081234567890
      ✅ VERIFY: Auto-format to "+62 812-3456-7890"
   Email: jordan.smith@email.com
   Address: Jl. Sudirman No. 123, Jakarta Pusat
   Surgery Type: Laparoscopic Appendectomy
   Surgery Date: 15/03/2026 (use date picker)
   ASA Status: ASA II
   Medical History: Hypertension (controlled)
   Allergies: None
   Current Medications: Amlodipine 5mg daily
   Assigned Doctor: Dr. Ahmad Suryadi, Sp.An

5. Click [Daftar Sekarang]
6. ✅ VERIFY: Loading spinner muncul
7. ✅ VERIFY: Success message "Pendaftaran berhasil!"
8. ✅ VERIFY: Redirect ke /patient (dashboard)
```

#### **Expected Results:**
- ✅ Real-time validation works
- ✅ Auto-format phone number: +62 812-3456-7890
- ✅ Date picker functional
- ✅ Clear error messages
- ✅ Loading state visible
- ✅ Success feedback clear
- ✅ Data saved to localStorage

---

## 🎯 **TEST 3: PATIENT DASHBOARD (PENDING STATE)**

### **Objective:** Test dashboard saat menunggu approval dokter

#### **Steps:**
```
1. After registration → /patient
2. ✅ VERIFY: Welcome message: "Selamat Datang, Jordan Smith"
3. ✅ VERIFY: Status badge: "PENDING APPROVAL"
4. ✅ VERIFY: Alert box:
   "Data Teknik Anestesi Belum Dipilih
    Mohon tunggu dokter meninjau data Anda dan 
    memilih teknik anestesi yang sesuai."
5. ✅ VERIFY: Button [Hubungi Dokter] ada
6. ✅ VERIFY: Materials section KOSONG atau disabled
7. ✅ VERIFY: Comprehension score: 0%
8. ✅ VERIFY: No schedule yet
```

#### **Expected Results:**
- ✅ Dashboard loads properly
- ✅ Pending state clear
- ✅ Materials not accessible yet
- ✅ Call to action visible

---

## 🎯 **TEST 4: DOCTOR APPROVAL (AUTO-FILTER TRIGGER)**

### **Objective:** Test doctor workflow & anesthesia selection

#### **Steps:**
```
1. Open new tab → /doctor/approval
2. ✅ VERIFY: List of pending patients muncul
3. ✅ VERIFY: "Jordan Smith" ada di list dengan status "Pending"
4. Click [Review] pada Jordan Smith
5. ✅ VERIFY: Modal detail pasien muncul dengan data lengkap:
   - Full Name: Jordan Smith
   - MRN: MRN-2026-001
   - Surgery: Laparoscopic Appendectomy
   - Medical History: Hypertension
   - Allergies: None
   - etc.
6. ✅ VERIFY: Dropdown "Pilih Jenis Anestesi" ada
7. Open dropdown → ✅ VERIFY: Options:
   • General Anesthesia
   • Spinal Anesthesia
   • Epidural Anesthesia
   • Regional Anesthesia
   • Local Anesthesia + Sedation
8. Select: "General Anesthesia"
9. Click [ACC & Pilih Anestesi]
10. ✅ VERIFY: Loading spinner
11. ✅ VERIFY: Success message "Pasien berhasil di-approve"
12. ✅ VERIFY: Status berubah "Approved - General Anesthesia"
```

#### **Expected Results:**
- ✅ Doctor dashboard accessible
- ✅ Patient list shows correctly
- ✅ Detail modal complete
- ✅ Anesthesia selection works
- ✅ Status updates properly
- ✅ Data saved (localStorage or backend)

---

## 🎯 **TEST 5: AUTO-FILTER KONTEN (CRITICAL!)**

### **Objective:** Verify HANYA konten General Anesthesia yang muncul

#### **Steps:**
```
1. Go back to patient tab → Refresh /patient
2. ✅ VERIFY: Status badge berubah: "APPROVED"
3. ✅ VERIFY: Alert berubah:
   "Teknik Anestesi: General Anesthesia
    Dokter telah menyetujui dan memilih teknik anestesi.
    Silakan lanjut ke materi pembelajaran."
4. ✅ VERIFY: Materials section muncul dengan 3 materi:
   
   ✓ "Pengenalan Anestesi Umum"
     - Type: General Anesthesia
     - Progress: 0%
     - Button: [Mulai]
   
   ✓ "Persiapan Sebelum Anestesi Umum"
     - Type: General Anesthesia
     - Progress: 0%
     - Button: [Mulai]
   
   ✓ "Prosedur Anestesi Umum"
     - Type: General Anesthesia
     - Progress: 0%
     - Button: [Mulai]

5. ✅ VERIFY: TIDAK ADA materi lain (Spinal, Epidural, dll)
6. ✅ VERIFY: Total progress: 0% (3 dari 3 materi belum selesai)
```

#### **Expected Results:**
- ✅ Status updated to "Approved"
- ✅ ONLY 3 "General Anesthesia" materials visible
- ✅ NO materials from other types (Spinal, Epidural, etc.)
- ✅ Progress tracking accurate
- ✅ Call to action clear: [Mulai]

---

## 🎯 **TEST 6: MATERIAL READER (ANTI-SKIP + ONLINE INDICATOR)**

### **Objective:** Test reading flow dengan anti-skip system

#### **Steps:**
```
1. Click [Mulai] pada "Pengenalan Anestesi Umum"
2. ✅ VERIFY: Redirect ke /patient/material/1
3. ✅ VERIFY: Green banner di top: "🟢 Kembali online!"
4. ✅ VERIFY: Progress bar: 0% (0 dari 5 section selesai)
5. ✅ VERIFY: Orange instruction box:
   "📖 Cara Membaca:
    • Buka section satu per satu (tidak bisa skip)
    • Baca hingga minimum waktu terpenuhi
    • Jawab pertanyaan checkpoint untuk melanjutkan
    • Selesaikan semua section untuk lanjut ke AI Chat"
6. ✅ VERIFY: Section 1 "Pengertian" - UNLOCKED (✓ icon)
7. ✅ VERIFY: Section 2-5 - LOCKED (🔒 icon)
8. Click Section 1 → Expand
9. ✅ VERIFY: Timer muncul: "Min. 45s • Baca: 0s"
10. ✅ VERIFY: Timer update setiap detik: "Min. 45s • Baca: 1s" → "2s" → "3s"
11. ✅ VERIFY: Button [Lanjut ke Pertanyaan] - DISABLED (gray)
12. Wait 45 seconds
13. ✅ VERIFY: Timer: "Min. 45s • Baca: 45s"
14. ✅ VERIFY: Button berubah GREEN & enabled
15. Click [Lanjut ke Pertanyaan]
16. ✅ VERIFY: Checkpoint quiz modal muncul:
    "Berdasarkan yang Anda baca, apa tujuan UTAMA dari anestesi umum?"
    [ ] Membuat pasien tertidur saja
    [ ] Mencegah nyeri dan memberikan kenyamanan saat operasi ← CORRECT
    [ ] Menghentikan pernapasan pasien
    [ ] Membuat pasien lupa tentang operasi
17. Select: "Mencegah nyeri dan memberikan kenyamanan saat operasi"
18. Click [Submit Jawaban]
19. ✅ VERIFY: Success! Section 1 completed (✅ badge)
20. ✅ VERIFY: Section 2 "Risiko Tindakan" - AUTO-UNLOCKED (🔒 → ✓)
21. ✅ VERIFY: Progress bar: 20% (1 dari 5 section selesai)
22. Repeat untuk Section 2-5
23. ✅ VERIFY: Setelah ALL completed → Progress: 100%
24. ✅ VERIFY: Completion card muncul:
    "🎉 Selamat! Anda Telah Menyelesaikan Materi Ini
     Langkah selanjutnya: Chat dengan AI Assistant"
25. ✅ VERIFY: Button [💬 Chat dengan AI Assistant] - GREEN
```

#### **Test Online/Offline Indicator:**
```
26. Open DevTools (F12) → Network tab
27. Toggle "Offline" mode
28. ✅ VERIFY: Banner berubah RED: "🔴 Tidak ada koneksi internet"
29. Toggle "Online" mode
30. ✅ VERIFY: Banner berubah GREEN: "🟢 Kembali online!"
```

#### **Test Exit Prevention:**
```
31. Di tengah-tengah reading (belum selesai)
32. Click browser back button atau [Kembali]
33. ✅ VERIFY: Warning modal:
    "Anda belum selesai membaca konten ini.
     Silakan baca terlebih dahulu sebelum melanjutkan."
34. ✅ VERIFY: Options:
    [Lanjut Membaca] ← Primary
    [Keluar (Progress Tidak Tersimpan)] ← Secondary
35. Click [Lanjut Membaca]
36. ✅ VERIFY: Stay on page
```

#### **Expected Results:**
- ✅ Online indicator works (green/red banner)
- ✅ Real-time timer updates every second
- ✅ Sequential unlock (can't skip)
- ✅ Time-gated reading enforced
- ✅ Checkpoint quiz blocks progress
- ✅ Progress bar accurate
- ✅ Exit prevention works
- ✅ Completion CTA clear

---

## 🎯 **TEST 7: HYBRID CHAT (QUICK REPLY + TEXT INPUT)**

### **Objective:** Test AI chat dengan flexibility

#### **Steps:**
```
1. After completing all materials, click [💬 Chat dengan AI Assistant]
2. ✅ VERIFY: Redirect ke /patient/chat-hybrid
3. ✅ VERIFY: Header:
   - Avatar: Bot icon
   - Title: "AI Assistant"
   - Status: "🟢 Online"
   - Badge: "Pemahaman: 60%"
4. ✅ VERIFY: AI greeting message:
   "Hai! Saya adalah AI Assistant untuk edukasi informed consent anestesi.
    Saya akan menanyakan beberapa pertanyaan untuk memastikan pemahaman Anda."
5. Wait 2 seconds
6. ✅ VERIFY: AI question 1:
   "Mari kita mulai dengan pertanyaan sederhana. 
    Mengapa pasien harus puasa 6-8 jam sebelum operasi dengan anestesi umum?"
7. ✅ VERIFY: Quick reply buttons:
   [ ] Ya, untuk mencegah aspirasi (cairan lambung masuk paru-paru)
   [ ] Ya, tapi saya belum tahu alasannya secara detail
   [ ] Tidak yakin, bisa jelaskan lebih detail?
   [ ] 💬 Saya ingin menjelaskan dengan kata-kata sendiri ← PURPLE/SPECIAL
8. ✅ VERIFY: Hint text: "💡 Pilih jawaban atau ketik manual di bawah:"
9. ✅ VERIFY: Text input di bottom:
   [Ketik jawaban Anda di sini... (opsional)] [>]
   Badge: "Optional"
```

#### **Test Quick Reply:**
```
10. Click quick reply: "Ya, untuk mencegah aspirasi..."
11. ✅ VERIFY: User message bubble (blue): "Ya, untuk mencegah aspirasi..."
12. ✅ VERIFY: Typing indicator (3 dots)
13. Wait 1.5 seconds
14. ✅ VERIFY: AI response:
    "✅ Benar! Pemahaman Anda sangat baik. Mari lanjut ke pertanyaan berikutnya."
15. ✅ VERIFY: Comprehension score updates: 60% → 70%
16. ✅ VERIFY: Next question muncul
```

#### **Test Manual Text Input:**
```
17. AI question 2: "Apa yang sebaiknya Anda lakukan jika memiliki riwayat alergi obat?"
18. Click quick reply: "💬 Saya ingin menjelaskan dengan kata-kata sendiri"
19. ✅ VERIFY: User message: "💬 Saya ingin menjelaskan..."
20. ✅ VERIFY: AI response:
    "Silakan ketik jawaban Anda di kolom input di bawah. 
     Saya akan menganalisis pemahaman Anda."
21. ✅ VERIFY: Input field auto-focus
22. Type in input: "Saya harus memberitahu tim anestesi tentang alergi saya sebelum operasi"
23. Click [>] button (or press Enter)
24. ✅ VERIFY: User message bubble: "Saya harus memberitahu..."
25. ✅ VERIFY: Typing indicator
26. Wait 1.5 seconds
27. ✅ VERIFY: AI response:
    "✅ Bagus! Saya melihat Anda menyebutkan kata kunci penting: 
     'alergi, anestesi'. Ini menunjukkan pemahaman yang baik."
28. ✅ VERIFY: Score updates: 70% → 78%
```

#### **Test Complete Flow:**
```
29. Answer all questions (3 total)
30. ✅ VERIFY: Final AI message:
    "🎉 Luar biasa! Anda telah menyelesaikan sesi chat. 
     Tingkat pemahaman Anda sekarang: 85%. 
     Anda sudah siap untuk informed consent!"
31. ✅ VERIFY: Final score: 85% (≥80% threshold)
```

#### **Expected Results:**
- ✅ Chat interface smooth (like GPT)
- ✅ Quick replies work correctly
- ✅ Text input available & functional
- ✅ Auto-focus on manual input
- ✅ Keyword analysis works
- ✅ Comprehension score updates real-time
- ✅ Typing indicators smooth
- ✅ Message bubbles styled correctly
- ✅ Timestamp displayed
- ✅ Auto-scroll to bottom

---

## 🎯 **TEST 8: SCHEDULE CONSENT (FULL IDENTITY)**

### **Objective:** Test scheduling dengan identitas lengkap

#### **Steps:**
```
1. After chat completion (score ≥80%), go to /patient/schedule-consent
2. ✅ VERIFY: Page title: "Jadwal Penandatanganan Informed Consent"
3. ✅ VERIFY: Full Patient Identity:
   - Foto: Avatar
   - Nama Lengkap: Jordan Smith
   - No. Rekam Medis: MRN-2026-001
   - Tanggal Lahir: 15 Januari 1985
   - Usia: 41 tahun
   - Jenis Kelamin: Laki-laki
   - No. Telepon: +62 812-3456-7890
   - Email: jordan.smith@email.com
   - Alamat: Jl. Sudirman No. 123, Jakarta Pusat
   - Jenis Operasi: Laparoscopic Appendectomy
   - Tanggal Operasi: 15 Maret 2026
   - Status ASA: ASA II
   - Jenis Anestesi: General Anesthesia

4. ✅ VERIFY: Full Doctor Identity:
   - Foto: Doctor avatar
   - Nama: Dr. Ahmad Suryadi, Sp.An
   - STR: STR-AN-2018-123456
   - SIP: SIP-AN-2023-JKT-00789
   - Berlaku Hingga: 15 Juni 2028
   - Spesialisasi: Anestesiologi & Terapi Intensif
   - Rumah Sakit: RS Pusat Jakarta
   - Pengalaman: 15 tahun

5. ✅ VERIFY: Comprehension Score: 85% (GREEN badge)
6. ✅ VERIFY: Status: "Anda siap untuk informed consent"
7. ✅ VERIFY: Schedule selection:
   - Date picker: "Pilih Tanggal"
   - Time picker: "Pilih Waktu" (08:00 - 17:00)
   - Location: "Ruang Konsultasi Anestesi, Lt. 2"

8. Select date: "10 Maret 2026" (H-5 sebelum operasi)
9. Select time: "08:00"
10. Click [Konfirmasi Jadwal]
11. ✅ VERIFY: Confirmation modal:
    "Konfirmasi Jadwal Informed Consent
     
     Anda akan menandatangani informed consent pada:
     📅 Selasa, 10 Maret 2026
     🕐 Pukul 08:00 WIB
     📍 Ruang Konsultasi Anestesi, Lt. 2
     
     Dengan:
     👨‍⚕️ Dr. Ahmad Suryadi, Sp.An
     
     Apakah Anda yakin?"
12. Click [Ya, Konfirmasi]
13. ✅ VERIFY: Loading spinner
14. ✅ VERIFY: Success animation/confetti
15. ✅ VERIFY: Success message:
    "✅ Jadwal Berhasil Dikonfirmasi!
     Reminder akan dikirim H-1 via push notification."
16. ✅ VERIFY: Redirect ke /patient dashboard
```

#### **Expected Results:**
- ✅ Full patient identity displayed
- ✅ Full doctor identity displayed
- ✅ Comprehension score visible
- ✅ Date/time picker functional
- ✅ Confirmation modal clear
- ✅ Loading state visible
- ✅ Success feedback celebratory
- ✅ Data saved correctly

---

## 🎯 **TEST 9: FINAL DASHBOARD STATE**

### **Objective:** Verify completed state dashboard

#### **Steps:**
```
1. Back to /patient dashboard
2. ✅ VERIFY: Status badge: "READY FOR CONSENT"
3. ✅ VERIFY: Comprehension score: 85%
4. ✅ VERIFY: Progress: 100% (all materials completed)
5. ✅ VERIFY: Schedule card:
   "📅 Jadwal Penandatanganan
    Selasa, 10 Maret 2026
    Pukul 08:00 WIB
    Ruang Konsultasi Anestesi, Lt. 2
    
    Dengan: Dr. Ahmad Suryadi, Sp.An
    
    [Ubah Jadwal] [Lihat Detail]"
6. ✅ VERIFY: All materials marked as completed (✅)
7. ✅ VERIFY: Chat history accessible
8. ✅ VERIFY: Reminder note:
   "💬 Push notification akan dikirim H-1 (9 Maret 2026)"
```

#### **Expected Results:**
- ✅ Dashboard reflects completed state
- ✅ All progress indicators at 100%
- ✅ Schedule visible with full details
- ✅ Options to modify/view available
- ✅ Reminder info clear

---

## 🎯 **TEST 10: EDGE CASES & ERROR HANDLING**

### **Objective:** Test error scenarios dan edge cases

#### **Test 1: Try to access locked material**
```
1. Go to /patient/material/1
2. Try to click Section 2 (locked)
3. ✅ VERIFY: Warning modal:
   "Section ini masih terkunci. 
    Selesaikan section sebelumnya terlebih dahulu."
```

#### **Test 2: Try to submit checkpoint without reading**
```
1. Open Section 1
2. Immediately click [Lanjut ke Pertanyaan] (before 45s)
3. ✅ VERIFY: Warning:
   "Mohon baca dengan teliti! 
    Anda masih memerlukan XX detik lagi."
```

#### **Test 3: Wrong checkpoint answer**
```
1. Complete reading (45s)
2. Answer checkpoint WRONG (3 times)
3. ✅ VERIFY: Warning:
   "Jawaban Anda kurang tepat. 
    Silakan baca kembali section dengan lebih teliti."
4. ✅ VERIFY: Section reset (time spent → 0)
```

#### **Test 4: Try to schedule with low score**
```
1. Manually set score to 70% (< 80%)
2. Go to /patient/schedule-consent
3. ✅ VERIFY: Blocked with message:
   "Tingkat pemahaman Anda: 70%
    Minimum 80% untuk jadwal informed consent.
    Silakan baca materi lagi atau chat dengan AI."
```

#### **Test 5: Offline mode**
```
1. Go offline (DevTools → Network → Offline)
2. ✅ VERIFY: Red banner: "Tidak ada koneksi internet"
3. ✅ VERIFY: Features still work (localStorage)
4. Try to submit data
5. ✅ VERIFY: Error message:
   "Tidak dapat terhubung ke server. 
    Data akan disimpan lokal dan disinkronkan saat online."
```

#### **Expected Results:**
- ✅ All edge cases handled gracefully
- ✅ Clear error messages
- ✅ No crashes or blank screens
- ✅ Offline mode functional
- ✅ Data persistence works

---

## 🎯 **TEST 11: ALTERNATIVE FLOW (SPINAL ANESTHESIA)**

### **Objective:** Verify auto-filter untuk jenis anestesi lain

#### **Steps:**
```
1. Buat pasien baru (register again dengan data berbeda)
   Name: Sarah Johnson
   Surgery: Cesarean Section
2. Doctor approval: Pilih "Spinal Anesthesia"
3. Go to patient dashboard
4. ✅ VERIFY: HANYA materi Spinal Anesthesia yang muncul:
   • Pengenalan Anestesi Spinal
   • Persiapan Anestesi Spinal
   • (NOT General, NOT Epidural)
5. Complete flow untuk Spinal Anesthesia
6. ✅ VERIFY: All flows sama (reading, chat, schedule)
```

#### **Expected Results:**
- ✅ Auto-filter works for different anesthesia types
- ✅ Content specific to selected type
- ✅ No cross-contamination
- ✅ Same flow for all types

---

## 📊 **PERFORMANCE CHECKLIST**

### **Page Load Times:**
- [ ] Landing page: < 2s
- [ ] Dashboard: < 1.5s
- [ ] Material reader: < 1s
- [ ] Chat: < 1s

### **Interactions:**
- [ ] Button clicks: < 100ms response
- [ ] Form validation: real-time (< 50ms)
- [ ] Timer updates: every 1s (accurate)
- [ ] Chat messages: < 200ms

### **Responsiveness:**
- [ ] Desktop (1920x1080): ✓
- [ ] Laptop (1366x768): ✓
- [ ] Tablet (768x1024): ✓
- [ ] Mobile (375x667): ✓

### **Browser Compatibility:**
- [ ] Chrome/Edge (latest): ✓
- [ ] Firefox (latest): ✓
- [ ] Safari (latest): ✓

---

## 🐛 **BUG REPORTING TEMPLATE**

If you find any bugs, report using this template:

```
**Bug Title:** [Short description]

**Severity:** Critical / High / Medium / Low

**Steps to Reproduce:**
1. Go to [URL]
2. Click [button]
3. Observe [issue]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Screenshots:**
[Attach screenshots if possible]

**Environment:**
- Browser: Chrome 120
- OS: Windows 11
- Screen: 1920x1080

**Console Errors:**
[Copy any console errors]
```

---

## ✅ **TESTING COMPLETION CHECKLIST**

After completing all tests above:

- [ ] Landing & Demo work
- [ ] Registration with validation works
- [ ] Doctor approval flow works
- [ ] **AUTO-FILTER konten works** ⭐
- [ ] Material reader (anti-skip) works
- [ ] Online/offline indicator works
- [ ] Exit prevention works
- [ ] **Hybrid chat (quick reply + text) works** ⭐
- [ ] Comprehension score updates correctly
- [ ] Schedule consent with full identity works
- [ ] Final dashboard state correct
- [ ] All edge cases handled
- [ ] Alternative anesthesia types work
- [ ] Performance acceptable
- [ ] Responsive on all devices
- [ ] No console errors
- [ ] No crashes or blank screens

---

## 🎉 **SIGN-OFF**

**Tested by:** [Your Name]  
**Date:** [Date]  
**Result:** PASS ✅ / FAIL ❌  
**Notes:** [Any additional notes]

---

**Ready for:**
- [ ] User Testing
- [ ] Demo Presentation
- [ ] Backend Integration
- [ ] Production Deployment

---

**Last Updated:** March 7, 2026  
**Version:** 1.0

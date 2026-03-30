# ⚡ QUICK TEST GUIDE (5 MINUTES)

Jika kamu ingin test CEPAT tanpa baca dokumentasi panjang, ikuti ini! ⏱️

---

## 🚀 **QUICK START (30 detik)**

```bash
# 1. Run development server
npm run dev

# 2. Open browser
http://localhost:5173/
```

---

## 🎯 **FAST TEST PATH (5 menit)**

### **1️⃣ Demo (30 detik)**
```
URL: http://localhost:5173/demo
Action: Click through 9 stages
✅ Check: All stages work
```

### **2️⃣ Register (1 menit)**
```
URL: http://localhost:5173/register

Data:
Name: Jordan Smith
MRN: MRN-2026-001
DOB: 15/01/1985
Phone: 081234567890 → ✅ Auto-format to +62 812-3456-7890
Email: jordan@email.com
Surgery: Appendectomy
Date: 15/03/2026
Doctor: Dr. Ahmad Suryadi

✅ Check: Phone auto-format works
✅ Check: Submit → Success message
```

### **3️⃣ Doctor Approval (30 detik)**
```
URL: http://localhost:5173/doctor/approval

Action: 
1. Click [Review] on Jordan Smith
2. Select: "General Anesthesia"
3. Click [ACC & Pilih Anestesi]

✅ Check: Success message
✅ Check: Navigate to /doctor (Enhanced Dashboard)
✅ Check: Real-time sync - patient status updates
```

### **3.5️⃣ Admin Dashboard - Real-Time Monitoring (30 detik)** ⭐
```
URL: http://localhost:5173/admin

✅ Check: Auto-sync banner "ter-sinkronisasi setiap 2 detik"
✅ Check: Statistics update real-time:
   • Total Pasien: count updates
   • Pending: count updates
   • In Progress: count updates
   • Ready: count updates
   • Avg Score: percentage updates
✅ Check: Doctor Performance section
✅ Check: Anesthesia Distribution chart
✅ Check: Recent Patients with real-time status

💡 Test sync:
1. Open /patient in another tab
2. Make progress (read material, chat)
3. Go back to /admin
4. ✅ Stats update automatically!
```

### **4️⃣ Patient Dashboard - AUTO-FILTER (30 detik)** ⭐
```
URL: http://localhost:5173/patient

✅ Check: HANYA 3 materi "General Anesthesia" muncul:
   • Pengenalan Anestesi Umum
   • Persiapan Anestesi Umum
   • Prosedur Anestesi Umum

❌ Check: TIDAK ADA materi Spinal/Epidural
```

### **5️⃣ Material Reader (1 menit)**
```
URL: http://localhost:5173/patient/material/1

✅ Check: Green banner "Kembali online!"
✅ Check: Section 1 unlocked, 2-5 locked
✅ Check: Timer: "Min. 45s • Baca: 0s" → updates setiap detik
✅ Check: Button disabled until 45s
✅ Check: After 45s → Button green & enabled
✅ Check: Checkpoint quiz → Section 2 unlock
```

### **6️⃣ Hybrid Chat (1 menit)** ⭐
```
URL: http://localhost:5173/patient/chat-hybrid

✅ Check: Quick reply buttons visible
✅ Check: Text input field visible (with "Optional" badge)
✅ Check: Click quick reply → AI responds
✅ Check: Click "💬 Saya ingin menjelaskan sendiri" → Input focus
✅ Check: Type manual text → Submit → AI analyzes
✅ Check: Score updates: 60% → 70% → 85%
```

### **7️⃣ Schedule Consent (30 detik)**
```
URL: http://localhost:5173/patient/schedule-consent

✅ Check: Full patient identity displayed
✅ Check: Full doctor identity displayed
✅ Check: Date/time picker works
✅ Check: Submit → Success message
```

### **8️⃣ Final Dashboard (20 detik)**
```
URL: http://localhost:5173/patient

✅ Check: Status "READY"
✅ Check: Score: 85%
✅ Check: Progress: 100%
✅ Check: Schedule visible
```

---

## ✅ **PASS CRITERIA**

Jika SEMUA check marks (✅) di atas berhasil, prototype PASS! 🎉

---

## 🐛 **JIKA ADA ERROR:**

1. Check console (F12) untuk error messages
2. Check `/docs/END-TO-END-TESTING.md` untuk troubleshooting
3. Clear localStorage: `localStorage.clear()` di console
4. Refresh page (Ctrl+Shift+R)
5. Restart dev server

---

## 🎯 **FOKUS TEST:**

### **CRITICAL FEATURES** (MUST WORK):
1. ⭐ **AUTO-FILTER**: Hanya konten sesuai jenis anestesi
2. ⭐ **HYBRID CHAT**: Quick reply + text input
3. ⭐ **ANTI-SKIP**: Sequential unlock + time-gated
4. ⭐ **REAL-TIME TIMER**: Update setiap detik
5. ⭐ **ONLINE INDICATOR**: Green/red banner

### **NICE TO HAVE** (POLISH):
- Phone auto-format
- Loading spinners
- Success animations
- Error messages
- Tooltips

---

## 📊 **SUCCESS METRICS**

**Minimum untuk PASS:**
- [ ] Auto-filter works (100% accurate)
- [ ] Hybrid chat works (quick + text)
- [ ] Timer real-time (update every 1s)
- [ ] Sequential unlock (no skip)
- [ ] Score calculation (accurate)

**Bonus:**
- [ ] UI smooth & responsive
- [ ] No console errors
- [ ] Loading states visible
- [ ] Error handling graceful

---

## ⏱️ **TIME ESTIMATE**

- **Quick Test (Fast Path):** 5 minutes
- **Full Test (All features):** 15 minutes
- **Complete Test (Edge cases):** 30 minutes

---

**Choose your path:**
- 🏃 **Speed Run:** 5 min (Fast Path only)
- 🚶 **Normal:** 15 min (All features)
- 🧐 **Thorough:** 30 min (Full test + edge cases)

---

**Start Testing Now!** ⚡

```bash
npm run dev
# Open: http://localhost:5173/demo
```
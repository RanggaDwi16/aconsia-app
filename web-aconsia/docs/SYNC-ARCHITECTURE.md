# 🔄 REAL-TIME SYNC ARCHITECTURE

## 📊 **3-WAY DASHBOARD SYNCHRONIZATION**

Sistem ini menggunakan **localStorage sebagai central data store** dengan **auto-sync setiap 2 detik** untuk memastikan semua dashboard (Admin, Doctor, Patient) ter-update secara real-time.

---

## 🏗️ **ARCHITECTURE DIAGRAM**

```
┌─────────────────────────────────────────────────────────────┐
│                  REAL-TIME SYNC FLOW                        │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────────┐
                    │   localStorage   │
                    │  (Central Store) │
                    └────────┬─────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
  ┌────────────────┐ ┌──────────────┐ ┌──────────────┐
  │     ADMIN      │ │    DOCTOR    │ │   PATIENT    │
  │   Dashboard    │ │  Dashboard   │ │  Dashboard   │
  └────────────────┘ └──────────────┘ └──────────────┘
   /admin             /doctor           /patient
   
   Auto-sync ↻ 2s    Auto-sync ↻ 2s   Auto-sync ↻ 2s
```

---

## 🔄 **DATA FLOW**

### **1. Patient Registration**
```
Patient fills form → Submit
         ↓
localStorage.setItem("currentPatient", data)
         ↓
All dashboards detect change (2s interval)
         ↓
Admin, Doctor dashboards update automatically
```

### **2. Doctor Approval**
```
Doctor reviews patient → Select anesthesia type → ACC
         ↓
Update localStorage: patient.anesthesiaType = "General Anesthesia"
         ↓
Patient dashboard detects change
         ↓
Auto-filter applies → Show ONLY relevant materials
         ↓
Admin dashboard updates stats
```

### **3. Patient Progress**
```
Patient reads material → Completes section
         ↓
Update localStorage: patient.comprehensionScore += 10
         ↓
Doctor dashboard sees progress bar update
         ↓
Admin dashboard sees avg comprehension update
```

### **4. Schedule Consent**
```
Patient schedules consent → Select date/time → Confirm
         ↓
Update localStorage: patient.scheduledConsentDate = "2026-03-10 08:00"
         ↓
Doctor sees scheduled appointment
         ↓
Admin sees scheduled consent in patient list
```

---

## 📦 **LOCALSTORAGE DATA STRUCTURE**

### **Patient Data (Key: "currentPatient")**
```typescript
{
  id: "patient-001",
  fullName: "Jordan Smith",
  mrn: "MRN-2026-001",
  dateOfBirth: "1985-01-15",
  age: 41,
  gender: "Male",
  phone: "+62 812-3456-7890",
  email: "jordan.smith@email.com",
  address: "Jl. Sudirman No. 123, Jakarta Pusat",
  surgeryType: "Laparoscopic Appendectomy",
  surgeryDate: "2026-03-15",
  asaStatus: "ASA II",
  
  // Doctor sets this:
  anesthesiaType: "General Anesthesia",
  status: "in_progress", // pending | approved | in_progress | ready | completed
  assignedDoctorId: "doctor-001",
  
  // Patient progress:
  comprehensionScore: 65, // 0-100%
  materialsCompleted: 2,
  totalMaterials: 3,
  
  // Schedule:
  scheduledConsentDate: "2026-03-10 08:00",
  
  // Medical info:
  medicalHistory: "Hypertension (controlled)",
  allergies: "None",
  medications: "Amlodipine 5mg daily"
}
```

---

## 🎯 **SYNC MECHANISM**

### **Auto-Sync Implementation (Every Dashboard)**

```typescript
useEffect(() => {
  const loadData = () => {
    // Load from localStorage
    const savedPatient = localStorage.getItem("currentPatient");
    if (savedPatient) {
      const patientData = JSON.parse(savedPatient);
      setPatientData(patientData); // Update state
    }
  };

  loadData(); // Initial load

  // Auto-sync every 2 seconds
  const interval = setInterval(loadData, 2000);
  return () => clearInterval(interval);
}, []);
```

### **Why 2 Seconds?**
- ✅ Fast enough for "real-time" feel
- ✅ Not too aggressive (prevents performance issues)
- ✅ Balances responsiveness vs resource usage

---

## 🔍 **DASHBOARD-SPECIFIC FEATURES**

### **1. Admin Dashboard (`/admin`)**

**Features:**
- ✅ Monitor ALL patients across all doctors
- ✅ Real-time statistics:
  - Total patients
  - Pending approval count
  - In-progress count
  - Ready for consent count
  - Completed count
  - Average comprehension score
- ✅ Doctor performance tracking
- ✅ Anesthesia type distribution
- ✅ Recent activity log

**Sync Strategy:**
```typescript
// Load ALL patients (mock + localStorage)
const mockPatients = [...]; // Base data
const currentPatient = JSON.parse(localStorage.getItem("currentPatient"));

// Merge or add current patient
if (currentPatient) {
  const index = mockPatients.findIndex(p => p.id === currentPatient.id);
  if (index !== -1) {
    mockPatients[index] = { ...mockPatients[index], ...currentPatient };
  } else {
    mockPatients.push(currentPatient);
  }
}

setPatients(mockPatients);
```

---

### **2. Doctor Dashboard (`/doctor`)**

**Features:**
- ✅ Monitor assigned patients only
- ✅ Real-time patient status updates
- ✅ Progress tracking (materials + comprehension)
- ✅ Scheduled consent appointments
- ✅ Filter by status (pending, in-progress, ready)
- ✅ Search by name/MRN

**Sync Strategy:**
```typescript
// Load patients for this doctor
const doctorPatients = mockPatients.filter(
  p => p.assignedDoctorId === currentDoctorId
);

// Sync with localStorage
const currentPatient = JSON.parse(localStorage.getItem("currentPatient"));
if (currentPatient && currentPatient.assignedDoctorId === currentDoctorId) {
  // Update patient in list
}
```

**Approval Flow:**
```typescript
// When doctor approves:
1. Doctor selects anesthesia type
2. Update localStorage:
   patient.anesthesiaType = selectedType
   patient.status = "approved"
3. All dashboards auto-sync within 2s
4. Patient dashboard applies auto-filter
```

---

### **3. Patient Dashboard (`/patient`)**

**Features:**
- ✅ Personal dashboard for individual patient
- ✅ Auto-filtered materials based on anesthesia type
- ✅ Progress tracking
- ✅ Comprehension score display
- ✅ Schedule consent feature

**Sync Strategy:**
```typescript
// Load ONLY current patient
const currentPatient = JSON.parse(localStorage.getItem("currentPatient"));
setPatientData(currentPatient);

// Auto-filter materials
const filteredMaterials = allMaterials.filter(
  m => m.type === currentPatient.anesthesiaType
);
```

**Auto-Filter Logic:**
```typescript
// ✅ CRITICAL FEATURE: AUTO-FILTER
const filteredMaterials = patientData?.anesthesiaType
  ? allMaterials.filter((m) => m.type === patientData.anesthesiaType)
  : [];

// Example:
// Patient has: anesthesiaType = "General Anesthesia"
// 
// ALL materials:
// 1. Pengenalan Anestesi Umum (General) ✅
// 2. Persiapan Anestesi Umum (General) ✅
// 3. Prosedur Anestesi Umum (General) ✅
// 4. Pengenalan Anestesi Spinal (Spinal) ❌
// 5. Persiapan Anestesi Spinal (Spinal) ❌
// 6. Prosedur Anestesi Spinal (Spinal) ❌
// 
// FILTERED materials: [1, 2, 3] ONLY
```

---

## 🧪 **TESTING SYNC**

### **Test 1: Patient Registration → Admin/Doctor Sync**

```bash
1. Open /register
2. Fill form: Jordan Smith
3. Submit
4. Open /admin in new tab
   ✅ Should see "Jordan Smith" in patient list
5. Open /doctor in new tab
   ✅ Should see "Jordan Smith" with status "Pending"
```

### **Test 2: Doctor Approval → Patient Sync**

```bash
1. Open /doctor/approval
2. Review Jordan Smith
3. Select "General Anesthesia"
4. Click ACC
5. Open /patient in new tab (as Jordan Smith)
   ✅ Should see ONLY 3 "General Anesthesia" materials
   ✅ Status badge: "Approved"
6. Go back to /admin
   ✅ Status updated to "Approved"
   ✅ Anesthesia type shows "General Anesthesia"
```

### **Test 3: Patient Progress → Admin/Doctor Sync**

```bash
1. Open /patient
2. Click material → Read → Complete section
3. Comprehension score increases to 70%
4. Go to /doctor
   ✅ Progress bar updates to 70%
5. Go to /admin
   ✅ Average comprehension updates
   ✅ Patient status updates
```

### **Test 4: Schedule Consent → All Dashboards Sync**

```bash
1. Open /patient/schedule-consent
2. Select date: "2026-03-10", time: "08:00"
3. Confirm
4. Go to /doctor
   ✅ Scheduled appointment visible
5. Go to /admin
   ✅ Schedule shows in patient detail
```

---

## ⚡ **PERFORMANCE CONSIDERATIONS**

### **Why localStorage?**
- ✅ Simple (no backend needed for prototype)
- ✅ Fast (client-side only)
- ✅ Persistent across page refreshes
- ✅ Easy to debug (inspect in DevTools)

### **Limitations:**
- ❌ Single-user only (no multi-user support)
- ❌ Data lost if localStorage cleared
- ❌ No server-side validation
- ❌ 5-10MB storage limit

### **Production Migration Path:**
```
Phase 1: Prototype (localStorage)
         ↓
Phase 2: Backend API + WebSocket
         ↓
Phase 3: Real-time database (Supabase Realtime)
         ↓
Phase 4: Production with authentication
```

---

## 🔒 **DATA CONSISTENCY**

### **Conflict Resolution:**
```typescript
// If multiple tabs open, last write wins
// Example:
Tab 1: patient.score = 70 (written at 10:00:01)
Tab 2: patient.score = 75 (written at 10:00:02)

// Result: score = 75 (latest write)
```

### **Validation:**
```typescript
// Before writing to localStorage:
1. Validate data structure
2. Sanitize inputs
3. Check required fields
4. Update timestamp

// Example:
const updatePatient = (updates) => {
  const current = JSON.parse(localStorage.getItem("currentPatient"));
  const updated = {
    ...current,
    ...updates,
    updatedAt: new Date().toISOString()
  };
  localStorage.setItem("currentPatient", JSON.stringify(updated));
};
```

---

## 📊 **VISUAL INDICATORS**

### **Sync Status Banners:**

**Admin:**
```tsx
<div className="bg-purple-600 text-white">
  <Activity className="animate-pulse" />
  Dashboard ter-sinkronisasi dengan semua pasien & dokter
</div>
```

**Doctor:**
```tsx
<Badge className="bg-blue-100">
  <Activity className="animate-pulse" />
  Auto-sync setiap 2 detik
</Badge>
```

**Patient:**
```tsx
<div className="bg-green-500 text-white">
  <Activity className="animate-pulse" />
  Dashboard ter-sinkronisasi dengan dokter secara real-time
</div>
```

---

## ✅ **SYNC VERIFICATION CHECKLIST**

Before declaring sync is working:

- [ ] Patient registration appears in Admin dashboard (< 2s)
- [ ] Patient registration appears in Doctor dashboard (< 2s)
- [ ] Doctor approval triggers auto-filter in Patient dashboard (< 2s)
- [ ] Patient progress updates in Doctor dashboard (< 2s)
- [ ] Patient progress updates in Admin dashboard (< 2s)
- [ ] Schedule consent appears in all dashboards (< 2s)
- [ ] Status changes sync across all dashboards (< 2s)
- [ ] Comprehension score updates sync (< 2s)
- [ ] No console errors during sync
- [ ] No data loss during sync

---

## 🐛 **DEBUGGING SYNC ISSUES**

### **Check localStorage:**
```javascript
// In browser console:
console.log(localStorage.getItem("currentPatient"));

// Output:
{
  "id": "patient-001",
  "fullName": "Jordan Smith",
  "anesthesiaType": "General Anesthesia",
  "comprehensionScore": 70,
  ...
}
```

### **Monitor Sync:**
```javascript
// Add to useEffect:
console.log("Sync tick:", new Date().toLocaleTimeString());
console.log("Patient data:", patientData);
```

### **Force Sync:**
```javascript
// Manually trigger sync:
window.location.reload();

// Or clear and resync:
localStorage.removeItem("currentPatient");
window.location.reload();
```

---

## 🎯 **KEY TAKEAWAYS**

1. ✅ **localStorage = Central Data Store**
2. ✅ **Auto-sync every 2 seconds** (all dashboards)
3. ✅ **3-way sync:** Admin ↔ Doctor ↔ Patient
4. ✅ **Auto-filter triggered** by anesthesia type change
5. ✅ **Visual indicators** show sync status
6. ✅ **Real-time feel** without backend complexity
7. ✅ **Production-ready** for user testing/demo
8. ✅ **Easy migration** to real backend later

---

**Last Updated:** March 9, 2026  
**Version:** 2.0 (Enhanced with real-time sync)

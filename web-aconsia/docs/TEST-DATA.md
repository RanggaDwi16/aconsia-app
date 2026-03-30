# 🗃️ TEST DATA SEED

## 📋 **PATIENT TEST DATA**

### **Patient 1: Jordan Smith (General Anesthesia)**
```json
{
  "id": "patient-001",
  "userId": "user-001",
  "fullName": "Jordan Smith",
  "mrn": "MRN-2026-001",
  "dateOfBirth": "1985-01-15",
  "age": 41,
  "gender": "Male",
  "phone": "+62 812-3456-7890",
  "email": "jordan.smith@email.com",
  "address": "Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10110",
  "surgeryType": "Laparoscopic Appendectomy",
  "surgeryDate": "2026-03-15",
  "asaStatus": "ASA II",
  "anesthesiaType": "General Anesthesia",
  "medicalHistory": "Hypertension (controlled with medication)",
  "allergies": "None",
  "medications": "Amlodipine 5mg daily",
  "status": "approved",
  "assignedDoctorId": "doctor-001",
  "comprehensionScore": 0
}
```

### **Patient 2: Sarah Johnson (Spinal Anesthesia)**
```json
{
  "id": "patient-002",
  "userId": "user-002",
  "fullName": "Sarah Johnson",
  "mrn": "MRN-2026-002",
  "dateOfBirth": "1990-05-22",
  "age": 35,
  "gender": "Female",
  "phone": "+62 821-9876-5432",
  "email": "sarah.johnson@email.com",
  "address": "Jl. Gatot Subroto No. 456, Jakarta Selatan, DKI Jakarta 12950",
  "surgeryType": "Cesarean Section",
  "surgeryDate": "2026-03-20",
  "asaStatus": "ASA I",
  "anesthesiaType": "Spinal Anesthesia",
  "medicalHistory": "Healthy, no significant medical history",
  "allergies": "None",
  "medications": "Prenatal vitamins",
  "status": "approved",
  "assignedDoctorId": "doctor-001",
  "comprehensionScore": 0
}
```

### **Patient 3: Michael Chen (Epidural Anesthesia)**
```json
{
  "id": "patient-003",
  "userId": "user-003",
  "fullName": "Michael Chen",
  "mrn": "MRN-2026-003",
  "dateOfBirth": "1978-11-08",
  "age": 47,
  "gender": "Male",
  "phone": "+62 813-5555-1234",
  "email": "michael.chen@email.com",
  "address": "Jl. Thamrin No. 789, Jakarta Pusat, DKI Jakarta 10230",
  "surgeryType": "Lower Limb Orthopedic Surgery",
  "surgeryDate": "2026-03-18",
  "asaStatus": "ASA II",
  "anesthesiaType": "Epidural Anesthesia",
  "medicalHistory": "Type 2 Diabetes (controlled)",
  "allergies": "Penicillin",
  "medications": "Metformin 500mg twice daily",
  "status": "approved",
  "assignedDoctorId": "doctor-002",
  "comprehensionScore": 0
}
```

---

## 👨‍⚕️ **DOCTOR TEST DATA**

### **Doctor 1: Dr. Ahmad Suryadi, Sp.An**
```json
{
  "id": "doctor-001",
  "userId": "doc-user-001",
  "fullName": "Dr. Ahmad Suryadi, Sp.An",
  "email": "ahmad.suryadi@rspusatjakarta.com",
  "phone": "+62 811-2222-3333",
  "str": "STR-AN-2018-123456",
  "sip": "SIP-AN-2023-JKT-00789",
  "sipExpiry": "2028-06-15",
  "specialization": "Anestesiologi & Terapi Intensif",
  "hospital": "RS Pusat Jakarta",
  "experienceYears": 15,
  "education": "Fakultas Kedokteran Universitas Indonesia (FKUI)",
  "certifications": [
    "Board Certified Anesthesiologist",
    "Advanced Cardiac Life Support (ACLS)",
    "Pediatric Advanced Life Support (PALS)"
  ]
}
```

### **Doctor 2: Dr. Siti Rahmawati, Sp.An**
```json
{
  "id": "doctor-002",
  "userId": "doc-user-002",
  "fullName": "Dr. Siti Rahmawati, Sp.An",
  "email": "siti.rahmawati@rspusatjakarta.com",
  "phone": "+62 812-4444-5555",
  "str": "STR-AN-2019-789012",
  "sip": "SIP-AN-2024-JKT-01234",
  "sipExpiry": "2029-01-20",
  "specialization": "Anestesiologi & Obstetric Anesthesia",
  "hospital": "RS Pusat Jakarta",
  "experienceYears": 12,
  "education": "Fakultas Kedokteran Universitas Gadjah Mada (UGM)",
  "certifications": [
    "Board Certified Anesthesiologist",
    "Obstetric Anesthesia Specialist",
    "Advanced Trauma Life Support (ATLS)"
  ]
}
```

---

## 📚 **MATERIALS TEST DATA**

### **General Anesthesia Materials**
```json
[
  {
    "id": "1",
    "title": "Pengenalan Anestesi Umum",
    "description": "Memahami dasar-dasar anestesi umum sebelum operasi",
    "type": "General Anesthesia",
    "estimatedTime": "15 menit",
    "sections": 5,
    "imageUrl": "https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=800"
  },
  {
    "id": "2",
    "title": "Persiapan Sebelum Anestesi Umum",
    "description": "Hal-hal yang perlu dipersiapkan sebelum menjalani anestesi umum",
    "type": "General Anesthesia",
    "estimatedTime": "10 menit",
    "sections": 4,
    "imageUrl": "https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800"
  },
  {
    "id": "3",
    "title": "Prosedur Anestesi Umum",
    "description": "Tahapan dan proses pemberian anestesi umum",
    "type": "General Anesthesia",
    "estimatedTime": "20 menit",
    "sections": 6,
    "imageUrl": "https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?w=800"
  }
]
```

### **Spinal Anesthesia Materials**
```json
[
  {
    "id": "4",
    "title": "Pengenalan Anestesi Spinal",
    "description": "Memahami anestesi spinal untuk operasi bagian bawah tubuh",
    "type": "Spinal Anesthesia",
    "estimatedTime": "15 menit",
    "sections": 5,
    "imageUrl": "https://images.unsplash.com/photo-1579154204601-01588f351e67?w=800"
  },
  {
    "id": "5",
    "title": "Persiapan Anestesi Spinal",
    "description": "Persiapan khusus untuk anestesi spinal",
    "type": "Spinal Anesthesia",
    "estimatedTime": "12 menit",
    "sections": 4,
    "imageUrl": "https://images.unsplash.com/photo-1584982751601-97dcc096659c?w=800"
  },
  {
    "id": "6",
    "title": "Prosedur Anestesi Spinal",
    "description": "Tahapan pemberian anestesi spinal",
    "type": "Spinal Anesthesia",
    "estimatedTime": "18 menit",
    "sections": 5,
    "imageUrl": "https://images.unsplash.com/photo-1582719471384-894fbb16e074?w=800"
  }
]
```

### **Epidural Anesthesia Materials**
```json
[
  {
    "id": "7",
    "title": "Anestesi Epidural: Panduan Lengkap",
    "description": "Memahami teknik anestesi epidural",
    "type": "Epidural Anesthesia",
    "estimatedTime": "18 menit",
    "sections": 5,
    "imageUrl": "https://images.unsplash.com/photo-1581056771107-24ca5f033842?w=800"
  },
  {
    "id": "8",
    "title": "Persiapan Anestesi Epidural",
    "description": "Persiapan khusus untuk anestesi epidural",
    "type": "Epidural Anesthesia",
    "estimatedTime": "14 menit",
    "sections": 4,
    "imageUrl": "https://images.unsplash.com/photo-1579684453423-f84349ef60b0?w=800"
  }
]
```

---

## 💬 **CHAT TEST DATA (AI Proactive Questions)**

### **General Anesthesia Questions**
```json
[
  {
    "id": "q1",
    "question": "Mengapa pasien harus puasa 6-8 jam sebelum operasi dengan anestesi umum?",
    "options": [
      "Ya, untuk mencegah aspirasi (cairan lambung masuk paru-paru)",
      "Ya, tapi saya belum tahu alasannya secara detail",
      "Tidak yakin, bisa jelaskan lebih detail?",
      "💬 Saya ingin menjelaskan dengan kata-kata sendiri"
    ],
    "correctAnswer": 0,
    "keywords": ["aspirasi", "puasa", "lambung", "paru"],
    "explanation": "Puasa sebelum operasi sangat penting untuk mencegah aspirasi, yaitu masuknya cairan atau makanan dari lambung ke saluran pernapasan saat pasien tidak sadar."
  },
  {
    "id": "q2",
    "question": "Apa yang sebaiknya Anda lakukan jika memiliki riwayat alergi obat?",
    "options": [
      "Memberitahu tim anestesi sebelum operasi",
      "Tidak perlu memberitahu karena tidak penting",
      "Menunggu sampai ditanya saat operasi",
      "💬 Saya ingin menjelaskan dengan kata-kata sendiri"
    ],
    "correctAnswer": 0,
    "keywords": ["alergi", "memberitahu", "tim", "anestesi"],
    "explanation": "Sangat penting memberitahu tim anestesi tentang alergi obat untuk mencegah reaksi alergi yang berbahaya selama operasi."
  },
  {
    "id": "q3",
    "question": "Apa yang terjadi setelah operasi selesai dan anestesi dihentikan?",
    "options": [
      "Pasien langsung bangun dan bisa pulang",
      "Pasien dipantau di ruang pemulihan hingga sadar penuh",
      "Pasien tidur sampai besok pagi",
      "💬 Saya ingin menjelaskan dengan kata-kata sendiri"
    ],
    "correctAnswer": 1,
    "keywords": ["pemulihan", "monitoring", "sadar", "ruang"],
    "explanation": "Setelah operasi, pasien akan dipantau di ruang pemulihan (recovery room) hingga sadar penuh dan kondisi vital stabil sebelum dipindahkan ke ruang rawat."
  }
]
```

---

## 📅 **SCHEDULE TEST DATA**

### **Available Time Slots**
```json
{
  "hospital": "RS Pusat Jakarta",
  "location": "Ruang Konsultasi Anestesi, Lt. 2",
  "availableSlots": [
    {
      "date": "2026-03-10",
      "times": ["08:00", "09:00", "10:00", "13:00", "14:00", "15:00"]
    },
    {
      "date": "2026-03-11",
      "times": ["08:00", "09:00", "10:00", "11:00", "13:00", "14:00"]
    },
    {
      "date": "2026-03-12",
      "times": ["08:00", "10:00", "13:00", "15:00"]
    }
  ],
  "workingHours": {
    "start": "08:00",
    "end": "17:00",
    "lunchBreak": "12:00-13:00"
  }
}
```

---

## 🎯 **TESTING SCENARIOS**

### **Scenario 1: Happy Path (General Anesthesia)**
```
Patient: Jordan Smith
Doctor: Dr. Ahmad Suryadi
Anesthesia: General Anesthesia
Expected Materials: 3 items (IDs: 1, 2, 3)
Expected Questions: 3 questions
Expected Score: 85% (after completion)
Schedule: 2026-03-10, 08:00
```

### **Scenario 2: Alternative Path (Spinal Anesthesia)**
```
Patient: Sarah Johnson
Doctor: Dr. Ahmad Suryadi
Anesthesia: Spinal Anesthesia
Expected Materials: 3 items (IDs: 4, 5, 6)
Expected Questions: 3 questions (spinal-specific)
Expected Score: 80% (after completion)
Schedule: 2026-03-11, 09:00
```

### **Scenario 3: Low Score Path**
```
Patient: Michael Chen
Doctor: Dr. Siti Rahmawati
Anesthesia: Epidural Anesthesia
Expected Materials: 2 items (IDs: 7, 8)
Deliberate wrong answers: Score < 80%
Expected: Cannot schedule (blocked)
Action: Re-read materials or re-chat
```

---

## 🔄 **SEED SCRIPT (Copy to Console)**

```javascript
// Clear existing data
localStorage.clear();

// Seed test patient
const testPatient = {
  id: "patient-001",
  userId: "user-001",
  fullName: "Jordan Smith",
  mrn: "MRN-2026-001",
  dateOfBirth: "1985-01-15",
  age: 41,
  gender: "Male",
  phone: "+62 812-3456-7890",
  email: "jordan.smith@email.com",
  address: "Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10110",
  surgeryType: "Laparoscopic Appendectomy",
  surgeryDate: "2026-03-15",
  asaStatus: "ASA II",
  anesthesiaType: "General Anesthesia",
  medicalHistory: "Hypertension (controlled with medication)",
  allergies: "None",
  medications: "Amlodipine 5mg daily",
  status: "approved",
  assignedDoctorId: "doctor-001",
  comprehensionScore: 0
};

localStorage.setItem("currentPatient", JSON.stringify(testPatient));

console.log("✅ Test patient seeded!");
console.log("Navigate to /patient to see auto-filtered materials");
```

---

## 🧹 **CLEANUP SCRIPT (Reset State)**

```javascript
// Clear all localStorage
localStorage.clear();

// Reload page
window.location.reload();

console.log("✅ All test data cleared!");
```

---

## 📊 **EXPECTED RESULTS BY ANESTHESIA TYPE**

| Anesthesia Type | Materials Count | Material IDs | Questions | Min Score |
|-----------------|-----------------|--------------|-----------|-----------|
| General Anesthesia | 3 | 1, 2, 3 | 3 | 80% |
| Spinal Anesthesia | 3 | 4, 5, 6 | 3 | 80% |
| Epidural Anesthesia | 2 | 7, 8 | 3 | 80% |
| Regional Anesthesia | 2 | 9, 10 | 3 | 80% |
| Local + Sedation | 2 | 11, 12 | 3 | 80% |

---

## ✅ **VALIDATION CHECKLIST**

After seeding data, verify:

- [ ] Patient data in localStorage
- [ ] Dashboard shows correct status
- [ ] Materials filtered by anesthesia type
- [ ] Material count matches expected
- [ ] No materials from other types visible
- [ ] Progress tracking starts at 0%
- [ ] Comprehension score starts at 0%
- [ ] Doctor info displays correctly

---

**Use this data for consistent testing!** 🎯

Copy the seed script to browser console untuk quick setup.

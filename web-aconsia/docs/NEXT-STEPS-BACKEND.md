# 🚀 TAHAP BERIKUTNYA: BACKEND INTEGRATION

## ✅ **YANG SUDAH SELESAI (FRONTEND)**

- ✅ UI/UX Complete (sesuai design Figma)
- ✅ Real-time timer visible
- ✅ Online/offline indicator ("Kembali online!")
- ✅ Quick reply buttons
- ✅ Full identity display (patient + doctor)
- ✅ Anti-skip system
- ✅ Progress tracking (client-side)
- ✅ All routing configured

---

## 🎯 **TAHAP BERIKUTNYA: BACKEND INTEGRATION**

### **Phase 1: Supabase Setup** 🗄️

#### **1.1 Database Tables**
```sql
-- Users table (extends Supabase auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  role TEXT CHECK (role IN ('patient', 'doctor', 'admin')),
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Patients table
CREATE TABLE patients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id),
  mrn TEXT UNIQUE NOT NULL,
  date_of_birth DATE,
  age INTEGER,
  gender TEXT,
  address TEXT,
  surgery_type TEXT,
  surgery_date DATE,
  asa_status TEXT,
  anesthesia_type TEXT,
  medical_history TEXT,
  allergies TEXT,
  medications TEXT,
  status TEXT DEFAULT 'pending', -- pending, approved, completed
  assigned_doctor_id UUID REFERENCES profiles(id),
  comprehension_score INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Doctors table
CREATE TABLE doctors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id),
  str TEXT,
  sip TEXT,
  sip_expiry DATE,
  specialization TEXT,
  hospital TEXT,
  experience_years INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Materials table
CREATE TABLE materials (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  anesthesia_type TEXT NOT NULL,
  content JSONB, -- Array of sections
  image_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Reading progress table
CREATE TABLE reading_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES patients(id),
  material_id UUID REFERENCES materials(id),
  section_id TEXT,
  time_spent INTEGER DEFAULT 0,
  is_completed BOOLEAN DEFAULT FALSE,
  checkpoint_attempts INTEGER DEFAULT 0,
  checkpoint_passed BOOLEAN DEFAULT FALSE,
  last_updated TIMESTAMP DEFAULT NOW(),
  UNIQUE(patient_id, material_id, section_id)
);

-- AI Chat history table
CREATE TABLE chat_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES patients(id),
  message_type TEXT CHECK (message_type IN ('ai', 'user')),
  content TEXT NOT NULL,
  question_type TEXT,
  options JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

-- AI Recommendations table
CREATE TABLE ai_recommendations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES patients(id),
  material_id UUID REFERENCES materials(id),
  reason TEXT,
  priority INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Consent schedule table
CREATE TABLE consent_schedules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES patients(id),
  doctor_id UUID REFERENCES profiles(id),
  scheduled_date DATE NOT NULL,
  scheduled_time TIME NOT NULL,
  location TEXT,
  status TEXT DEFAULT 'scheduled', -- scheduled, completed, cancelled
  created_at TIMESTAMP DEFAULT NOW()
);

-- Analytics/Metrics table
CREATE TABLE analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES patients(id),
  event_type TEXT NOT NULL,
  event_data JSONB,
  timestamp TIMESTAMP DEFAULT NOW()
);
```

#### **1.2 Row Level Security (RLS)**
```sql
-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE reading_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE consent_schedules ENABLE ROW LEVEL SECURITY;

-- Policies
-- Patients can only see their own data
CREATE POLICY "Patients can view own data"
  ON patients FOR SELECT
  USING (user_id = auth.uid());

-- Doctors can see assigned patients
CREATE POLICY "Doctors can view assigned patients"
  ON patients FOR SELECT
  USING (
    assigned_doctor_id IN (
      SELECT id FROM profiles WHERE auth.uid() = user_id AND role = 'doctor'
    )
  );

-- Similar policies for other tables...
```

---

### **Phase 2: Supabase Edge Functions (Hono Server)** 🌐

#### **2.1 Server Structure**
```
/supabase/functions/server/
  ├── index.tsx              # Main Hono server
  ├── routes/
  │   ├── auth.tsx           # Authentication routes
  │   ├── patients.tsx       # Patient CRUD
  │   ├── materials.tsx      # Materials CRUD
  │   ├── progress.tsx       # Reading progress tracking
  │   ├── chat.tsx           # AI chat integration
  │   ├── schedule.tsx       # Consent scheduling
  │   └── analytics.tsx      # Analytics endpoints
  ├── middleware/
  │   ├── auth.tsx           # JWT verification
  │   └── cors.tsx           # CORS configuration
  └── utils/
      ├── supabase.tsx       # Supabase client
      └── openai.tsx         # OpenAI integration
```

#### **2.2 Example: Progress Tracking Route**
```typescript
// /supabase/functions/server/routes/progress.tsx
import { Hono } from 'npm:hono';
import { createClient } from 'npm:@supabase/supabase-js';

const app = new Hono();

// Save reading progress
app.post('/make-server-df0576bc/progress/save', async (c) => {
  const { patientId, materialId, sectionId, timeSpent, isCompleted } = await c.req.json();
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL'),
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  );

  const { data, error } = await supabase
    .from('reading_progress')
    .upsert({
      patient_id: patientId,
      material_id: materialId,
      section_id: sectionId,
      time_spent: timeSpent,
      is_completed: isCompleted,
      last_updated: new Date(),
    }, {
      onConflict: 'patient_id,material_id,section_id'
    });

  if (error) {
    return c.json({ error: error.message }, 500);
  }

  // Calculate comprehension score
  const { data: allProgress } = await supabase
    .from('reading_progress')
    .select('*')
    .eq('patient_id', patientId)
    .eq('material_id', materialId);

  const completedSections = allProgress?.filter(p => p.is_completed).length || 0;
  const totalSections = allProgress?.length || 1;
  const comprehensionScore = Math.round((completedSections / totalSections) * 100);

  // Update patient comprehension score
  await supabase
    .from('patients')
    .update({ comprehension_score: comprehensionScore })
    .eq('id', patientId);

  return c.json({ 
    success: true, 
    comprehensionScore 
  });
});

// Get reading progress
app.get('/make-server-df0576bc/progress/:patientId/:materialId', async (c) => {
  const { patientId, materialId } = c.req.param();
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL'),
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  );

  const { data, error } = await supabase
    .from('reading_progress')
    .select('*')
    .eq('patient_id', patientId)
    .eq('material_id', materialId);

  if (error) {
    return c.json({ error: error.message }, 500);
  }

  return c.json({ progress: data });
});

export default app;
```

---

### **Phase 3: OpenAI Integration** 🤖

#### **3.1 AI Proactive Chat**
```typescript
// /supabase/functions/server/utils/openai.tsx
import { OpenAI } from 'npm:openai';

const openai = new OpenAI({
  apiKey: Deno.env.get('OPENAI_API_KEY'),
});

export async function generateProactiveQuestion(
  patientHistory: any[],
  currentTopic: string,
  weakAreas: string[]
) {
  const systemPrompt = `Anda adalah AI Assistant untuk edukasi informed consent anestesi. 
  Tugas Anda adalah menanyakan pertanyaan PROAKTIF untuk menguji pemahaman pasien.
  
  Karakteristik:
  - Gunakan bahasa Indonesia yang ramah dan profesional
  - Pertanyaan harus spesifik tentang konten yang baru dibaca
  - Berikan 3-4 pilihan jawaban
  - Deteksi area lemah dan fokuskan pertanyaan di sana
  - Jangan terlalu mudah atau terlalu sulit
  
  Current topic: ${currentTopic}
  Weak areas: ${weakAreas.join(', ')}
  `;

  const completion = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [
      { role: 'system', content: systemPrompt },
      ...patientHistory,
      { 
        role: 'user', 
        content: 'Buatkan pertanyaan proaktif berikutnya dengan format JSON: { "question": "...", "options": ["...", "..."], "correctAnswer": 0, "explanation": "..." }' 
      }
    ],
    response_format: { type: 'json_object' },
    temperature: 0.7,
  });

  return JSON.parse(completion.choices[0].message.content);
}

export async function analyzePatientResponse(
  question: string,
  patientAnswer: string,
  correctAnswer: string
) {
  const completion = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [
      { 
        role: 'system', 
        content: 'Analisis jawaban pasien dan berikan feedback yang konstruktif dalam Bahasa Indonesia.' 
      },
      { 
        role: 'user', 
        content: `Pertanyaan: ${question}\nJawaban pasien: ${patientAnswer}\nJawaban benar: ${correctAnswer}\n\nBerikan feedback dan deteksi apakah ada area pemahaman yang lemah.` 
      }
    ],
    temperature: 0.8,
  });

  return completion.choices[0].message.content;
}

export async function generateMaterialRecommendation(
  weakAreas: string[],
  completedMaterials: string[]
) {
  const completion = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [
      { 
        role: 'system', 
        content: 'Anda adalah AI yang merekomendasikan materi pembelajaran berdasarkan area lemah pasien.' 
      },
      { 
        role: 'user', 
        content: `Weak areas: ${weakAreas.join(', ')}\nCompleted materials: ${completedMaterials.join(', ')}\n\nRekomendasi materi apa yang sebaiknya dibaca pasien selanjutnya? (JSON format: { "materialId": "...", "reason": "..." })` 
      }
    ],
    response_format: { type: 'json_object' },
    temperature: 0.6,
  });

  return JSON.parse(completion.choices[0].message.content);
}
```

#### **3.2 AI Chat Route**
```typescript
// /supabase/functions/server/routes/chat.tsx
import { Hono } from 'npm:hono';
import { generateProactiveQuestion, analyzePatientResponse } from '../utils/openai.tsx';

const app = new Hono();

app.post('/make-server-df0576bc/chat/ask', async (c) => {
  const { patientId, currentTopic, weakAreas } = await c.req.json();
  
  // Get chat history
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL'),
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  );

  const { data: history } = await supabase
    .from('chat_history')
    .select('*')
    .eq('patient_id', patientId)
    .order('created_at', { ascending: true });

  // Generate proactive question
  const question = await generateProactiveQuestion(
    history || [],
    currentTopic,
    weakAreas
  );

  // Save to database
  await supabase
    .from('chat_history')
    .insert({
      patient_id: patientId,
      message_type: 'ai',
      content: question.question,
      question_type: 'proactive',
      options: question.options,
    });

  return c.json(question);
});

app.post('/make-server-df0576bc/chat/answer', async (c) => {
  const { patientId, question, answer, correctAnswer } = await c.req.json();
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL'),
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  );

  // Save user answer
  await supabase
    .from('chat_history')
    .insert({
      patient_id: patientId,
      message_type: 'user',
      content: answer,
    });

  // Analyze response
  const feedback = await analyzePatientResponse(question, answer, correctAnswer);

  // Save AI feedback
  await supabase
    .from('chat_history')
    .insert({
      patient_id: patientId,
      message_type: 'ai',
      content: feedback,
      question_type: 'assessment',
    });

  return c.json({ feedback });
});

export default app;
```

---

### **Phase 4: Frontend Integration** 🔗

#### **4.1 Supabase Client Setup**
```typescript
// /src/utils/supabase/client.ts
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

#### **4.2 Real-time Progress Sync**
```typescript
// /src/app/pages/patient/EnhancedMaterialReader.tsx
import { supabase } from '../../../utils/supabase/client';

// Save progress to backend
const saveProgressToBackend = async (sectionId: string, timeSpent: number, isCompleted: boolean) => {
  try {
    const response = await fetch(`${serverUrl}/progress/save`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${publicAnonKey}`,
      },
      body: JSON.stringify({
        patientId: currentPatient.id,
        materialId,
        sectionId,
        timeSpent,
        isCompleted,
      }),
    });

    const data = await response.json();
    
    if (data.success) {
      setComprehensionScore(data.comprehensionScore);
    }
  } catch (error) {
    console.error('Error saving progress:', error);
  }
};

// Call this in completeSectionAndUnlockNext
const completeSectionAndUnlockNext = (sectionId: string) => {
  setSections(prev => {
    // ... existing logic
  });

  // SAVE TO BACKEND
  const section = sections.find(s => s.id === sectionId);
  if (section) {
    saveProgressToBackend(sectionId, section.timeSpent, true);
  }

  stopSectionTimer(sectionId);
  setActiveSection(null);
};

// Load progress from backend on mount
useEffect(() => {
  const loadProgress = async () => {
    try {
      const response = await fetch(
        `${serverUrl}/progress/${currentPatient.id}/${materialId}`,
        {
          headers: {
            'Authorization': `Bearer ${publicAnonKey}`,
          },
        }
      );

      const data = await response.json();
      
      if (data.progress) {
        // Restore sections state from backend
        setSections(prev => prev.map(section => {
          const savedProgress = data.progress.find(p => p.section_id === section.id);
          if (savedProgress) {
            return {
              ...section,
              timeSpent: savedProgress.time_spent,
              isCompleted: savedProgress.is_completed,
              isUnlocked: savedProgress.is_completed || section.id === '1',
            };
          }
          return section;
        }));
      }
    } catch (error) {
      console.error('Error loading progress:', error);
    }
  };

  loadProgress();
}, [materialId]);
```

#### **4.3 AI Chat Integration**
```typescript
// /src/app/pages/patient/ProactiveChatbot.tsx
import { supabase } from '../../../utils/supabase/client';

const fetchNextQuestion = async () => {
  try {
    const response = await fetch(`${serverUrl}/chat/ask`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${publicAnonKey}`,
      },
      body: JSON.stringify({
        patientId: currentPatient.id,
        currentTopic: 'Anestesi Umum',
        weakAreas: weakAreas,
      }),
    });

    const question = await response.json();
    
    addAIMessage(question.question, 'proactive', question.options);
  } catch (error) {
    console.error('Error fetching question:', error);
  }
};

const submitAnswer = async (answer: string) => {
  try {
    const response = await fetch(`${serverUrl}/chat/answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${publicAnonKey}`,
      },
      body: JSON.stringify({
        patientId: currentPatient.id,
        question: currentQuestion,
        answer,
        correctAnswer: correctAnswerText,
      }),
    });

    const data = await response.json();
    
    addAIMessage(data.feedback, 'assessment');
    
    // Update comprehension score
    setComprehensionScore(prev => Math.min(prev + 5, 100));
  } catch (error) {
    console.error('Error submitting answer:', error);
  }
};
```

---

### **Phase 5: Real-time Features** ⚡

#### **5.1 Supabase Realtime Subscriptions**
```typescript
// Real-time progress updates (for doctor dashboard)
useEffect(() => {
  const channel = supabase
    .channel('reading_progress_changes')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'reading_progress',
        filter: `patient_id=eq.${patientId}`,
      },
      (payload) => {
        console.log('Progress updated:', payload);
        // Update UI with new progress
        refetchProgress();
      }
    )
    .subscribe();

  return () => {
    supabase.removeChannel(channel);
  };
}, [patientId]);
```

#### **5.2 Online Status Sync**
```typescript
// Sync online status across tabs
useEffect(() => {
  const channel = supabase.channel('online_status');
  
  channel
    .on('presence', { event: 'sync' }, () => {
      const state = channel.presenceState();
      console.log('Online users:', state);
    })
    .subscribe(async (status) => {
      if (status === 'SUBSCRIBED') {
        await channel.track({
          user: currentUser.id,
          online_at: new Date().toISOString(),
        });
      }
    });

  return () => {
    supabase.removeChannel(channel);
  };
}, []);
```

---

### **Phase 6: PWA Features** 📱

#### **6.1 Service Worker for Offline**
```javascript
// /public/service-worker.js
const CACHE_NAME = 'aconsia-v1';
const urlsToCache = [
  '/',
  '/demo',
  '/patient',
  '/patient/material/1',
  // ... other routes
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => response || fetch(event.request))
  );
});
```

#### **6.2 Push Notifications**
```typescript
// Request permission
const requestNotificationPermission = async () => {
  const permission = await Notification.requestPermission();
  if (permission === 'granted') {
    const registration = await navigator.serviceWorker.ready;
    await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: VAPID_PUBLIC_KEY,
    });
  }
};

// Send notification (from backend)
await supabase.functions.invoke('send-push-notification', {
  body: {
    userId: patientId,
    title: 'Reminder: Jadwal Konsultasi Besok',
    body: 'Jangan lupa jadwal informed consent Anda besok pukul 08:00',
  },
});
```

---

## 📊 **Implementation Checklist**

### **Week 1: Database Setup**
- [ ] Create Supabase project
- [ ] Run SQL migrations
- [ ] Set up RLS policies
- [ ] Test CRUD operations
- [ ] Seed initial data

### **Week 2: Backend API**
- [ ] Set up Hono server structure
- [ ] Implement auth routes
- [ ] Implement patient routes
- [ ] Implement progress tracking
- [ ] Test all endpoints

### **Week 3: OpenAI Integration**
- [ ] Set up OpenAI API key
- [ ] Implement proactive question generator
- [ ] Implement response analyzer
- [ ] Implement recommendation engine
- [ ] Test AI responses

### **Week 4: Frontend Integration**
- [ ] Connect EnhancedMaterialReader to backend
- [ ] Connect ProactiveChatbot to OpenAI
- [ ] Implement real-time sync
- [ ] Add loading states
- [ ] Handle errors gracefully

### **Week 5: PWA & Polish**
- [ ] Service worker setup
- [ ] Push notifications
- [ ] Offline mode
- [ ] Performance optimization
- [ ] Final testing

---

## 🔐 **Environment Variables**

```env
# Frontend (.env)
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJxxx...
VITE_SERVER_URL=https://xxx.supabase.co/functions/v1/make-server-df0576bc

# Backend (Supabase Dashboard)
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJxxx...
SUPABASE_SERVICE_ROLE_KEY=eyJxxx...
SUPABASE_DB_URL=postgresql://...
OPENAI_API_KEY=sk-xxx...
VAPID_PUBLIC_KEY=xxx...
VAPID_PRIVATE_KEY=xxx...
```

---

## 🎯 **Success Criteria**

- ✅ Progress syncs across devices real-time
- ✅ AI generates relevant proactive questions
- ✅ Comprehension score calculated accurately
- ✅ Offline mode works (read-only)
- ✅ Push notifications sent H-1
- ✅ Doctor dashboard shows live patient progress
- ✅ All data persisted in database
- ✅ <100ms API response time
- ✅ 99.9% uptime

---

**Next:** Choose which phase to start with! 🚀

**Recommendation:** Start with **Phase 1 (Database Setup)** first for solid foundation.

**Status:** ⏳ Ready to implement  
**Last Updated:** March 7, 2026

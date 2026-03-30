# 📱 PWA (Progressive Web App) - Setup & Guide

## 🎯 Apa itu PWA?

**Progressive Web App** adalah aplikasi web yang bisa diinstall seperti aplikasi mobile native. Aplikasi Anda sekarang sudah menjadi **PWA** yang bisa:

✅ **Diinstall di HP** seperti app biasa (Android & iOS)  
✅ **Bekerja Offline** - baca materi tanpa internet  
✅ **Push Notifications** - reminder operasi  
✅ **Fast Loading** - caching otomatis  
✅ **Home Screen Icon** - akses cepat dari home screen  

---

## 📲 Cara Install (untuk User)

### **Di Android:**

1. Buka website di **Chrome** atau **Samsung Internet**
2. Akan muncul popup "Add to Home Screen" / "Install app"
3. Klik **Install** atau **Add**
4. Icon aplikasi akan muncul di home screen
5. Buka seperti aplikasi biasa!

**Atau manual:**
- Tap menu (⋮) di browser
- Pilih **"Add to Home Screen"**
- Klik **Add**

### **Di iOS (iPhone/iPad):**

1. Buka website di **Safari** (harus Safari, bukan Chrome!)
2. Tap tombol **Share** (kotak dengan panah ke atas)
3. Scroll dan pilih **"Add to Home Screen"**
4. Tap **Add**
5. Icon aplikasi akan muncul di home screen

### **Di Desktop (Windows/Mac/Linux):**

1. Buka di **Chrome**, **Edge**, atau **Brave**
2. Klik icon **install** (⊕) di address bar
3. Klik **Install**
4. App akan terbuka di window tersendiri

---

## 🔧 Fitur PWA yang Sudah Diimplementasikan

### 1. **Manifest File** ✅
File: `/public/manifest.json`

Mendefinisikan:
- ✅ Nama & deskripsi app
- ✅ Icon (192x192 dan 512x512)
- ✅ Theme color (biru)
- ✅ Display mode (standalone)
- ✅ Orientation (portrait)
- ✅ Shortcuts (Dashboard, Chatbot, Edukasi)

### 2. **Service Worker** ✅
File: `/public/sw.js`

Fitur:
- ✅ **Offline Caching** - cache assets penting
- ✅ **Network First Strategy** - prioritas network, fallback cache
- ✅ **Push Notifications** - terima notifikasi
- ✅ **Background Sync** - sync data saat online kembali
- ✅ **Periodic Sync** - cek reminder otomatis

### 3. **Offline Page** ✅
File: `/public/offline.html`

Halaman cantik saat user offline, dengan info:
- ✅ Status offline
- ✅ Fitur yang masih bisa diakses
- ✅ Tombol retry
- ✅ Auto reload saat online kembali

### 4. **Install Prompt** ✅
Component: `/src/app/components/InstallPrompt.tsx`

Fitur:
- ✅ Muncul otomatis saat app bisa diinstall
- ✅ Button "Install Sekarang"
- ✅ Bisa di-dismiss
- ✅ Responsive (mobile & desktop)

### 5. **Offline Indicator** ✅
Component: `/src/app/components/OfflineIndicator.tsx`

Fitur:
- ✅ Banner kuning saat offline
- ✅ Banner hijau saat kembali online
- ✅ Animasi smooth (Motion)

### 6. **PWA Hooks** ✅
File: `/src/app/hooks/usePWA.ts`

Custom hooks:
- ✅ `usePWA()` - detect installable, installed, online/offline
- ✅ `useNotification()` - request permission, send notification

---

## 🚀 Testing PWA

### **Test di Local:**

1. Build production:
```bash
npm run build
# atau
pnpm run build
```

2. Serve build:
```bash
npx serve dist -p 4173
```

3. Buka di browser: `http://localhost:4173`

4. Test features:
   - ✅ Install prompt muncul?
   - ✅ Bisa install ke home screen?
   - ✅ Icon muncul di home screen?
   - ✅ Buka app, feels native?
   - ✅ Matikan WiFi, masih bisa akses?
   - ✅ Offline page muncul?

### **Test di Mobile Device:**

#### **Option 1: Local Network**
```bash
# Get your IP address
ipconfig  # Windows
ifconfig  # Mac/Linux

# Serve on network
npx serve dist -p 4173 -s
# Access from phone: http://YOUR_IP:4173
```

#### **Option 2: ngrok (Recommended)**
```bash
# Install ngrok
npm install -g ngrok

# Expose local server
ngrok http 4173

# Access from phone using ngrok URL
# Example: https://abc123.ngrok.io
```

#### **Option 3: Deploy to Vercel/Netlify**
```bash
# Deploy to Vercel (easiest)
npm install -g vercel
vercel

# Atau deploy ke Netlify
netlify deploy --prod
```

---

## 📊 PWA Audit (Lighthouse)

### **Cara Check PWA Score:**

1. Buka app di Chrome
2. Tekan **F12** (DevTools)
3. Tab **Lighthouse**
4. Category: pilih **"Progressive Web App"**
5. Click **"Analyze page load"**

### **Target Score:**

- ✅ PWA Score: **90+** (Good)
- ✅ Performance: **80+** (Good)
- ✅ Accessibility: **90+** (Good)
- ✅ Best Practices: **90+** (Good)
- ✅ SEO: **90+** (Good)

### **Common Issues & Fix:**

| Issue | Fix |
|-------|-----|
| "Page does not work offline" | Service Worker belum registered |
| "No matching service worker" | Build dulu, baru test |
| "Manifest doesn't have maskable icon" | Add purpose: "maskable" di manifest |
| "Theme color not set" | Add theme-color meta tag |
| "Not optimized for mobile" | Viewport meta tag |

---

## 🔔 Push Notifications (Advanced)

### **Setup Push Notifications:**

Untuk production, Anda perlu:

1. **VAPID Keys** (untuk Web Push)
```bash
npx web-push generate-vapid-keys
```

2. **Backend untuk Send Notification**
- Simpan subscription di database
- Kirim notification via Web Push API

3. **Request Permission di Frontend**
```typescript
import { useNotification } from './hooks/usePWA';

const { requestPermission, sendNotification } = useNotification();

// Request permission
const granted = await requestPermission();

// Send notification
sendNotification('Reminder Operasi', {
  body: 'Operasi Anda besok jam 08:00 WIB',
  icon: '/icon-192.png',
  actions: [
    { action: 'view', title: 'Lihat Detail' },
    { action: 'dismiss', title: 'OK' }
  ]
});
```

---

## 📋 Checklist PWA untuk Tesis

### **Must Have (Sudah Selesai):**
- [x] Manifest.json
- [x] Service Worker (offline support)
- [x] Install prompt
- [x] Offline page
- [x] Icons (192x192 & 512x512)
- [x] HTTPS (required for PWA)
- [x] Responsive design
- [x] Viewport meta tag

### **Nice to Have (Opsional):**
- [ ] Push Notifications (requires backend)
- [ ] Background Sync (auto sync data)
- [ ] Periodic Sync (scheduled tasks)
- [ ] Share Target API
- [ ] Contact Picker API
- [ ] File System Access API

---

## 🎯 Benefits PWA untuk Tesis

### **Keuntungan Teknis:**
- ✅ Cross-platform (1 code, all devices)
- ✅ No app store approval
- ✅ Instant updates (no download)
- ✅ Smaller size vs native app
- ✅ SEO friendly (tetap web)

### **Keuntungan untuk Pasien:**
- ✅ Mudah install (no app store)
- ✅ Hemat storage (lebih kecil)
- ✅ Bisa akses offline
- ✅ Loading cepat
- ✅ Feels like native app

### **Keuntungan untuk Rumah Sakit:**
- ✅ Hemat biaya (no native development)
- ✅ Maintenance mudah (1 codebase)
- ✅ Analytics tetap bisa tracking
- ✅ A/B testing mudah

---

## 🔐 Security Considerations

### **HTTPS Required:**
PWA **HARUS** di-serve via HTTPS (kecuali localhost).

**Production Hosting yang Recommended:**
- ✅ **Vercel** - Auto HTTPS, gratis
- ✅ **Netlify** - Auto HTTPS, gratis
- ✅ **Firebase Hosting** - Auto HTTPS
- ✅ **Cloudflare Pages** - Auto HTTPS

### **Permissions:**
- 📍 **Location** - untuk fitur GPS (if needed)
- 🔔 **Notifications** - untuk reminder
- 📷 **Camera** - untuk upload foto (if needed)
- 🎤 **Microphone** - untuk voice input (if needed)

**Best Practice:**
- Minta permission hanya saat dibutuhkan
- Jelaskan kenapa perlu permission
- Sediakan fallback jika ditolak

---

## 📱 PWA vs Native App - Comparison

| Feature | PWA | Native App |
|---------|-----|------------|
| **Development Time** | ✅ Fast (1 codebase) | ❌ Slow (iOS + Android) |
| **Cost** | ✅ Low | ❌ High |
| **Distribution** | ✅ URL (instant) | ❌ App Store (review) |
| **Updates** | ✅ Instant | ❌ User must update |
| **Offline** | ✅ Yes | ✅ Yes |
| **Push Notifications** | ✅ Yes | ✅ Yes |
| **Device Access** | ⚠️ Limited | ✅ Full |
| **Performance** | ⚠️ Good | ✅ Excellent |
| **App Store** | ❌ No | ✅ Yes |
| **Discoverability** | ✅ SEO | ⚠️ App Store only |

**Kesimpulan untuk Tesis:**
- ✅ PWA **lebih cocok** untuk prototype/MVP
- ✅ Bisa deploy cepat untuk user testing
- ✅ Hemat waktu & biaya
- ⚠️ Untuk production jangka panjang, pertimbangkan native app

---

## 🛠 Troubleshooting

### **Problem: Service Worker tidak register**
```javascript
// Check di DevTools > Application > Service Workers
// Pastikan status: "activated and running"

// Force update:
navigator.serviceWorker.getRegistrations().then(registrations => {
  registrations.forEach(registration => {
    registration.update();
  });
});
```

### **Problem: Install prompt tidak muncul**
Syarat install prompt:
1. ✅ Manifest.json valid
2. ✅ Service Worker registered
3. ✅ HTTPS (atau localhost)
4. ✅ Icons tersedia
5. ✅ User belum install
6. ✅ User sudah interact dengan page

### **Problem: Offline tidak bekerja**
```javascript
// Test di DevTools:
// Application > Service Workers > Offline checkbox
// Reload page, harus tetap bisa akses
```

---

## 📚 Resources & Further Reading

### **Official Docs:**
- [Web.dev - PWA](https://web.dev/progressive-web-apps/)
- [MDN - PWA Guide](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [Google - PWA Checklist](https://web.dev/pwa-checklist/)

### **Tools:**
- [Lighthouse](https://developers.google.com/web/tools/lighthouse) - PWA audit
- [Workbox](https://developers.google.com/web/tools/workbox) - Service Worker library
- [PWA Builder](https://www.pwabuilder.com/) - Generate PWA assets

### **Examples:**
- [Twitter Lite](https://mobile.twitter.com) - PWA example
- [Starbucks](https://app.starbucks.com) - PWA example
- [Uber](https://m.uber.com) - PWA example

---

## ✅ Summary

Aplikasi Anda sekarang adalah **PWA lengkap** yang bisa:

📲 **Install seperti app** di Android, iOS, Desktop  
📴 **Bekerja offline** dengan caching pintar  
🔔 **Push notifications** (ready, butuh backend)  
⚡ **Loading super cepat** dengan service worker  
🎨 **Looks & feels native** dengan standalone mode  

**Next Steps:**
1. ✅ Test di mobile device
2. ✅ Run Lighthouse audit
3. ✅ Deploy ke production (Vercel/Netlify)
4. ✅ Test install flow
5. ✅ Collect user feedback

**Untuk tesis:** PWA ini akan menjadi nilai tambah besar! ⭐

---

**Good luck! 🚀**

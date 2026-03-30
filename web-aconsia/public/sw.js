// Service Worker for PWA
const CACHE_NAME = 'ic-anestesi-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/src/styles/index.css',
  '/src/styles/tailwind.css',
  '/src/styles/theme.css',
];

// Install Service Worker
self.addEventListener('install', (event) => {
  console.log('[SW] Installing Service Worker...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[SW] Caching app shell');
        return cache.addAll(urlsToCache);
      })
      .then(() => self.skipWaiting())
  );
});

// Activate Service Worker
self.addEventListener('activate', (event) => {
  console.log('[SW] Activating Service Worker...');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('[SW] Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Strategy: Network First, fallback to Cache
self.addEventListener('fetch', (event) => {
  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Clone the response
        const responseClone = response.clone();
        
        // Cache the fetched response
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, responseClone);
        });
        
        return response;
      })
      .catch(() => {
        // If network fails, try cache
        return caches.match(event.request).then((cachedResponse) => {
          if (cachedResponse) {
            return cachedResponse;
          }
          
          // If not in cache, return offline page
          if (event.request.mode === 'navigate') {
            return caches.match('/offline.html');
          }
        });
      })
  );
});

// Push Notification Handler
self.addEventListener('push', (event) => {
  console.log('[SW] Push notification received');
  
  const options = {
    body: event.data ? event.data.text() : 'Ada update baru!',
    icon: '/icon-192.png',
    badge: '/icon-192.png',
    vibrate: [200, 100, 200],
    tag: 'ic-anestesi-notification',
    requireInteraction: false,
    actions: [
      {
        action: 'open',
        title: 'Buka App'
      },
      {
        action: 'close',
        title: 'Tutup'
      }
    ]
  };
  
  event.waitUntil(
    self.registration.showNotification('Sistem IC Anestesi', options)
  );
});

// Notification Click Handler
self.addEventListener('notificationclick', (event) => {
  console.log('[SW] Notification clicked');
  event.notification.close();
  
  if (event.action === 'open') {
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});

// Background Sync
self.addEventListener('sync', (event) => {
  console.log('[SW] Background sync triggered');
  
  if (event.tag === 'sync-data') {
    event.waitUntil(
      // Sync logic here
      Promise.resolve()
    );
  }
});

// Periodic Background Sync (for reminder)
self.addEventListener('periodicsync', (event) => {
  if (event.tag === 'check-reminder') {
    event.waitUntil(
      // Check if patient has upcoming surgery
      // Send reminder notification
      Promise.resolve()
    );
  }
});

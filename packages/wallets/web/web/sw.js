// web/sw.js
const CACHE_NAME = 'atlas-wallet-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/assets/AssetManifest.json',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache);
    })
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});

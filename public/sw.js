self.addEventListener('install', e => {
 e.waitUntil(
   caches.open('HorGy-cache').then(cache => {
     return cache.addAll([
       'index.html',
       'app.js',
       'assets/jquery-3.4.1.min.js',
       'assets/swipe.js',
       'assets/styles.css',
       'data/config.json',
       'data/1920-1C7-l1.txt',
     ]);
   })
 );
});


self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
      return response || fetch(event.request);
    })
  );
});

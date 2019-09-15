self.addEventListener('install', e => {
 e.waitUntil(
   caches.open('HorGy-cache').then(cache => {
     return cache.addAll([
       'index.html',
       'app.js',
       'assets/jquery-3.4.1.min.js',
       'assets/swipe.js',
       'assets/styles.css',
     ]);
   })
 );
});

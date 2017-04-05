document.addEventListener('touchstart', function() {}, true);

// Initialize Fastclick.js
document.addEventListener('turbolinks:load', function() {
  FastClick.attach(document.body);
});

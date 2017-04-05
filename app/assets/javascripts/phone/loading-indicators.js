// Reset button loading indicators when using mobile Safari
// back button, which loads page from back-forward cache

window.addEventListener('pageshow', function() {
  $('.btn-loading-dropdown').button('reset');
  $('.btn-loading').button('reset');
});

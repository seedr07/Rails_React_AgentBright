$(document).on('click', '[data-behaviour~=toggle-superadmin-links]', function() {
  $("[data-superadmin-link]").toggle();
  return false;
});

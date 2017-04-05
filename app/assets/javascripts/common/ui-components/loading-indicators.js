$(document).on("click", ".btn-loading", function() {
  var $btn = $(this);
  $btn.button("loading");
});

$(document).on("click", ".btn-loading-dropdown", function() {
  $(this).parent().parent().prev().button("loading");
});

$(document).on("turbolinks:before-cache", function() {
  $(".btn-loading-dropdown").button("reset");
  $(".btn-loading").button("reset");
});

$(window).scroll(function() {
  var scroll = $(window).scrollTop();

  if (scroll >= 125) {
    $("body").addClass("header-shrink");
  } else {
    $("body").removeClass("header-shrink");
  }
});

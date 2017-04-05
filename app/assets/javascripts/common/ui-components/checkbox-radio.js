document.addEventListener('turbolinks:load', function() {
  var checks = $('.prettycheck');
  var radios = $('.prettyradio');

  if (checks.length > 0) {
    checks.prettyCheckable();
  }

  if (radios.length > 0) {
    $.each(radios, function() {
      $(this).prettyCheckable();
    });
  }
});

jQuery.fn.initPrettyCheck = function() {
  var checks = $(this).find('.prettycheck');
  var radios = $(this).find('.prettyradio');

  if (checks.length > 0) {
    checks.prettyCheckable();
  }

  if (radios.length > 0) {
    $.each(radios, function() {
      $(this).prettyCheckable();
    });
  }
};

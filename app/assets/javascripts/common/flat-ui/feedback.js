document.addEventListener('turbolinks:load', function() {
  // Tooltips
  $('[data-toggle=tooltip]').tooltip();

  // Add style class name to a tooltips
  $('.tooltip').addClass(function() {
    if ($(this).prev().attr('data-tooltip-style')) {
      return 'tooltip-' + $(this).prev().attr('data-tooltip-style');
    }
  });

});

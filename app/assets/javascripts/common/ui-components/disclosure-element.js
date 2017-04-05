document.addEventListener('turbolinks:load', function() {
  var btnGroupRadiotoggle = $('.btn-group-radiotoggle');
  btnGroupRadiotoggle.attr('data-toggle','buttons');
  btnGroupRadiotoggle.find('input:checked').parents('.btn').addClass('active');

  $('[data-toggle=collapse]').find('.title-arrow').addClass('rotate-90-font');
  $('.collapsed[data-toggle=collapse]').find('.title-arrow').removeClass('rotate-90-font');

  $('a[data-toggle-event=true]').click(function() {
    var link = $(this);
    if (link.hasClass('collapsed')) {
      link.find('.title-arrow').addClass('rotate-90-font');
    } else {
      link.find('.title-arrow').removeClass('rotate-90-font');
    }
  });
});

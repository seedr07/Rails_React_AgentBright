document.addEventListener('turbolinks:load', function() {

  // Tabs
  $('.nav-tabs a').on('click', function (e) {
    e.preventDefault();
    $(this).tab('show');
  });

  // Make pagination demo work
  $('.pagination').on('click', 'a', function () {
    $(this).parent().siblings('li').removeClass('active').end().addClass('active');
  });

  $('.btn-group').on('click', 'a', function () {
    $(this).siblings().removeClass('active').end().addClass('active');
  });

});

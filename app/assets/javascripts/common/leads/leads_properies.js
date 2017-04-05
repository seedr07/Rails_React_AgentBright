$(document).on('click', '[data-behavior="redirect"]', function(event){
  event.preventDefault();
  var url = $(this).data('link');
  window.open(url, '_blank');
});

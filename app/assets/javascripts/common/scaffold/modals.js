// Every time a modal is shown, if it has an autofocus element, focus on it.
$(document).on('shown.bs.modal', '.modal', function() {
  $(this).find('[autofocus]').focus();
});

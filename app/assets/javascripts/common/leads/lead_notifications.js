$(document).on('switchChange.bootstrapSwitch', '#update_lead_notifications [data-toggle=switch]', function() {
  if ($('#update_lead_notifications').data('remote') === true) {
    $('#update_lead_notifications').submit();
    return false;
  }
});

$(document).on('change', '#update_lead_notifications [data-behavior=remind-uncontacted-lead]', function() {
  if ($('#update_lead_notifications').data('remote') === true) {
    $('#update_lead_notifications').submit();
    return false;
  }
});

$(document).on('switchChange.bootstrapSwitch', '#update_autoresponder [data-behavior=update-autoresponder]', function() {
  if ($('#update_autoresponder').data('remote') === true) {
    $('#update_autoresponder').submit();
    return false;
  }
});

$(document).on('focusout', '#update_autoresponder [data-behavior=update-autoresponder]', function() {
  if ($('#update_autoresponder').data('remote') === true) {
    $('#update_autoresponder').submit();
    return false;
  }
});

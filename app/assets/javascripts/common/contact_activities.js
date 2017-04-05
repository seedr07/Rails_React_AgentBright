// Select2
jQuery.fn.useSelect2 = function() {
  this.select2();
  return this;
};

function newcontactactivityform_select2() {
  $("#contact_activity_contact_id").useSelect2();
}

// Display datepicker if custom date selected
jQuery.fn.displayDatepickerOnSelect = function() {
  this.change(function() {
    if ($(this).val('Just now')) {
      $('[data-show-hide=specific-completed-date]').hide();
    }
  });
  $('#contact_activity_custom_time_specify_date').change(function() {
    if ($(this).val('Specify date...')) {
      $('[data-show-hide=specific-completed-date]').show();
    }
  });
  $('[data-show-hide=specific-completed-date]').hide();
  $('[data-behavior=custom-time-group]').show();
  return this;
};

function display_datepicker_on_select () {
  $('#contact_activity_custom_time_just_now').displayDatepickerOnSelect();
}

function initializeDatepicker() {
  var $datepickerSelector = $("[data-behavior~=datepicker]");
  if (!Modernizr.inputtypes.date) {
    $datepickerSelector.pickADate();
  } else {
    $datepickerSelector.openNativePickerOnButtonTouch();
  }
}

function initializeTimepicker() {
  var $timepickerSelector = $("[data-behavior~=timepicker]");
  if (!Modernizr.inputtypes.time) {
    $timepickerSelector.pickATime();
  } else {
    $timepickerSelector.openNativePickerOnButtonTouch();
  }
}

document.addEventListener("turbolinks:load", function() {
  initializeTimepicker();
  initializeDatepicker();
});

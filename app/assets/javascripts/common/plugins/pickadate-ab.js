// For pickadate.js

// Datepicker
jQuery.fn.pickADate = function() {
  // pickadate.js
  var datepickerSelector = this;
  datepickerSelector.pickadate({
    container: "body",
    selectYears: true,
    selectMonths: true,
    // Escape any “rule” characters with an exclamation mark (!).
    format: "mmmm dd, yyyy",
    formatSubmit: "mmm dd, yyyy",
    hiddenPrefix: "prefix__",
    hiddenSuffix: "__suffix",
  });
  datepickerSelector.prev(".input-group-btn").find(".btn").on("click", function (e) {
    e && e.preventDefault();
    var input = $(this).parent().next();
    setTimeout( function() {
      input.data("pickadate").open();
    }, 0);
  });
  return this;
};
// Datepicker is initialized in desktop.js or phone.js

// Timepicker
jQuery.fn.pickATime = function() {
  // pickadate.js
  var timepickerSelector = this;
  timepickerSelector.pickatime({
    container: "body",
    interval: 60,
    min: [5,0],
    max: [19,0],
    clear: "Clear",
    // Escape any “rule” characters with an exclamation mark (!).
    format: "h:i A",
    formatSubmit: "h:i A",
    hiddenPrefix: "prefix__",
    hiddenSuffix: "__suffix",
  });
  timepickerSelector.prev(".input-group-btn").find(".btn").on("click", function (e) {
    e && e.preventDefault();
    var input = $(this).parent().next();
    setTimeout( function() {
      input.data("pickatime").open();
    }, 0);
  });
  return this;
};
// Timepicker is initialized in desktop.js or phone.js

// Open native time or datepicker on mobile when appended icon is touched/clicked
jQuery.fn.openNativePickerOnButtonTouch = function() {
  var $pickerSelector = this;
  $icon = $pickerSelector.prev(".input-group-btn").find(".btn");
  $icon.on("click", function (e) {
    e && e.preventDefault();
    var $input = $(this).parent().next();
    $input.focus();
  });
  return this;
};

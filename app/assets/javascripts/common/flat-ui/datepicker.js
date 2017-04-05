// (function($) {

//   $(function() {

//     // jQuery UI Datepicker
//     // NOTE replaced by pickadate.js
//     var datepickerUISelector = $('#datepicker-01');
//     datepickerUISelector.datepicker({
//       showOtherMonths: true,
//       selectOtherMonths: true,
//       dateFormat: 'd MM, yy',
//       yearRange: '-1:+1'
//     }).prev('.input-group-btn').on('click', function (e) {
//       e && e.preventDefault();
//       datepickerUISelector.focus();
//     });
//     $.extend($.datepicker, { _checkOffset: function (inst,offset,isFixed) { return offset; } });

//     // Now let's align datepicker with the prepend button
//     datepickerUISelector.datepicker('widget').css({ 'margin-left': -datepickerUISelector.prev('.input-group-btn').find('.btn').outerWidth() });

//     // Timepicker
//     $('#timepicker-01').timepicker({
//       'className': 'timepicker-primary',
//       'timeFormat': 'h:i A'
//     });

//   });

// })(jQuery);

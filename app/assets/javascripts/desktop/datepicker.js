function initializeDatepicker() {
  $("[data-behavior~=datepicker]").pickADate();
}

function initializeTimepicker() {
  $("[data-behavior~=timepicker]").pickATime();
}

document.addEventListener("turbolinks:load", function() {
  initializeTimepicker();
  initializeDatepicker();
});

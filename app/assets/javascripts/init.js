if (!window.App) { window.App = {}; }

App.init = () => {
  // Initialize common libraries
  $.initializeFormJS();
  $('form').addAndRemoveFields();
  initializeTimepicker();
  initializeDatepicker();
};

$(document).on('turbolinks:load', () => App.init());

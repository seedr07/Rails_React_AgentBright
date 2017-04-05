document.addEventListener('turbolinks:load', function() {
  // Custom Selects
  if ($('[data-toggle="select"]').length) {
    $('[data-toggle="select"]').select2();
  }
  // TODO remove and replace '.selectpicker' with 'data-toggle=select'
  // $("select[name='huge']").selectpicker({style: 'btn-hg btn-primary', menuStyle: 'dropdown-inverse'});
  // $("select[name='large']").selectpicker({style: 'btn-lg btn-danger'});
  // $("select[name='info']").selectpicker({style: 'btn-info'});
  // $("select[name='small']").selectpicker({style: 'btn-sm btn-warning'});

  // Checkboxes and Radiobuttons
  // TODO decide which to use, radiocheck, or prettycheck
  $('[data-toggle="checkbox"]').radiocheck();
  $('[data-toggle="radio"]').radiocheck();

  // Tags Input
  // TODO check any instances of incorrect 'tagsInput'
  $('.tagsinput').tagsinput();

  // Focus state for append/prepend inputs
  // TODO check .navbar-search to make sure focus state still working
  $('.input-group').on('focus', '.form-control', function () {
    $(this).closest('.input-group, .form-group').addClass('focus');
  }).on('blur', '.form-control', function () {
    $(this).closest('.input-group, .form-group').removeClass('focus');
  });

  // Switches
  if ($('[data-toggle="switch"]').length) {
    $('[data-toggle="switch"]').bootstrapSwitch();
  }

});

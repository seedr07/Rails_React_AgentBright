document.addEventListener('turbolinks:load', function() {

  // Table: Toggle all checkboxes
  $('.table .toggle-all :checkbox').on('click', function () {
    var $this = $(this);
    var ch = $this.prop('checked');
    $this.closest('.table').find('tbody :checkbox').radiocheck(!ch ? 'uncheck' : 'check');
  });

  // Table: Add class row selected
  $('.table tbody :checkbox').on('change.radiocheck', function () {
    var $this = $(this);
    var check = $this.prop('checked');
    var checkboxes = $this.closest('.table').find('tbody :checkbox');
    var checkAll = checkboxes.length === checkboxes.filter(':checked').length;

    $this.closest('tr')[check ? 'addClass' : 'removeClass']('selected-row');
    $this.closest('.table').find('.toggle-all :checkbox').radiocheck(checkAll ? 'check' : 'uncheck');
  });

});

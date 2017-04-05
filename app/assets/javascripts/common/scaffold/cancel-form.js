jQuery.fn.cancelEditForm = function() {
  this.on('click', function() {
    var editForm;
    editForm = $(this).closest('form').closest('.row');
    editForm.prev().show().prev().show();
    editForm.remove();
  });
};

jQuery.fn.cancelFixedListEditForm = function() {
  this.on('click', function() {
    var editForm, sectionID, section, editButton, list;

    sectionID = $(this).attr('data-cancel-section');
    section = $(sectionID);

    editButton = section.find('[data-list-edit~=true]');

    list = section.find('ul');

    editForm = section.find('form');

    editButton.button('reset').show();

    list.show();
    editForm.remove();
  });
};

jQuery.fn.cancelForm = function() {
  this.on('click', function() {
    var cancelButton, form, editButton, section;

    cancelButton = $(this);
    form = cancelButton.closest('form');
    section = $(cancelButton.attr('data-edit-button'));
    editButton = $(cancelButton.attr('data-section'));

    form.remove();
    section.show();
    editButton.button('reset').show();

    $('.btn-loading').click(function() {
      $(this).button('loading');
    });
  });
};

$(document).on('turbolinks.load', function() {
  $('[data-behavior~=cancel-edit-form]').cancelEditForm();
  $('[data-cancel-section]').cancelFixedListEditForm();
  $('[data-behavior~=cancel-form]').cancelForm();
});

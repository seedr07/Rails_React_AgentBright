jQuery.fn.displayFixedListEditForm = function(form) {
  var section, sectionID, editButton, list;

  section = this;
  sectionID = this.attr("id");
  editButton = section.find("[data-list-edit~=true]");
  list = section.find("ul");

  // Hide list and insert form
  list.hide().after(form);

  // Hide edit button
  editButton.hide();

  // Initialize form JS
  $.initializeFormJS();

  // Focus on first input
  // Defined differently on desktop and phone
  $.focusOnFirstField(sectionID);

};

(function ($) {
  $.extend({
    initializeFormJS: function () {
      // Activate cancel button
      $("[data-cancel-section]").cancelFixedListEditForm();

      // Activate input masks
      new InputMask();

      // Activate loading indicator button
      $(".btn-loading").click(function() {
        $(this).button('loading');
      });

      // Display lead source dropdown
      $("#lead_lead_source_id").displayLeadSource();

      // Commission type fields
      $('[data-behavior~=select-commission-type]').displayCommissionSelect();

      // Display referral fields depending on lead type
      $("[data-behavior~=display-referral-field]").displayReferralFields();

      // Display commission referral fields
      $("[data-behavior~=display-commission-referral-fields]").dynamicallyDisplayCommissionReferralFields();

      // Start datepicker using pickadate
      initializeDatepicker();
    }
  });
})(jQuery);

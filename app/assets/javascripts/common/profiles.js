// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Display commission fields in profile
jQuery.fn.dynamicallyDisplayCommissionFields = function() {
  this.change(function() {
    if ($(this).val() === "Fee" ) {
      $("#fee-field").show();
      $("#fee2-field").show();
      $("#percentage-field").hide();
    } else if ($(this).val() === "Percentage" ) {
      $("#fee-field").hide();
      $("#fee2-field").hide();
      $("#percentage-field").show();
    } else {
      $("#fee-field").hide();
      $("#fee2-field").hide();
      $("#percentage-field").hide();
    }
  });
  if (this.val() === "Fee" ) {
    $("#fee-field").show();
    $("#fee2-field").show();
    $("#percentage-field").hide();
  } else if (this.val() === "Percentage" ) {
    $("#fee-field").hide();
    $("#fee2-field").hide();
    $("#percentage-field").show();
  } else {
    $("#fee-field").hide();
    $("#fee2-field").hide();
    $("#percentage-field").hide();
  }
  return this;
};

function dynamically_display_commission_fields() {
  $('[data-behavior~=display-commission-fields]').dynamicallyDisplayCommissionFields();
}


// Display alternative commission fields in profile
jQuery.fn.displayAlternativeFields = function() {
  this.change(function() {
    if ($(this).val() === "true" ) {
      $("#alternative-field").show();
    } else if ($(this).val() === "false" ) {
      $("#alternative-field").hide();
    } else {
      $("#alternative-field").hide();
    }
  });
  if (this.val() === "true" ) {
    $("#alternative-field").show();
  } else if (this.val() === "false" ) {
    $("#alternative-field").hide();
  } else {
    $("#alternative-field").hide();
  }
  return this;
};

function display_alternative_fields() {
  $('[data-behavior~=display-alternative-fields]').displayAlternativeFields();
}

// Display commission cap fields in profile
jQuery.fn.displayCapFields = function() {
  this.change(function() {
    if ($(this).val() === "true" ) {
      $("#cap-field").show();
    } else if ($(this).val() === "false" ) {
      $("#cap-field").hide();
    } else {
      $("#cap-field").hide();
    }
  });
  if (this.val() === "true" ) {
    $("#cap-field").show();
  } else if (this.val() === "false" ) {
    $("#cap-field").hide();
  } else {
    $("#cap-field").hide();
  }
};

function display_cap_fields() {
  $('[data-behavior~=display-cap-fields]').displayCapFields();
}

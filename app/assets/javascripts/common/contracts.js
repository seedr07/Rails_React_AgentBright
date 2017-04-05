// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery.fn.dynamicallyDisplayCommissionContractFields = function() {
  this.change(function() {
    if ($(this).val() === "Fee" ) {
      $("#fee-field").show();
      $("#percentage-field").hide();
    } else if ($(this).val() === "Percentage" ) {
      $("#fee-field").hide();
      $("#percentage-field").show();
    } else {
      $("#fee-field").hide();
      $("#percentage-field").hide();
    }
  });
  if (this.val() === "Fee" ) {
    $("#fee-field").show();
    $("#percentage-field").hide();
  } else if (this.val() === "Percentage" ) {
    $("#fee-field").hide();
    $("#percentage-field").show();
  } else {
    $("#fee-field").hide();
    $("#percentage-field").hide();
  }
  return this;
};

function dynamically_display_commission_contract_fields() {
  $('[data-behavior~=display-commission-contract-fields]').dynamicallyDisplayCommissionContractFields();
}


// Dynamically display commission referral fields
jQuery.fn.dynamicallyDisplayCommissionReferralFields = function() {
  this.change(function() {
    if ($(this).val() === "Fee" ) {
      $("#fee2-field").show();
      $("#percentage2-field").hide();
    } else if ($(this).val() === "Percentage" ) {
      $("#fee2-field").hide();
      $("#percentage2-field").show();
    } else {
      $("#fee2-field").hide();
      $("#percentage2-field").hide();
    }
  });
  if (this.val() === "Fee" ) {
    $("#fee2-field").show();
    $("#percentage2-field").hide();
  } else if ($('[data-behavior~=display-commission-referral-fields]').val() === "Percentage" ) {
    $("#fee2-field").hide();
    $("#percentage2-field").show();
  } else {
    $("#fee2-field").hide();
    $("#percentage2-field").hide();
  }
  return this;
};


function dynamically_display_commission_referral_fields() {
  $('[data-behavior~=display-commission-referral-fields]').dynamicallyDisplayCommissionReferralFields();
}



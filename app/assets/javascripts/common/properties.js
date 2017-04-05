// Display commission select dropdowns
jQuery.fn.displayCommissionSelect = function() {
  this.change(function() {
    if ($(this).val() === 'Percentage' ) {
      $("#commission-percentage-field").show();
      $("#commission-fee-field").hide();
    } else if ($(this).val() === 'Fee' ) {
      $("#commission-percentage-field").hide();
      $("#commission-fee-field").show();
    } else {
      $("#commission-percentage-field").hide();
      $("#commission-fee-field").hide();
    }
  });
  if (this.val() === "Fee" ) {
    $("#commission-percentage-field").hide();
    $("#commission-fee-field").show();
  } else if (this.val() === "Percentage" ) {
    $("#commission-percentage-field").show();
    $("#commission-fee-field").hide();
  } else {
    $("#commission-percentage-field").hide();
    $("#commission-fee-field").hide();
  }
  return this;
};

function display_commission_select () {
  $('[data-behavior~=select-commission-type]').displayCommissionSelect();
}


// Display dropdowns depending on type of referral
jQuery.fn.displayReferralSelect = function() {
  this.change(function() {
    if ($(this).val() === 'Percentage' ) {
      $("#referral-percentage-field").show();
      $("#referral-fee-flat-rate-field").hide();
    } else if ($(this).val() === 'Fee' ) {
      $("#referral-percentage-field").hide();
      $("#referral-fee-flat-rate-field").show();
    } else {
      $("#referral-percentage-field").hide();
      $("#referral-fee-flat-rate-field").hide();
    }
  });
  if (this.val() === "Percentage" ) {
    $("#referral-percentage-field").show();
    $("#referral-fee-flat-rate-field").hide();
  } else if ($('[data-behavior~=select-referral-type]').val() === "Fee" ) {
    $("#referral-percentage-field").hide();
    $("#referral-fee-flat-rate-field").show();
  } else {
    $("#referral-percentage-field").hide();
    $("#referral-fee-flat-rate-field").hide();
  }
  return this;
};

function display_referral_select () {
  $('[data-behavior~=select-referral-type]').displayReferralSelect();
}

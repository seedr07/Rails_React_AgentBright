jQuery.fn.displayReferralFields = function() {
  this.change(function() {
    var leadTypeSelected = $(this).find("option:selected").text();
    if (leadTypeSelected === "Referral - From Database") {
      $("#referring-field").show();
      $("#select-listing-field").hide();
    } else if (leadTypeSelected === "Referral - From Business Network") {
      $("#referring-field").show();
      $("#select-listing-field").hide();
    } else if (leadTypeSelected === "Referral - From Realtor") {
      $("#referring-field").show();
      $("#select-listing-field").hide();
    } else if (leadTypeSelected === "Listing Inquiry") {
      $("#select-listing-field").show();
      $("#referring-field").hide();
    } else {
      $("#select-listing-field").hide();
      $("#referring-field").hide();
      $("#percentage2-field").hide();
      $("#fee2-field").hide();
    }
  });
  if (this.find("option:selected").text() === "Referral - From Database") {
    $("#referring-field").show();
    $("#select-listing-field").hide();
  } else if (this.find("option:selected").text() === "Referral - From Business Network") {
    $("#referring-field").show();
    $("#select-listing-field").hide();
  } else if (this.find("option:selected").text() === "Referral - From Realtor") {
    $("#referring-field").show();
    $("#select-listing-field").hide();
  } else if (this.find("option:selected").text() === "Listing Inquiry") {
    $("#select-listing-field").show();
    $("#referring-field").hide();
  } else {
    $("#select-listing-field").hide();
    $("#referring-field").hide();
    $("#percentage2-field").hide();
    $("#fee2-field").hide();
  }
  return this;
};

function display_referral_fields() {
  $('[data-behavior~=display-referral-field]').displayReferralFields();
}

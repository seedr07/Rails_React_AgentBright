if (CPEP !== undefined) {
  alert("CPEP is already defined");
}

var CPEP = (function(){

  function handlePhoneCheckboxes(){
    mainDivElement = $(this).parents("div.contact_phone_numbers_primary");
    var allPhoneCheckboxes = $("[data-behavior~=phone_primary_checkbox]");
    if ($(this).is(":checked")) {
      var otherPhoneCheckboxes = allPhoneCheckboxes.not($(this));
      if (otherPhoneCheckboxes.length) {
        otherPhoneCheckboxes.prop("checked", false);
      }
    }
  }

  function handleEmailCheckboxes(){
    mainEmailDivElement = $(this).parents("div.contact_email_addresses_primary");
    var allEmailCheckboxes = $("[data-behavior~=email_primary_checkbox]");
    if ($(this).is(":checked")) {
      var otherEmailCheckboxes = allEmailCheckboxes.not($(this));
      if (otherEmailCheckboxes.length) {
        otherEmailCheckboxes.prop("checked", false);
      }
    }
  }

  return {
    "handlePhoneCheckboxes": handlePhoneCheckboxes,
    "handleEmailCheckboxes": handleEmailCheckboxes
  };
})();

$(document).on("change", "[data-behavior~=phone_primary_checkbox]", CPEP.handlePhoneCheckboxes);
$(document).on("change", "[data-behavior~=email_primary_checkbox]", CPEP.handleEmailCheckboxes);

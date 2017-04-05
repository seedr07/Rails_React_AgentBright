function customBrokerSplit() {
  console.log("[customBrokerSplit] Starting...");

  $(document).on("change", "[data-check-toggle~='section']", function() {
    if ($(this).is(":checked") === true) {
      $("#custom-split-section").show();
      $("#default-split-section").hide();
    } else {
      $("#default-split-section").show();
      $("#custom-split-section").hide();
    }
  });

  $(document).on("change", "[data-radio-toggle~='section'] input:radio", function() {
    if ($(this).val() === "Fee") {
      $("#lead_displayed_broker_commission_percentage").prop("disabled", true);
      $("#lead_displayed_broker_commission_percentage").parents(".form-group").hide();

      $("#lead_displayed_broker_commission_fee").prop("disabled", false);
      $("#lead_displayed_broker_commission_fee").parents(".form-group").show();
    }

    if ($(this).val() === "Percentage") {
      $("#lead_displayed_broker_commission_fee").prop("disabled", true);
      $("#lead_displayed_broker_commission_fee").parents(".form-group").hide();

      $("#lead_displayed_broker_commission_percentage").prop("disabled", false);
      $("#lead_displayed_broker_commission_percentage").parents(".form-group").show();
    }
  });

  console.log("[customBrokerSplit] show and hide based on what's checked");
  var checkToggle = $("[data-check-toggle~='section']");
  var radioToggle = $("[data-radio-toggle~='section'] input:radio:checked");

  if (checkToggle.is(":checked") === true) {
    $("#custom-split-section").show();
    $("#default-split-section").hide();
  } else {
    $("#default-split-section").show();
    $("#custom-split-section").hide();
  }

  if (radioToggle.val() === "Fee") {
    $("#lead_displayed_broker_commission_percentage").prop("disabled", true);
    $("#lead_displayed_broker_commission_percentage").parents(".form-group").hide();

    $("#lead_displayed_broker_commission_fee").prop("disabled", false);
    $("#lead_displayed_broker_commission_fee").parents(".form-group").show();
  } else if (radioToggle.val() === "Percentage") {
    $("#lead_displayed_broker_commission_fee").prop("disabled", true);
    $("#lead_displayed_broker_commission_fee").parents(".form-group").hide();

    $("#lead_displayed_broker_commission_percentage").prop("disabled", false);
    $("#lead_displayed_broker_commission_percentage").parents(".form-group").show();
  } else {
    console.log("Neither percentage nor fee. Both should hide");
    $("#lead_displayed_broker_commission_percentage").prop("disabled", true);
    $("#lead_displayed_broker_commission_percentage").parents(".form-group").hide();
    $("#lead_displayed_broker_commission_fee").prop("disabled", true);
    $("#lead_displayed_broker_commission_fee").parents(".form-group").hide();
  }

  console.log("[customBrokerSplit] Completed.");
}

function commissionTypeSelection() {
  $(document).on("change", "[data-behavior~=select-commission-type-radios]", function() {
    if ($(this).val() === "Fee") {
      showFeeFields();
      calculateTotalFeeCommission();
    }

    if ($(this).val() === "Percentage") {
      showPercentageFields();
      calculateTotalPercentageCommission();
    }
  });

  function displayCommissionFields() {
    var radioToggle = $("[data-behavior~=select-commission-type-radios]:checked");

    if (radioToggle.val() === "Fee") {
      showFeeFields();
      calculateTotalFeeCommission();
    } else if (radioToggle.val() === "Percentage") {
      showPercentageFields();
      calculateTotalPercentageCommission();
    } else {
      hideFeeAndPercentageFields();
    }
  }

  displayCommissionFields();

  $("[data-field~=seller_commission]").keyup(function() {
    calculateTotalPercentageCommission();
  });

  $("[data-field~=buyer_commission]").keyup(function() {
    calculateTotalPercentageCommission();
  });

  $("[data-field~=seller_fee_commission]").keyup(function() {
    calculateTotalFeeCommission();
  });

  $("[data-field~=buyer_fee_commission]").keyup(function() {
    calculateTotalFeeCommission();
  });

  function showFeeFields() {
    $("#commission-percentage-field").hide();
    $("#commission-percentage-field input").prop("disabled", true);
    $("#commission-fee-field").show();
    $("#commission-fee-field input").prop("disabled", false);
  }

  function showPercentageFields() {
    $("#commission-percentage-field").show();
    $("#commission-percentage-field input").prop("disabled", false);
    $("#commission-fee-field").hide();
    $("#commission-fee-field input").prop("disabled", true);
  }

  function hideFeeAndPercentageFields() {
    $("#commission-percentage-field").hide();
    $("#commission-percentage-field input").prop("disabled", true);
    $("#commission-fee-field").hide();
    $("#commission-fee-field input").prop("disabled", true);
  }

  function calculateTotalFeeCommission() {
    var sellerFeeCommission = parseFloat($("[data-field~=seller_fee_commission]").inputmask("unmaskedvalue")) || 0;
    var buyerFeeCommission = parseFloat($("[data-field~=buyer_fee_commission]").inputmask("unmaskedvalue")) || 0;

    $("[data-field~=total_fee_commission]")
      .val((buyerFeeCommission + sellerFeeCommission).toFixed(2));
    $("#display-total-fee-commission").text($("[data-field~=total_fee_commission]").val());
  }

  function calculateTotalPercentageCommission() {
    var sellerCommission = parseFloat($("[data-field~=seller_commission]").val()) || 0;
    var buyerCommission = parseFloat($("[data-field~=buyer_commission]").val()) || 0;

    $("[data-field~=total_commission]")
      .val((buyerCommission + sellerCommission).toFixed(2));
    $("#display-total-commission").text($("[data-field~=total_commission]").val());
  }

  return this;
}

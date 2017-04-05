// EC is acronym of this file name 'edit_commission'

if (EC !== undefined) {
  alert("EC is already defined");
}

var EC = (function() {
  function handleCommissionRadioButtons() {
    var radioInputs   = $("[data-toggle='buttons'].btn-group input[type='radio']");
    var dataAttribute = "";
    var dataBehavior  = "";
    var behaviorParts = "";
    var action        = "";

    radioInputs.change(function() {
      dataBehavior = $(this).data("behavior");

      if (dataBehavior !== undefined) {
        behaviorParts = dataBehavior.split("-");
        action = behaviorParts.shift();

        if (action === "show") {
          $("#" + behaviorParts.join("-")).show();
        }
        else {
          $("#" + behaviorParts.join("-")).hide();
        }
      }
      else {
        dataAttribute = $(this).data("action");
        if (dataAttribute !== undefined) {
          $("#" + dataAttribute.show).show();
          $("#" + dataAttribute.hide).hide();
        }
      }

      $('[data-display=commission_split_type_not_nil]').show();
    });
  }

  return { "handleCommissionRadioButtons": handleCommissionRadioButtons };
})();

document.addEventListener("turbolinks:load", function() {
  if ($("form.commission-data").length) {
    EC.handleCommissionRadioButtons();
  }
});

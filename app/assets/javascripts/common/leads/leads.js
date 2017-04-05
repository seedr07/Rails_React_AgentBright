// Select2
jQuery.fn.useSelect2 = function() {
  this.select2();
  return this;
};

function newleadform_select2() {
  $("#lead_contact_id").useSelect2();
  $("#lead_referring_contact_id").useSelect2();
}

// Show/hide fields based on client type (buyer or seller)
jQuery.fn.displayFieldsBasedOnClientType = function() {

  if ($("input[value='Buyer']").is(':checked')) {
    $("#leadform").slideDown("slow");
    $("#leadtypereferral").hide();
    $("#leadtypelisting").hide();
    $("#leadtypesource").hide();
    $(".sellersection").hide();
    $(".sellerfield").hide();
    $(".buyersection").show();
    $(".buyerfield").show();
  }
  else if ($("input[value='Seller']").is(':checked')) {
    $("#leadform").slideDown("slow");
    $("#leadtypereferral").hide();
    $("#leadtypelisting").hide();
    $("#leadtypesource").hide();
    $(".buyersection").hide();
    $(".buyerfield").hide();
    $(".sellersection").show();
    $(".sellerfield").show();
  }
  else {
    $("#leadform").slideUp("fast");
  }

  this.click(function() {
    if ($(this).val() === "Buyer" ) {
      $("#leadform").slideDown("slow");
      $("#leadtypereferral").hide();
      $("#leadtypelisting").hide();
      $("#leadtypesource").hide();
      $(".sellersection").hide();
      $(".sellerfield").hide();
      $(".buyersection").show();
      $(".buyerfield").show();

    }
    else if ($(this).val() === "Seller" ) {
      $("#leadform").slideDown("slow");
      $("#leadtypereferral").hide();
      $("#leadtypelisting").hide();
      $("#leadtypesource").hide();
      $(".buyersection").hide();
      $(".buyerfield").hide();
      $(".sellersection").show();
      $(".sellerfield").show();
    }
    else {
      $("#leadform").slideUp("fast");
    }
  });
  return this;
};

function display_fields_based_on_client_type() {
  $("input[name$='lead[client_type]']").displayFieldsBasedOnClientType();
}

// Display contract section if status is 3 or 4
jQuery.fn.displayFieldsBasedOnStatus = function() {
  if (this.val() === 3 ) {
    $("#contractsection").show();
  }
  else if (this.val() === 4 ) {
    $("#contractsection").show();
  }
  else {
    $("#contractsection").hide();
  }
  this.change(function() {
    if ($(this).val() === 3 ) {
      $("#contractsection").show();
    }
    else if ($(this).val() === 4 ) {
      $("#contractsection").show();
    }
    else {
      $("#contractsection").hide();
    }
  });
  return this;
};

function display_fields_based_on_status() {
  $("#lead_status").displayFieldsBasedOnStatus();
}


// Display paused and not_converted sections if lead is paused or not converted
jQuery.fn.displayPauseAndLostHiddenFields = function() {
  if ($(this).val() === 5 ) {
    $("#pausesection").show();
    $("#not_converted_section").hide();
  }
  else if ($(this).val() === 6 ) {
    $("#not_converted_section").show();
    $("#pausesection").hide();
  }
  else {
    $("#not_converted_section").hide();
    $("#pausesection").hide();
  }
  this.change(function() {
    if ($(this).val() === 5 ) {
      $("#pausesection").show();
      $("#not_converted_section").hide();
    }
    else if ($(this).val() === 6 ) {
      $("#not_converted_section").show();
      $("#pausesection").hide();
    }
    else {
      $("#not_converted_section").hide();
      $("#pausesection").hide();
    }
  });
  return this;
};

function display_pause_and_lost_hidden_fields() {
  $("#lead_status").displayPauseAndLostHiddenFields();
}

// Display buyer or seller sections on lead form
jQuery.fn.displayBuyerOrSellerSections = function() {
  if ($("input[value='Buyer']").is(':checked')) {
    $("#seller-section").hide();
    $("#buyer-section").show();
  }
  else if ($("input[value='Seller']").is(':checked')) {
    $("#seller-section").show();
    $("#buyer-section").hide();
  }
  else {
    $("#seller-section").hide();
    $("#buyer-section").hide();
  }
  this.click(function() {
    if ($(this).val() === "Buyer") {
      $("#seller-section").hide();
      $("#buyer-section").show();
    }
    else if ($(this).val() === "Seller") {
      $("#seller-section").show();
      $("#buyer-section").hide();
    }
    else {
      $("#seller-section").hide();
      $("#buyer-section").hide();
    }
  });
  return this;
};

function display_buyer_or_seller_sections() {
  $("input[name$='lead[client_type]']").displayBuyerOrSellerSections();
}


// Display the correct items in the lead type dropdown
// depending on the lead source
jQuery.fn.displayLeadSource = function() {
  var leadType, leadSources, escaped_leadType, loadedLeadType, options;
  loadedLeadType = $('option:selected', this).text();
  leadSources = $('#lead_lead_source_id').html();
  $('#lead_lead_source_id').hide();
  if (loadedLeadType.length !== 0) {
    leadType = $('#lead_lead_type_id :selected').text();
    escaped_leadType = leadType.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(leadSources).filter("optgroup[label=" + escaped_leadType + "]").html();
    $('#lead_lead_source_id').html(options);
    $('#lead_lead_source_id').show();
  }
  return $('#lead_lead_type_id').change(function() {
    leadType = $('#lead_lead_type_id :selected').text();
    escaped_leadType = leadType.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(leadSources).filter("optgroup[label='" + escaped_leadType + "']").html();
    if (options) {
      $('#lead_lead_source_id').html(options);
      return $('#lead_lead_source_id').show();
    } else {
      $('#lead_lead_source_id').empty();
      return $('#lead_lead_source_id').hide();
    }
  });
};

document.addEventListener("turbolinks:load", function() {
  $('#lead_lead_source_id').displayLeadSource();
});

// EC => "email campaign

if (EC !== undefined) {
  alert("EC is already defined");
}

var EC = (function() {
  var load = function(){
    handleSelectRecipientChange();
    // ------------------------
    // CHECKBOX REVEAL SECTIONS
    // ------------------------

    // Show or hide a section depending on whether or not a checkbox is checked
    jQuery.fn.showOrHideCheckboxRevealSection = function() {
      var $checkbox = $(this);
      var $checkboxInput = $checkbox.find('input');
      var sectionName = $checkbox.attr('data-checkbox-reveal');
      var $section = $('[data-checkbox-reveal-section=' + sectionName + ']');

      if ($checkboxInput.is(':checked')) {
        $section.show();
      } else {
        $section.hide();
      }
    };

    // Show/hide sections when a checkbox is changed
    $(document).on('change', '[data-checkbox-reveal]', function() {
      $(this).showOrHideCheckboxRevealSection();
    });

    // ---------------------
    // RADIO REVEAL SECTIONS
    // ---------------------

    // Show or hide a section depending on if it's radio button is checked
    jQuery.fn.showOrHideRadioRevealSection = function() {
      var $radio = $(this);
      var $radioInput = $radio.find('input');
      var sectionName = $radio.attr('data-radio-reveal');
      if (sectionName) {
        var $section = $('[data-radio-reveal-section=' + sectionName + ']');

        if ($radioInput.is(':checked')) {
          $section.show();
        } else {
          $section.hide();
        }
      }
    };

    // Show or hide sections in a group depending on which radio button
    // is checked
    jQuery.fn.updateAllGroupSections = function() {
      var $changedRadio = $(this);
      var groupName = $changedRadio.attr('data-radio-reveal-group');
      var $groupRadios = $('[data-radio-reveal-group=' + groupName + ']');

      $groupRadios.each(function() {
        $(this).showOrHideRadioRevealSection();
      });
    };

    // Update which sections are shown and hidden when one is changed
    $(document).on("change", "[data-radio-reveal-group]", function() {
      console.log("[data-radio-reveal-group]");
      $(this).updateAllGroupSections();
    });

    $(document).on("click", "[data-behavior=show_scheduling_section]", function() {
      console.log("[data-behavior=show_scheduling_section]");
      $("[data-behavior=scheduling_section]").show();
      $("[data-behavior=delivery_buttons]").hide();
    });

    $(document).on("click", "[data-behavior=hide_scheduling_section]", function() {
      console.log("[data-behavior=hide_scheduling_section]");
      $('[data-behavior=scheduling_section]').hide();
      $('[data-behavior=delivery_buttons]').show();
    });

    $("[data-ui-behavior=checkbox]").checkbox();

    // Initialize Semantic UI dropdowns
    $("[data-ui-behavior=dropdown]").dropdown();

    // Initialize test email modal
    $("[data-ui-behavior=send_test_email_modal]")
      .modal("attach events", "[data-ui-behavior=open_send_test_email_modal]", "show");

    // Initialize send now confirmation modal
    $("[data-ui-behavior=send_now_confirmation_modal]")
      .modal("attach events", "[data-ui-behavior=open_send_now_confirmation_modal]", "show");

    // Initialize Semantic UI calendar component for date selection
    $("[data-ui-behavior=calendar_date]")
      .calendar(
        {
          type: "date",
          today: true,
        }
      );

    // Initialize Semantic UI calendar component for time selection
    $("[data-ui-behavior=calendar_time]")
      .calendar(
        {
          type: "time",
        }
      );

    // Check what sections should be shown or hidden on page load
    $("[data-checkbox-reveal]").each(function() {
      $(this).showOrHideCheckboxRevealSection();
    });

    // Show or hide each radio reveal section
    $("[data-radio-reveal]").each(function() {
      $(this).showOrHideRadioRevealSection();
    });

    // Upload image
    $("[data-update-campaign-preview=image]").fileupload({
      dataType: 'json',
      change: function(e, data) {
        console.log("running imageUploader.fileupload");
        return $(".spinner-row").show();
      },
      done: function (e, data) {
        $(".spinner-row").hide();
        var emailCampaginID =  $("[data-behavior='edit_email_campaign_form']").data("email-campaign-id");
        $("iframe").attr("src", "/email_campaigns/" + emailCampaginID + "/preview_content_html");
        alert("Uploaded image successfully.");
      },
      fail: function (e, data) {
        console.log(data);
        alert("Uploading failed");
      }
    });

    $(document).on("click", "[data-behavior=update-recipient-count]", function() {
      console.log("[data-behavior=update-recipient-count]");
      EC.updateEmailRecipients();
    });

    $(document).on("change", "[data-behavior=select_group], [data-behavior=select_grades]", function(){
      console.log("[data-behavior=select_group], [data-behavior=select_grades]");
      EC.updateEmailRecipients();
    });

    $(document).on("change", "[data-behavior=select-group-radio]", function(){
      console.log("[data-behavior=select-group-radio]");
      $("[data-behavior=select_grades]").prop("checked", false);
      EC.updateEmailRecipients();
    });

    $(document).on("change", "[data-behavior=select-grade-radio]", function(){
      console.log("[data-behavior=select-grade-radio]");
      $("[data-behavior=select_group][data-ui-behavior=dropdown]").dropdown("clear");
      EC.updateEmailRecipients();
    });

    $(document).on("keyup", "[data-update-campaign-preview=custom_message] > trix-editor", function() {
      console.log("[data-update-campaign-preview=custom_message] > trix-editor");
      EC.autoSaveEmailCampaign().success(function(returnedData) {
        var customMessage = returnedData.custom_message;
        $("iframe").contents().find("[data-behavior=campaign-preview-content]").html("<p></p>" + customMessage + "<p></p>");
      });
    });

    $(document).on("keyup paste", "[data-update-campaign-preview=title]", function(e) {
      var titleInput = $("[data-update-campaign-preview=title] input")
      var maxLength = 100;
      var val = titleInput.val();

      if(titleInput.val().length <= maxLength){
        var titleCounter = maxLength - titleInput.val().length;
        $("[data-update-campaign-preview=title] label span").html(titleCounter);

        EC.autoSaveEmailCampaign().success(function(returnedData) {
          var previewTitle = returnedData.title;
          $("iframe").contents().find("[data-behavior=campaign-preview-title]").html(previewTitle);
        });
      } else {
        alert("You have reached the maximum " + maxLength + "limit of characters");
        titleInput.val(val.substring(0, maxLength));
      }
    });

    // Update email subject
    $(document).on("change", "[data-update-campaign-preview=subject]", function() {
      console.log("[data-update-campaign-preview=subject]");
      EC.autoSaveEmailCampaign()
    });

    // Update campaign template color scheme
    $(document).on("change", "[data-update-campaign-preview=color]", function() {
      console.log("[data-update-campaign-preview=color]");
      EC.autoSaveEmailCampaign();
    });
  }

  function updateEmailRecipients() {
    event.preventDefault();
    var $updateRecipientCountField = $("[data-behavior=update-recipient-count-field]");
    $updateRecipientCountField.val("true");
    var $form = $("[data-behavior=edit_email_campaign_form]");
    $form.submit();
    $updateRecipientCountField.val("");
  }

  function handleSelectRecipientChange(){
    console.log("change selected");
    // Show preview for selected recipient
    $(document).on("change", "[data-behavior=select_recipient]", function() {
      var $recipientSelector = $(this);
      var $selectedOption = $recipientSelector.find("option:selected");
      var recipientName = $selectedOption.attr("data-contact-name");
      var recipientEmail = $selectedOption.attr("data-contact-email");
      var recipientLocation = $selectedOption.attr("data-contact-location");
      var recipientLocationType = $selectedOption.attr("data-contact-location-type");
      var recipientLocationSource = $selectedOption.attr("data-contact-location-source");

      $("[data-email-preview=recipient_to]").text(recipientName + " (" + recipientEmail + ")");
      if (recipientLocationSource === "default") {
        $("[data-email-preview=recipient_location]").text(recipientLocation + " (default)");
      } else {
        $("[data-email-preview=recipient_location]").text(recipientLocation);
      }

      var emailCampaginID =  $("[data-behavior='edit_email_campaign_form']").data("email-campaign-id");
      $("iframe").attr("src", "/email_campaigns/" + emailCampaginID + "/preview_market_data?contact_id=" + $selectedOption.attr("value"));
    })
  };

  // Save to the database
  function autoSaveEmailCampaign() {
    var emailCampaginID =  $("[data-behavior='edit_email_campaign_form']").data("email-campaign-id");
    return $.ajax({
      type: "POST",
      url: "/email_campaigns/" + emailCampaginID + "?autosave=true",
      data: $("[data-behavior=edit_email_campaign_form]").serialize(),
      dataType: "json",
      success: function(data) {
        return data;
      },
      error: function(data) {
        console.log(data);
        return data;
      }
    });
  }

  function disableFormSubmitOnEnter(){
    $("[data-behavior='edit_email_campaign_form']").on("keypress", function(e){
      if (e.keyCode == 13) {
        return false;
      }
    });
  }

  var init = function(){
    if($("[data-behavior='edit_email_campaign_form']").length > 0) {
      load();
      disableFormSubmitOnEnter();
    }
  };

  return {
    "init":                        init,
    "updateEmailRecipients":       updateEmailRecipients,
    "autoSaveEmailCampaign":       autoSaveEmailCampaign,
    "handleSelectRecipientChange": handleSelectRecipientChange
  };
})();

document.addEventListener("turbolinks:load", function(){
  EC.init();
});


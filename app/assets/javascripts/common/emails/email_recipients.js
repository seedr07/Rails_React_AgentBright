//ER -> Email Recipients

if (ER !== undefined) {
  alert("ER is alreday defined");
}

var ER = (function(){

  function init(){
    toRecipients();
    ccRecipients();
    bccRecipients();

    // Hack to work with browser's back button
    $("#s2id_cc_recipients").show();
    $("#s2id_bcc_recipients").show();
    $("#s2id_to_recipients").show();
  }

  var validateRecipientEmails = function(emails, htmlDom){
    var error = false;
    $(htmlDom).html("");
    $.each(emails, function(index, email) {
      var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
      if (!regex.test(email)) {
        error = true;
      }
    });

    if(error){
      $(htmlDom).html("Provided email address is invalid");
    }
  }

  function toRecipients(){
    var toRecipientsElement      = $("[data-behavior='to-recipients']");
    var toRecipientsErrorElement = $("[data-behavior='to-recipients-error']");
    var select2ToRecipients      = $("#s2id_to_recipients");

    if (toRecipientsElement.length > 0) {
      // Hack to work with browser's back button
      if (select2ToRecipients.length > 0) {
        select2ToRecipients.remove();
        $(".select2-drop").remove();
        $(".select2-sizer").remove();
        $("#select2-drop-mask").remove();
        $(".select2-hidden-accessible").remove();
      }
      bindSelect2ToElement(toRecipientsElement, "To");
    }

    toRecipientsElement.on("change", function(e) {
      validateRecipientEmails(e.val, toRecipientsErrorElement);
    });
  }

  function ccRecipients(){
    var ccRecipientsElement = $("[data-behavior='cc-recipients']");
    var ccRecipientsErrorElement = $("[data-behavior='cc-recipients-error']");
    var select2CcRecipients = $("#s2id_cc_recipients");
    if (ccRecipientsElement.length > 0){
      // Hack to work with browser's back button
      if (select2CcRecipients.length > 0){
        select2CcRecipients.remove();
      }
      bindSelect2ToElement(ccRecipientsElement, "Cc");
    }

    ccRecipientsElement.on("change", function(e) {
      validateRecipientEmails(e.val, ccRecipientsErrorElement);
    });
  }

  function bccRecipients(){
    var bccRecipientsElement = $("[data-behavior='bcc-recipients']");
    var bccRecipientsErrorElement = $("[data-behavior='bcc-recipients-error']");
    var select2BccRecipients = $("#s2id_bcc_recipients");

    if (bccRecipientsElement.length > 0){
      // Hack to work with browser's back button
      if (select2BccRecipients.length > 0) {
        select2BccRecipients.remove();
      }
      bindSelect2ToElement(bccRecipientsElement, "Bcc");
    }

    bccRecipientsElement.on("change", function(e) {
      validateRecipientEmails(e.val, bccRecipientsErrorElement);
    });
  }

  function bindSelect2ToElement(element, placeholder){
    element.select2({ tags: true,
                      tokenSeparators: [",", " "],
                      createSearchChoice: function (term) {
                        return {
                          id: $.trim(term),
                          text: $.trim(term)
                        };
                      },
                      ajax: {
                        url: "/contacts_data",
                        dataType: "json",
                        data: function(term) {
                          return {
                            q: term
                          };
                        },
                        results: function(data) {
                          return {
                            results: data
                          };
                        }
                      },
                      initSelection: function (element, callback) {
                        var data = [];

                        function splitVal(string, separator) {
                          var val, i, l;

                          if (string === null || string.length < 1) {
                            return [];
                          }

                          val = string.split(separator);

                          for (i = 0, l = val.length; i < l; i = i + 1){
                            val[i] = $.trim(val[i]);
                          }
                          return val;
                        }

                        $(splitVal(element.val(), ",")).each(function () {
                          data.push({
                            id: this,
                            text: this
                          });
                        });

                        callback(data);
                      },
                      minimumInputLength: 3,
                      maximumInputLength: 80,
                      formatResult: emailFormatResult,
                      formatSelection: emailFormatSelection,
                      placeholder: placeholder });
  }

  function emailFormatResult(state) {
    return escapeHtml(state.text);
  }

  function emailFormatSelection(state) {
    return escapeHtml(state.text);
  }

  function escapeHtml(text) {
    return text
      .replace("<", "&lt;")
      .replace(">", "&gt;");
  }

  return { "init": init };

})();

$(document).on("turbolinks:load", function() {
  ER.init();
});

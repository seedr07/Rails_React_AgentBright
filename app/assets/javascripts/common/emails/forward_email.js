if (FE !== undefined) {
  window.alert("FE is alreday defined");
}

var FE = (function() {

  var handleModal = function() {
    $("[data-behavior='forward-email']").click(function(){
      $("[data-behavior~=insert-form]").html("<span> Loading...</span>");
    });
  };

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
  };

  var toRecipients = function(){
    var toRecipientsElement = $("[data-behavior='to-recipients']");
    var toRecipientsErrorElement = $("[data-behavior='to-recipients-error']");
    if (toRecipientsElement.length > 0){
      bindSelect2ToElement(toRecipientsElement, "To");
    }

    toRecipientsElement.on("change", function(e) {
      validateRecipientEmails(e.val, toRecipientsErrorElement);
    });
  };

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

  var init = function(){
    handleModal();
    toRecipients();
  };

  return { "init": init, "handleModal": handleModal };
})();

document.addEventListener("turbolinks:load", function(){
  FE.handleModal();
});

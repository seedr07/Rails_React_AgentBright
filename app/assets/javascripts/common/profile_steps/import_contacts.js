// IC => Import Contacts

if (IC !== undefined) {
  window.alert("IC is alreday defined");
}

var IC = (function(){
  var validate = function(){
    var $formToValidate = $("[data-info~='import-contacts-form']");

    $formToValidate.formValidation({
      framework: "bootstrap",
      excluded: [":disabled"],
      err: {
        clazz: "error-message"
      },
      row: {
        valid: ""
      },
      fields: {
        email: {
          validators: {
            notEmpty: {
              message: "Email address is required"
            },
            regexp: {
              regexp: /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/,
              message: "Please enter a valid email address",
            }
          }
        }
      }
    }).on("success.field.fv", function(e, data) {
      if (data.fv.getInvalidFields().length > 0) {    // There is invalid field
        data.fv.disableSubmitButtons(true);
      }
    });
  };

  return { "validate": validate };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-info~='import-contacts-form']").length) {
    IC.validate();
  }
});

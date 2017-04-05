// VCF -> Validate Contact Form

if (VCF !== undefined) {
  alert("VCF is already defined");
}

var VCF = (function(){
  function validate(){
    var $formToValidate = $("[data-form~='contact_form']");
    var validationFields =  "[name='contact[first_name]'], [name='contact[last_name]']";
    validationFields = validationFields + ", [name='contact[email_addresses_attributes][0][email]']," +
      "[name='contact[phone_numbers_attributes][0][number]']";

    $formToValidate
      .formValidation({
        framework: "bootstrap",
        excluded: [":disabled"],
        err: {
          clazz: "error-message"
        },
        row: {
          valid: ""
        },
        fields: {
          "contact[first_name]": {
            validators: {
              notEmpty: {
                message: "Please enter a first name"
              }
            }
          },

          "contact[last_name]": {
            enabled: false,
            validators: {
              notEmpty: {
                message: "...or a last name"
              }
            }
          },

          "contact[email_addresses_attributes][0][email]": {
            enabled: false,
            validators: {
              notEmpty: {
                message: "...or an email address",
                onError: function() {
                  $("[data='contact-emails']").addClass("error-color");
                }
              },
              emailAddress: {
                message: "Please enter a valid email address",
                onError: function() {
                  $("[data='contact-emails']").addClass("error-color");
                }
              }
            }
          },

          "contact[phone_numbers_attributes][0][number]": {
            enabled: false,
            validators: {
              notEmpty: {
                message: "...or a phone number",
                onError: function() {
                  $("[data='contact-phones']").addClass("error-color");
                }
              },
              onError: function() {
                $("[data='contact-phones']").addClass("error-color");
              }
            }
          }
        },
        onError: function() {
          $formToValidate.find(".btn-loading").button("reset");
        }
      })
      .on("keyup", validationFields, function() {
          var firstName    = "contact[first_name]",
              lastName     = "contact[last_name]",
              emailAddress = "contact[email_addresses_attributes][0][email]",
              mobileNumber = "contact[phone_numbers_attributes][0][number]",

          firstNameVal    = $formToValidate.find("[name = '" + firstName + "']").val(),
          lastNameVal     = $formToValidate.find("[name = '" + lastName + "']").val(),
          emailAddressVal = $formToValidate.find("[name = '" + emailAddress + "']").val(),
          mobileNumberVal = $formToValidate.find("[name = '" + mobileNumber + "']").val(),

          fv = $formToValidate.data("formValidation");

          $("[data-behavior=first-name] label").removeClass("error-color");
          $("[data-behavior=last-name] label").removeClass("error-color");
          $("[data='contact-phones']").removeClass("error-color");
          $("[data='contact-emails']").removeClass("error-color");

          switch ($(this).attr("name")) {
            case firstName:
              $("[data-behavior=first-name] div.error-message").hide();
              $("[data-behavior=last-name] div.error-message").hide();

              if (emptyRequiredFields(firstNameVal, lastNameVal, emailAddressVal, mobileNumberVal)) {
                window.console.log("everything is blank");
                validateAll(fv);
              } else {
                if (firstNameVal === "") {
                  window.console.log("firstName is blank and on, turn it off");
                  fv.enableFieldValidators(firstName, false).revalidateField(firstName);
                } else {
                  window.console.log("firstName is not blank or off, turn it on");
                  fv.enableFieldValidators(firstName, true).revalidateField(firstName);
                }
                if (lastNameVal !== "") {
                  window.console.log("lastName is not blank, turn it on");
                  fv.enableFieldValidators(lastName, true).revalidateField(lastName);
                } else {
                  window.console.log("lastName is blank, turn it off");
                  fv.enableFieldValidators(lastName, false).revalidateField(lastName);
                }
                if (emailAddressVal !== "") {
                  window.console.log("emailAddress is not blank, turn it on");
                  fv.enableFieldValidators(emailAddress, true).revalidateField(emailAddress);
                } else {
                  window.console.log("emailAddress is blank, turn it off");
                  fv.enableFieldValidators(emailAddress, false).revalidateField(emailAddress);
                }
                if (mobileNumberVal !== "") {
                  window.console.log("mobileNumber is not blank, turn it on");
                  fv.enableFieldValidators(mobileNumber, true).revalidateField(mobileNumber);
                } else {
                  window.console.log("mobileNumber is blank, turn it off");
                  fv.enableFieldValidators(mobileNumber, false).revalidateField(mobileNumber);
                }
              }
              break;

            case lastName:
              $("[data-behavior=first-name] div.error-message").hide();
              $("[data-behavior=last-name] div.error-message").hide();

              if (emptyRequiredFields(firstNameVal, lastNameVal, emailAddressVal, mobileNumberVal)) {
                window.console.log("everything is blank");
                validateAll(fv);
              } else {
                if (lastNameVal === "") {
                  window.console.log("lastName is blank and on, turn it off");
                  fv.enableFieldValidators(lastName, false).revalidateField(lastName);
                } else if (lastNameVal !== "") {
                  window.console.log("lastName is not blank and is off, turn it on");
                  fv.enableFieldValidators(lastName, true).revalidateField(lastName);
                }
                if (firstNameVal !== "") {
                  window.console.log("firstName is not blank, turn it on");
                  fv.enableFieldValidators(firstName, true).revalidateField(firstName);
                } else {
                  window.console.log("firstName is blank, turn it off");
                  fv.enableFieldValidators(firstName, false).revalidateField(firstName);
                }
                if (emailAddressVal !== "") {
                  window.console.log("emailAddress is not blank, turn it on");
                  fv.enableFieldValidators(emailAddress, true).revalidateField(emailAddress);
                } else {
                  window.console.log("emailAddress is blank, turn it off");
                  fv.enableFieldValidators(emailAddress, false).revalidateField(emailAddress);
                }
                if (mobileNumberVal !== "") {
                  window.console.log("mobileNumber is not blank, turn it on");
                  fv.enableFieldValidators(mobileNumber, true).revalidateField(mobileNumber);
                } else {
                  window.console.log("mobileNumber is blank, turn it off");
                  fv.enableFieldValidators(mobileNumber, false).revalidateField(mobileNumber);
                }
              }
              break;

            case emailAddress:
              $("div.error-message").html("");
              if (emptyRequiredFields(firstNameVal, lastNameVal, emailAddressVal, mobileNumberVal)) {
                if (emailAddressVal === "") {
                  window.console.log("emailAddress is blank and on, turn it off");
                  fv.enableFieldValidators(emailAddress, false).revalidateField(emailAddress);
                  validateAll(fv);
                } else {
                  window.console.log("emailAddress is not blank and is off, turn it on");
                  fv.enableFieldValidators(emailAddress, true).revalidateField(emailAddress);
                }
              } else {
                if (emailAddressVal === "") {
                  window.console.log("emailAddress is blank and on, turn it off");
                  fv.enableFieldValidators(emailAddress, false).revalidateField(emailAddress);
                } else if (emailAddressVal !== "") {
                  window.console.log("emailAddress is not blank and is off, turn it on");
                  fv.enableFieldValidators(emailAddress, true).revalidateField(emailAddress);
                }
                if (firstNameVal !== "") {
                  window.console.log("firstName is not blank, turn it on");
                  fv.enableFieldValidators(firstName, true).revalidateField(firstName);
                } else {
                  window.console.log("firstName is blank, turn it off");
                  fv.enableFieldValidators(firstName, false).revalidateField(firstName);
                }
                if (lastNameVal !== "") {
                  window.console.log("lastName is not blank, turn it on");
                  fv.enableFieldValidators(lastName, true).revalidateField(lastName);
                } else {
                  window.console.log("lastName is blank, turn it off");
                  fv.enableFieldValidators(lastName, false).revalidateField(lastName);
                }
                if (mobileNumberVal !== "") {
                  window.console.log("mobileNumber is not blank, turn it on");
                  fv.enableFieldValidators(mobileNumber, true).revalidateField(mobileNumber);
                } else {
                  window.console.log("mobileNumber is blank, turn it off");
                  fv.enableFieldValidators(mobileNumber, false).revalidateField(mobileNumber);
                }
              }
              break;

            case mobileNumber:
              if (emptyRequiredFields(firstNameVal, lastNameVal, emailAddressVal, mobileNumberVal)) {
                window.console.log("everything is blank");
                validateAll(fv);
              } else {
                if (mobileNumberVal === "") {
                  window.console.log("mobileNumber is blank and on, turn it off");
                  fv.enableFieldValidators(mobileNumber, false).revalidateField(mobileNumber);
                } else if (mobileNumberVal !== "") {
                  window.console.log("mobileNumber is not blank and is off, turn it on");
                  fv.enableFieldValidators(mobileNumber, true).revalidateField(mobileNumber);
                }
                if (firstNameVal !== "") {
                  window.console.log("firstName is not blank, turn it on");
                  fv.enableFieldValidators(firstName, true).revalidateField(firstName);
                } else {
                  window.console.log("firstName is blank, turn it off");
                  fv.enableFieldValidators(firstName, false).revalidateField(firstName);
                }
                if (lastNameVal !== "") {
                  window.console.log("lastName is not blank, turn it on");
                  fv.enableFieldValidators(lastName, true).revalidateField(lastName);
                } else {
                  window.console.log("lastName is blank, turn it off");
                  fv.enableFieldValidators(lastName, false).revalidateField(lastName);
                }
                if (emailAddressVal !== "") {
                  window.console.log("emailAddress is not blank, turn it on");
                  fv.enableFieldValidators(emailAddress, true).revalidateField(emailAddress);
                } else {
                  window.console.log("emailAddress is blank, turn it off");
                  fv.enableFieldValidators(emailAddress, false).revalidateField(emailAddress);
                }
              }
              break;

            default:
              break;
          }
        })
      .on("success.form.fv", function(e) {
        var $form = $(e.target);
        if ($form.data("remote")) {
          e.preventDefault();
          return false;
        }
      })
      .on("submit", function(e) {
        var $form = $(e.target);
        if ($form.data("remote")) {
          if ($("[data-form~=contact_form]").data("formValidation") !== undefined) {
            var numInvalidFields = $form.data("formValidation").getInvalidFields().length;
            if (numInvalidFields) {
              e.preventDefault();
              return false;
            }
          }
        }
      });
  }

  function basicValidationsRequired() {
    return $("[data-form~='contact_form'] input[name='contact[require_basic_validations]']").length > 0;
  }

  function validateAll(fv) {
    validateBaseValiations(fv);
    if (basicValidationsRequired()) {
      validateBasicValiations(fv);
    }
  }

  function validateBaseValiations(fv) {
    var firstName = "contact[first_name]",
        lastName  = "contact[last_name]";

    fv.enableFieldValidators(firstName, true).revalidateField(firstName);
    fv.enableFieldValidators(lastName, true).revalidateField(lastName);
  }

  function validateBasicValiations(fv) {
    var emailAddress = "contact[email_addresses_attributes][0][email]",
        mobileNumber = "contact[phone_numbers_attributes][0][number]";

    fv.enableFieldValidators(emailAddress, true).revalidateField(emailAddress);
    fv.enableFieldValidators(mobileNumber, true).revalidateField(mobileNumber);
  }

  function emptyRequiredFields(firstNameVal, lastNameVal, emailAddressVal, mobileNumberVal) {
    // Here we handle logic for minimal required fields.
    // On contact page we consider all these given fields for this function as
    // parameters.
    // On lead and client pages we consider only first name and last name
    // fields.

    if (basicValidationsRequired()) {
      return (firstNameVal === "" && lastNameVal === "" && emailAddressVal === "" && mobileNumberVal === "");
    } else {
      return (firstNameVal === "" && lastNameVal === "");
    }
  }

  return { "validate": validate };
})();

document.addEventListener("turbolinks:load", VCF.validate);

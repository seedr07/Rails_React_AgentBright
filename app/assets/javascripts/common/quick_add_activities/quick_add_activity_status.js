// QAAS => Quick Add Activity Status

if (QAAS !== undefined) {
  window.alert("QAAS is alreday defined");
}

var QAAS = (function() {
  var init = function(){
    var number = $("#activity-stream-quick-record-call-number").val();
    var recipient = $("#activity-stream-quick-email-recipient").val();

    if(number === ""){
      var quickCallStatus = $("#activity-stream-quick-record-call-status");
      quickCallStatus.html("<p><font color='red'>You have not yet set an phone number for this contact.</font></p>");
    }

    if(recipient === ""){
      var userToken = $("#add-email-form").data("info-user-nylas-token");
      var quickEmailStatus = $("#activity-stream-quick-email-status");

      if(userToken){
        quickEmailStatus.html("<p><font color='red'>You have not yet set an email address for this contact.</font></p>");
      }else {
        quickEmailStatus.html("<p><font color='red'>Email address required for contact. You also need to sync your email account on the integrations page</font></p>");
      }
    }
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-behavior='quick-add-activity']").length) {
    QAAS.init();
  }
});

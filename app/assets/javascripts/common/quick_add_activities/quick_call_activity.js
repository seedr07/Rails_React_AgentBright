// QCA => Quick Call Activity

if (QCA !== undefined) {
  window.alert("QCA is alreday defined");
}

var QCA = (function() {

  var init = function(){
    var quickCallStatus  = $("#activity-stream-quick-record-call-status");
    var quickCallNumber  = $("#activity-stream-quick-record-call-number");
    var quickCallSubject = $("#activity-stream-quick-record-call-subject");
    var quickCallInfo    = $("#activity-stream-quick-record-call-info");
    var quickCallDate    = $("#activity-stream-quick-record-call-date");
    var quickCallTime    = $("#activity-stream-quick-record-call-time");
    var quickCall        = $("#activity-stream-quick-record-call");

    quickCall.click(function(e) {
      e.preventDefault();
      $(this).prop("disabled",true);
      quickCallStatus.html("<p><font color='#B0C92E'>Recording Call...</font></p>");
      var number  = quickCallNumber.val();
      var subject = quickCallSubject.val();
      var info    = quickCallInfo.val();
      var date    = quickCallDate.val();
      var time    = quickCallTime.val();

      if (subject === "" || number === "") {
       quickCallStatus.html("<p><font color='red'>You are required to enter a subject and have atleast set one phone number for this contact.</font></p>");
        quickCall.prop("disabled",false);
      }else {
        if (date === "")
        {
          var d      = new Date();
          var month  = d.getMonth()+1;
          var day    = d.getDate();
          var output = d.getFullYear() + "/" + (month<10 ? "0" : "") + month + "/" + (day<10 ? "0" : "") + day;
          date       = output;
        }
        var qucikAddActivityElement = $("[data-behavior='quick-add-activity']");
        var leadId = qucikAddActivityElement.data("info-lead");
        var contactId = qucikAddActivityElement.data("info-contact");
        var parameters = { number: number, subject: subject, info: info, date: date, time: time, contact_id: contactId, lead_id: leadId };
        var response  = $.post("/activity/stream/quick/record/call", parameters);
        response.always(function() {
          var status = response.responseText;

          if ( status == "success" ){
            quickCallStatus.html("<p><font color='green'>Call Recorded!</font></p>");
            quickCallSubject.val("");
            quickCallInfo.val("");
            var refreshDate = $("[data-behavior='quick-add-activity']").data("default-activity-date");
            quickCallDate.val(refreshDate);
            quickCallTime.val("10:00 AM");

            quickCall.prop("disabled", false);
            $.ajax({ url: "/activities/recent?activities_owner_id="+ leadId +"&activities_owner_type=Lead&replace_feed=true"});
          }else {
           quickCallStatus.html("<p><font color='red'>error recording call, please try again...</font></p>");
            quickCall.prop("disabled", false);
          }
        });
      }
    });

    var typingText = "<p><font color='#A4B6BD'>typing...</font></p>";

    quickCallNumber.keypress(function() {
      quickCallStatus.html(typingText);
    });

    quickCallNumber
    .focusout(function() {
      quickCallStatus.html("");
    })
    .blur(function() {
      quickCallStatus.html("");
    });

    quickCallSubject.keypress(function() {
      quickCallStatus.html(typingText);
    });

    quickCallSubject
    .focusout(function() {
      quickCallStatus.html("");
    })
    .blur(function() {
      quickCallStatus.html("");
    });

    quickCallInfo.keypress(function() {
      quickCallStatus.html(typingText);
    });

    quickCallInfo
    .focusout(function() {
      quickCallStatus.html("");
    })
    .blur(function() {
      quickCallStatus.html("");
    });
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-behavior='quick-add-activity']").length) {
    QCA.init();
  }
});

// QMA => Quick Meeting Activity

if (QMA !== undefined) {
  window.alert("QMA is alreday defined");
}

var QMA = (function() {
  var init = function(){
    var quickMeetingStatus  = $("#activity-stream-quick-record-meeting-status");
    var quickMeetingSubject = $("#activity-stream-quick-record-meeting-subject");
    var quickMeetingInfo    = $("#activity-stream-quick-record-meeting-info");
    var quickMeetingDate    = $("#activity-stream-quick-record-meeting-date");
    var quickMeetingTime    = $("#activity-stream-quick-record-meeting-time");

    $("#activity-stream-quick-record-meeting").click(function(e) {
      e.preventDefault();
      quickMeetingStatus.html("<p><font color='#B0C92E'>Adding Meeting...</font></p>");

      var subject = quickMeetingSubject.val();
      var info    = quickMeetingInfo.val();
      var date    = quickMeetingDate.val();
      var time    = quickMeetingTime.val();

      if (subject === "") {
        quickMeetingStatus.html("<p><font color='red'>Please make sure you have filled out the subject field</font></p>");
      }else {
        if (date === "") {
          var d      = new Date();
          var month  = d.getMonth() + 1;
          var day    = d.getDate();
          var output = d.getFullYear() + "/" + (month<10 ? "0" : "") + month + "/" + (day<10 ? "0" : "") + day;
          date       = output;
        }

        var qucikAddActivityElement = $("[data-behavior='quick-add-activity']");
        var leadId = qucikAddActivityElement.data("info-lead");
        var contactId = qucikAddActivityElement.data("info-contact");
        var parameters = { date: date, time: time, subject: subject, info: info, contact_id: contactId, lead_id: leadId };
        var response = $.post("/activity/stream/quick/record/meeting", parameters);
        response.always(function() {
          var status = response.responseText;

          if (status == "success") {
            quickMeetingStatus.html("<p><font color='green'>Recorded Meeting!</font></p>");
            quickMeetingSubject.val("");
            quickMeetingInfo.val("");
            var refreshDate = $("[data-behavior='quick-add-activity']").data("default-activity-date");
            quickMeetingDate.val(refreshDate);
            quickMeetingTime.val("10:00 AM");

            var url = "/activities/recent?activities_owner_id="+leadId+"&activities_owner_type=Lead&replace_feed=true";
            $.ajax({ url: url});
          }else {
            quickMeetingStatus
              .html("<p><font color='red'>Error adding meeting, please try again...</font></p>");
          }
        });
      }
    });

    var typingText = "<p><font color='#A4B6BD'>typing...</font></p>";

    quickMeetingSubject.keypress(function() {
      quickMeetingStatus.html(typingText);
    });

    quickMeetingSubject
    .focusout(function() {
        quickMeetingStatus.html("");
      })
    .blur(function() {
        quickMeetingStatus.html("");
    });

    quickMeetingInfo.keypress(function() {
      quickMeetingStatus.html(typingText);
    });

    quickMeetingInfo
    .focusout(function() {
        quickMeetingStatus.html("");
      })
    .blur(function() {
        quickMeetingStatus.html("");
    });

    quickMeetingDate.keypress(function() {
      quickMeetingStatus.html(typingText);
    });

    quickMeetingDate
    .focusout(function() {
        quickMeetingStatus.html("");
      })
    .blur(function() {
        quickMeetingStatus.html("");
    });

    quickMeetingTime.keypress(function() {
      quickMeetingStatus.html(typingText);
    });

    quickMeetingTime
    .focusout(function() {
        quickMeetingStatus.html("");
      })
    .blur(function() {
        quickMeetingStatus.html("");
    });
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-behavior='quick-add-activity']").length) {
    QMA.init();
  }
});


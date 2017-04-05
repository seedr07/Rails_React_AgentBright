// QNA => Quick Note Activity

if (QNA !== undefined) {
  window.alert("QNA is alreday defined");
}

var QNA = (function() {
  var init = function(){
    var quickNoteStatus  = $("#activity-stream-quick-record-note-status");
    var quickNoteSubject = $("#activity-stream-quick-record-note-subject");
    var quickNoteInfo    = $("#activity-stream-quick-record-note-info");
    var quickNoteDate    = $("#activity-stream-quick-record-note-date");

    $("#activity-stream-quick-record-note").click(function(e) {
      e.preventDefault();
      quickNoteStatus.html("<p><font color='#B0C92E'>Adding Note...</font></p>");
      var subject = quickNoteSubject.val();
      var info    = quickNoteInfo.val();
      var date    = quickNoteDate.val();

      if (subject === "") {
        quickNoteStatus
          .html("<p><font color='red'>Please make sure you have filled out the subject field</font></p>");
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
        var parameters = { date: date, subject: subject, info: info, contact_id: contactId, lead_id: leadId };
        var response = $.post("/activity/stream/quick/record/note", parameters);

        response.always(function() {
          var status = response.responseText;
          if (status == "success") {
            quickNoteStatus.html("<p><font color='green'>Note Added!</font></p>");
            quickNoteSubject.val("");
            quickNoteInfo.val("");
            var refreshDate = $("[data-behavior='quick-add-activity']").data("default-activity-date");
            quickNoteDate.val(refreshDate);

            var url = "/activities/recent?activities_owner_id="+leadId+"&activities_owner_type=Lead&replace_feed=true";
            $.ajax({ url: url});
          }else {
            quickNoteStatus
              .html("<p><font color='red'>Error adding note, please try again...</font></p>");
          }
        });
      }
    });

    var typingText = "<p><font color='#A4B6BD'>typing...</font></p>";

    quickNoteSubject.keypress(function() {
      quickNoteStatus.html(typingText);
    });

    quickNoteSubject
    .focusout(function() {
        quickNoteStatus.html("");
      })
    .blur(function() {
        quickNoteStatus.html("");
    });

    quickNoteInfo.keypress(function() {
      quickNoteStatus.html(typingText);
    });

    quickNoteInfo
    .focusout(function() {
        quickNoteStatus.html("");
      })
    .blur(function() {
        quickNoteStatus.html("");
    });

    quickNoteDate.keypress(function() {
      quickNoteStatus.html(typingText);
    });

    quickNoteDate
    .focusout(function() {
        quickNoteStatus.html("");
      })
    .blur(function() {
        quickNoteStatus.html("");
    });
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-behavior='quick-add-activity']").length) {
    QNA.init();
  }
});

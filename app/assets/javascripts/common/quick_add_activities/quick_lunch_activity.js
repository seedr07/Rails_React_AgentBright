// QLA => Quick Lunch Activity

if (QLA !== undefined) {
  window.alert("QLA is alreday defined");
}

var QLA = (function() {
  var init = function(){
    var quickLunchStatus  = $("#activity-stream-quick-record-lunch-status");
    var quickLunchSubject = $("#activity-stream-quick-record-lunch-subject");
    var quickLunchInfo    = $("#activity-stream-quick-record-lunch-info");
    var quickLunchDate    = $("#activity-stream-quick-record-lunch-date");
    var quickLunchTime    = $("#activity-stream-quick-record-lunch-time");

    $("#activity-stream-quick-record-lunch").click(function(e) {
      e.preventDefault();
      quickLunchStatus.html("<p><font color='#B0C92E'>Adding Lunch...</font></p>");
      var subject = quickLunchSubject.val();
      var info    = quickLunchInfo.val();
      var date    = quickLunchDate.val();
      var time    = quickLunchTime.val();

      if (subject === "") {
        quickLunchStatus
          .html("<p><font color='red'>Please make sure you have filled out the subject field</font></p>");
      }else {
        if (date === ""){
          var d      = new Date();
          var month  = d.getMonth() + 1;
          var day    = d.getDate();
          var output = d.getFullYear() + "/" + (month<10 ? "0" : "") + month + "/" + (day<10 ? "0" : "") + day;
          date       = output;
        }

        var qucikAddActivityElement = $("[data-behavior='quick-add-activity']");
        var leadId = qucikAddActivityElement.data("info-lead");
        var contactId = qucikAddActivityElement.data("info-contact");
        var parameters =  { date: date, time: time, subject: subject, info: info, contact_id: contactId,lead_id: leadId };
        var response  = $.post("/activity/stream/quick/record/lunch", parameters);

        response.always(function() {
          var status = response.responseText;

          if (status == "success") {
            quickLunchStatus.html("<p><font color='green'>Lunch Recorded!</font></p>");
            quickLunchSubject.val("");
            quickLunchInfo.val("");
            var refreshDate = $("[data-behavior='quick-add-activity']").data("default-activity-date");
            quickLunchDate.val(refreshDate);
            quickLunchTime.val("10:00 AM");


            var url = "/activities/recent?activities_owner_id="+ leadId +"&activities_owner_type=Lead&replace_feed=true";
            $.ajax({ url: url });
          }else {
            quickLunchStatus
              .html("<p><font color='red'>Error recording lunch, please try again...</font></p>");
          }
        });
      }
    });

    var typingText = "<p><font color='#A4B6BD'>typing...</font></p>";

    quickLunchSubject.keypress(function() {
      quickLunchStatus.html(typingText);
    });

    quickLunchSubject
    .focusout(function() {
        quickLunchStatus.html("");
      })
    .blur(function() {
        quickLunchStatus.html("");
    });

    quickLunchInfo.keypress(function() {
      quickLunchStatus.html(typingText);
    });

    quickLunchInfo
    .focusout(function() {
        quickLunchStatus.html("");
      })
    .blur(function() {
        quickLunchStatus.html("");
    });

    quickLunchDate.keypress(function() {
      quickLunchStatus.html(typingText);
    });

    quickLunchDate
    .focusout(function() {
        quickLunchStatus.html("");
      })
    .blur(function() {
        quickLunchStatus.html("");
    });

    quickLunchTime.keypress(function() {
      quickLunchStatus.html(typingText);
    });

    quickLunchTime.focusout(function() {
        quickLunchStatus.html("");
      })
    .blur(function() {
        quickLunchStatus.html("");
    });
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-behavior='quick-add-activity']").length) {
    QLA.init();
  }
});

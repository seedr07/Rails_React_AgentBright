// QCOA => Quick Comment Activity

if (QCOA !== undefined) {
  window.alert("QCOA is alreday defined");
}

var QCOA = (function() {
  var init = function(){
    var quickCommentStatus = $("#activity-stream-quick-comment-status");
    var quickCommentContent = $("#activity-stream-quick-comment-content");

    $("#activity-stream-quick-comment").click(function(e) {
      e.preventDefault();
      var content = quickCommentContent.val();
      quickCommentStatus.html("<p><font color='#B0C92E'>Adding Commment...</font></p>");
      if (content !== "")
      {
        var leadId   = $("[data-behavior='quick-add-activity']").data("info-lead");
        var response = $.post("/activity/stream/quick/comment", { lead_id: leadId , content: content });
        response.always(function() {
          var status = response.responseText;
          if ( status == "success" ) {
            $("#activity-form-quick-comment").load(location.href + " #activity-form-quick-comment");
            quickCommentContent.val("");
            quickCommentStatus.html("<p><font color='green'>Comment Added!</font></p>");
            $.ajax({ url: "/activities/recent?activities_owner_id="+ leadId +"&activities_owner_type=Lead&replace_feed=true"});
          }else {
            alert("sorry there was an error creating your comment. please try again");
            quickCommentStatus.html("<p><font color='red'>Error adding comment, please try again...</font></p>");
          }
        });
      }else {
        quickCommentStatus.html("<p><font color='red'>Please enter text in the content box</font></p>");
      }
    });

    quickCommentContent.keypress(function() {
      quickCommentStatus.html("<p><font color='#A4B6BD'>typing...</font></p>");
    });

    quickCommentContent
    .focusout(function() {
      quickCommentStatus.html("");
    })
    .blur(function() {
      quickCommentStatus.html("");
    });
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  if($("[data-behavior='quick-add-activity']").length) {
    QCOA.init();
  }
});

if (LE !== undefined) {
  window.alert("LE is alreday defined");
}

var LE = (function() {
  var load = function(){
    var contactId = $("[data-behavior='email-messages-list']").data("info-contact");
    $.ajax({
      url: "/nylas_accounts/messages?contact_id=" + contactId,
      cache: false,
      success: function(html){
        $("[data-behavior='email-messages-list']").html(html);
      }
    });
  };

  var init = function(){
    if($("[data-behavior='email-messages-list']").length > 0) {
      load();
    }
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  LE.init();
});

// LCNRI => Load Contact Nylas Report Info

if (LCNRI !== undefined) {
  window.alert("LCNRI is alreday defined");
}

var LCNRI = (function() {
  var load = function(element){
    var contactId = element.data("contact-id");
    $.ajax({
      url: "/contacts/" + contactId + "/nylas_report_info",
      cache: false,
      success: function(html){
        element.replaceWith(html);
      }
    });
  };

  var init = function(){
    var element = $("[data-behavior='contact-nylas-report-info']");

    if(element.length > 0) {
      load(element);
    }
  };

  return { "init": init };
})();

document.addEventListener("turbolinks:load", function(){
  LCNRI.init();
});

if (FSR !== undefined) {
  window.alert("FSR is alreday defined");
}

var FSR = (function() {
  var load = function(){
    var emailAddress = $("[data-behavior='survey_results']").data("email-address");
    $.ajax({
      url: "/public/survey_results/fetch_result?email_address=" + emailAddress,
      cache: false,
      success: function(html){
        $("[data-behavior='survey_results']").replaceWith(html);
        $('[data-behavior=dimmer]').dimmer('hide');
      }
    });
  };

  var init = function(){
    if($("[data-behavior='survey_results']").length) {
      $('[data-behavior=dimmer]').dimmer('show');
      load();
    }
  };

  return { "init": init };
})();


$(document).on('turbolinks:load', function() {
  FSR.init();
});

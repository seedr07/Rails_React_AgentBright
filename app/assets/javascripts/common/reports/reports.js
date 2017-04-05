if (REPORTS !== undefined) {
  window.alert("REPORTS is already defined");
}

var REPORTS = (function() {

  var closedReports = function() {
    $('[data-ui-behavior=tab]').tab();
  }

  var leadSourceReports = function() {
    $('[data-ui-behavior=tab]').tab({'onVisible':function(){
      Chartkick.eachChart( function(chart) {
        chart.redraw()
      })
    }});
  }

  var init = function() {
    if ($('[data-behavior=closed-reports]').length){
      closedReports();
    }
    if ($("[data-behavior=lead-source-reports]").length){
      leadSourceReports();
    }
  }

  return { "init": init }

})();

document.addEventListener("turbolinks:load", function(){
  REPORTS.init();
});

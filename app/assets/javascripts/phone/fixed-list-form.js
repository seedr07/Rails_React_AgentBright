(function ($) {
  $.extend({
    focusOnFirstField: function (sectionID) {
      var $firstInput;
      $firstInput = $("#" + sectionID).find("form")
        .find("input[type!='hidden'], select[type!='hidden']").first();
      if (!$firstInput.is("select")) {
        $firstInput.focus();
      }
    }
  });
})(jQuery);

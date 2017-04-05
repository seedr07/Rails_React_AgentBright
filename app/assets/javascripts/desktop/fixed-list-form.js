(function ($) {
  $.extend({
    focusOnFirstField: function (sectionID) {
      var $firstInput;
      $firstInput = $("#" + sectionID).find("form")
        .find("input[type!='hidden'], select[type!='hidden']").first();

      $firstInput.focus();
    }
  });
})(jQuery);

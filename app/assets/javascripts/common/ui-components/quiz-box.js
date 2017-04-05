$(document).on('change', 'input:radio[data-quizbox-toggle~=true]', function (event) {

  var changedInput = $(this);
  var quizGroup = changedInput.closest(".quiz-group");

  var quizInputs = quizGroup.find("[data-quizbox-toggle~=true]");
  var quizFollowUps = quizGroup.find(".quiz-follow-up-wrap");

  quizInputs.each(function() {
    var quizInput = $(this);
    var revealClass = $(this).attr("data-quizbox-reveal");

    quizFollowUps.each(function() {
      var quizFollowUp = $(this);

      if (quizFollowUp.hasClass(revealClass)) {
        if (quizInput.is(':checked')) {
          quizFollowUp.addClass("is-visible");
        }
        else {
          quizFollowUp.removeClass("is-visible");
        }
      }
    });
  });
});

$(document).on("click", "[data-show-tab]", function() {
  var clickedItem = $(this);
  var tab = clickedItem.attr("data-show-tab");

  $('#' + tab).tab('show');
});

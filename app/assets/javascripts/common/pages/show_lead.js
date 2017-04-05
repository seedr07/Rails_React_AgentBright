$(document).on('click', '[data-behavior="show-email-tab"]', function(e) {
  e.preventDefault();
  var emailTabElement = $('a[href="#emails"].withoutripple');
  emailTabElement.tab('show');

  $('html,body').animate({
    scrollTop: emailTabElement.offset().top
  }, 400);

  // Need this SetTimeout, because we show the email content when
  // we click on the email tab. It's like we update virtual content.
  // And due to this focus method doesn't able to find the required input
  // because that input is not here yet. So after setting SetTimeout, it
  // will search that required input after certain time.
  setTimeout(function () {
    var input = $("#emails #subject_email_subject");
    input.focus();
  }, 500);
});

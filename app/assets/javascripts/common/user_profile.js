$(document).on('click', "[data-behavior~=remove-profile-image]", function(){
  $('#remove_profile_image').prop("disabled", false);
  $('#remove_profile_image_message').show();
});

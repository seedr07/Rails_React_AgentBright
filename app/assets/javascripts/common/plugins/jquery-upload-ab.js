// Profile Image Uploader
jQuery.fn.profileImageUpload = function() {
  console.log("activating profileImageUpload");
  var imageUploader = this;
  var hiddenInput = $("[data-behavior~=attach-hidden-field]");
  imageUploader.fileupload({
    type: "POST",
    change: function(e, data) {
      console.log("running imageUploader.fileupload");
      return $(".spinner-row").show();
    },
    done: (function(_this) {
      return function(e, data) {
        var response;
        $(".spinner-row").hide();
        response = jQuery.parseJSON(data.jqXHR.responseText);
        if (response.errors) {
          alert(response.errors.file);
        } else {
          hiddenInput.val(response.id);
          alert("Uploaded image successfully.");
        }
        return console.log(response);
      };
    })(this)
  });
  return this;
};

document.addEventListener("turbolinks:load", function() {
  var imageUploader = $("[data-behavior~=profile-image-uploader]");
  imageUploader.profileImageUpload();
});

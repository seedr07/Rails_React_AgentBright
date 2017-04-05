// Based on http://www.filamentgroup.com/examples/jquery-custom-file-input/

$.fn.customFileInput = function(){

  //apply events and styles for file input element
  var fileInput = $(this)
    .focus(function(){
      fileInput.data('val', fileInput.val());
    })
    .blur(function(){
      $(this).trigger('checkChange');
     })
    .bind('checkChange', function(){
      if(fileInput.val() && fileInput.val() != fileInput.data('val')){
        fileInput.trigger('change');
      }
    })
    .bind('change',function(){
      //get file name
      var fileName = $(this).val().split(/\\/).pop();
      //get file extension
      uploadFeedback
        .text(fileName) //set feedback text to filename
      //change text of button
      uploadButton.text('Change');
    })
    .click(function(){ //for IE and Opera, make sure change fires after choosing a file, using an async callback
      fileInput.data('val', fileInput.val());
      setTimeout(function(){
        fileInput.trigger('checkChange');
      },100);
    });

  var upload = fileInput.parent();
  var uploadButton = $('.button', upload);
  var uploadFeedback = $('.filename', upload);

  //on mousemove, keep file input under the cursor to steal click
  upload
    .mousemove(function(e){
      fileInput.css({
        //'left': e.pageX - upload.offset().left - fileInput.outerWidth() + 20, //position right side 20px right of cursor X)
        //'top': e.pageY - upload.offset().top - $(window).scrollTop() - 3
      });
    })
  //return jQuery
  return $(this);
};

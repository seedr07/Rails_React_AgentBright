document.addEventListener('turbolinks:load', function() {
  console.log("toastr-ab.js is working");
  toastr.options = {
    "closeButton": true,
    "debug": false,
    "positionClass": "toast-top-right",
    "progressBar": "true",
    "onclick": null,
    "showDuration": "300",
    "hideDuraction": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };
});

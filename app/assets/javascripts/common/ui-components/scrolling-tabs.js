document.addEventListener('turbolinks:load', function() {
  var tabItems = $('.nav-tabs a'),
      tabContentWrapper = $('.tab-content');

  //hide the .cd-tabs::after element when tabbed navigation has scrolled to the end (mobile version)
  checkScrolling($('.tabbed-section .tab-row'));
  $(window).on('resize', function() {
    checkScrolling($('.tabbed-section .tab-row'));
    tabContentWrapper.css('height', 'auto');
  });
  $('.tabbed-section .tab-row').on('scroll', function() {
    checkScrolling($(this));
  });

  function checkScrolling(tabs) {
    var totalTabWidth = parseInt(tabs.children('.nav-tabs').width()),
      tabsViewport = parseInt(tabs.width());
    if (tabs.scrollLeft() >= totalTabWidth - tabsViewport) {
      tabs.parent('.tabbed-section').addClass('is-ended');
    } else {
      tabs.parent('.tabbed-section').removeClass('is-ended');
    }
  }
});

// Sidebar sliding navigation
$(document).on("click","[data-behavior=show-main-nav-menu]", function() {
  if ($("body").hasClass("menu-active")) {
    // if it's open then just close it
    $("body").removeClass("menu-active ovf-hidden");
    $(".second-nav").removeClass("menu-active");
  } else {
    // if it's closed, then close everything else and open it
    $("body").removeClass("menu-active ovf-hidden");
    $(".navtoggle").removeClass("narrow");
    $(".second-nav").removeClass("menu-active").addClass("menu-active");
    $("body").addClass("menu-active ovf-hidden");
  }
});

// Toggle the submenu in the sidenav
$(document).on("click", "[data-behavior=toggle-submenu]", function() {
  if ($("body").hasClass("submenu-active")) {
    $("body").removeClass("submenu-active ovf-hidden");
    $(this).removeClass("selected");
  } else {
    $("body").addClass("submenu-active ovf-hidden");
    $(this).removeClass("selected").addClass("selected");
  }
});

// Toggle the sidebar between narrow and wide
$(document).on("click", ".nav-arrow-button", function() {
  // Toggle size of menu
  if ($(".navtoggle").hasClass("narrow")) {
    $(".navtoggle").removeClass("narrow");
  } else {
    $(".navtoggle").removeClass("narrow").addClass("narrow");
  }

  // Toggle which direction the arrow is pointing
  var navToggleBtn = $("#div-nav-arrow-button");
  var isNarrow = false;
  if (navToggleBtn.hasClass("fui-arrow-left")) {
    isNarrow = true;
    navToggleBtn.removeClass("fui-arrow-left").addClass("fui-arrow-right");
  } else {
    isNarrow = false;
    navToggleBtn.removeClass("fui-arrow-right").addClass("fui-arrow-left");
  }

  // Save the state of the sidebar to the database
  $.get("/show_narrow_main_nav_bar", { is_narrow: isNarrow});
});

// Toggle the account submenu
$(document).on("click", "[data-behavior=show-account-submenu]", function() {
  if ($("body").hasClass("submenu-active")) {
    // if it"s open then just close it
    $("body").removeClass("submenu-active ovf-hidden");
    $('[data-behavior=toggle-submenu]').removeClass("selected");
  } else {
    // if it's closed, then close everything else and open it
    $("body").removeClass("submenu-active ovf-hidden").addClass("submenu-active ovf-hidden");
    $("[data-behavior=toggle-submenu]").removeClass("selected").addClass("selected");
    $(".navtoggle").removeClass("narrow");
  }
});

// Header overlay navigation
document.addEventListener("turbolinks:load", function() {
  var onIosDevice;
  var $currentScrollPosition;

  if (navigator.userAgent.match(/(iPhone|iPod|iPad)/i)) {
    onIosDevice = true;
    $(window).scroll(function() {
      $currentScrollPosition = $(document).scrollTop();
    });
  }

  $(document).on("click", "[data-behavior=open-navigation-overlay]", function(e) {
    $("body").addClass("mobile-overlay ovf-hidden");
    $(".navigation-overlay").css({visibility: "visible", zIndex: "10000"});
    if (onIosDevice === true) {
      $("body").css({"position": "fixed"});
      localStorage.cachedScrollPos = $currentScrollPosition;
    }
    e.preventDefault();
  });

  $(document).on("click", ".close-overlay", function() {
    if (onIosDevice === true) {
      $("body").css({"position": "relative"});
      $("body").scrollTop(localStorage.cachedScrollPos);
    }
    $("body").removeClass("mobile-overlay ovf-hidden");
    $(this).closest(".navigation-overlay").css({visibility: "hidden", zIndex: "-5"});
  });
});

$(document).on("click", "[data-behavior=open-account-menu]", function() {
  var $accountMenu = $(".account-menu");
  if ($accountMenu.hasClass("account-menu--active")) {
    $accountMenu.removeClass("account-menu--active");
    $(document).off("click.turnOffMenu");
  } else {
    $accountMenu.addClass("account-menu--active");
    $(document).on("click.turnOffMenu", hideMenuOnOutsideClick);
  }

  function hideMenuOnOutsideClick(event) {
    if (!$(event.target).closest(".account-menu").length) {
      if ($(".account-menu").hasClass("account-menu--active")) {
        $(".account-menu").removeClass("account-menu--active");
        $(document).off("click.turnOffMenu");
      }
    }
  }
});

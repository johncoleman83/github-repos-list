var mainNavContainerTop, mainNavContainerContainerHeight, onMainNavButtonPressed = function () {
    $("#main-nav").hasClass("visible") ? $("#main-nav").removeClass("visible") : $("#main-nav").addClass("visible"), onResize()
}, onResize = function () {
    mainNavContainerTop = $(".main-nav-container-container").offset().top, mainNavContainerContainerHeight = $("#main-nav-container").outerHeight(!0), $(".main-nav-container-container").css("min-height", mainNavContainerContainerHeight + "px"), $(".main-nav-container-container").width("100%")
}, onScroll = function () {
    var n = $("body").scrollTop(),
        i = $("html").scrollTop(),
        a = 0 != i ? i : n;
    a > mainNavContainerTop ? $("#main-nav-container.has_content").addClass("fixed") : $("#main-nav-container.has_content").removeClass("fixed")
}, init = function () {
    document.domain = window.location.hostname.match(/\.theknot.com/) ? "theknot.com" : window.location.hostname, onResize(), $("button.main-nav").click(onMainNavButtonPressed), checkTheme(), checkEditButton(), resizeImage(), disableTurbolinks()
};
$(window).scroll(onScroll), $(window).resize(onResize), $(document).ready(init), $(document).on("page:load", function () {
    init()
});
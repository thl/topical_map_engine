// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.observe("dom:loaded", function(){
  jQuery("#sideMenuLink").css("background-position", "0% 0%");
  jQuery("#fxSideMenu").fadeOut("fast");
});
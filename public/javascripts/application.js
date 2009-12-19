var delay = 6000;
var speed = 700;

function scrollEvents() {
  var move = function (e) {
    return function() {
      $(e).remove().css('display', 'none !important').prependTo("#events");
    }
  }
  
  $("#events li:hidden").filter(":last").slideDown(speed);
  
  var e = $("#events li:visible").filter(":last");
  e.slideUp(speed, move(e));

  setTimeout('scrollEvents()', delay);
}    
$(document).ready(function() {
  setTimeout('scrollEvents()', delay);
});
